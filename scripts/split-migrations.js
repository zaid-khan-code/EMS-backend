// scripts/split-migrations.js
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const INPUT = path.join(__dirname, '..', 'DDL', 'full_schema.sql');
const OUTPUT_DIR = path.join(__dirname, '..', 'migrations');

if (!fs.existsSync(INPUT)) {
  console.error('❌ full_schema.sql not found in DDL/');
  process.exit(1);
}
if (!fs.existsSync(OUTPUT_DIR)) fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const sql = fs.readFileSync(INPUT, 'utf8');

function extract(pattern) {
  const regex = new RegExp(pattern, 'gis');
  const matches = [];
  let match;
  while ((match = regex.exec(sql)) !== null) {
    matches.push(match[0].trim());
  }
  return matches;
}

const extensions = extract(/CREATE EXTENSION.*?;/gs);
const sequences = extract(/CREATE SEQUENCE[\s\S]*?;/gs);
// Fixed regex to capture full PL/pgSQL functions
const functions = extract(/CREATE (?:OR REPLACE )?\s*FUNCTION[\s\S]*?END;\s*\$\$;/gs);
const tables = extract(/CREATE TABLE[\s\S]*?;/gs);
const constraints = extract(/ALTER TABLE ONLY[\s\S]*?;/gs);
const indexes = extract(/CREATE INDEX[\s\S]*?;/gs);
const triggers = extract(/CREATE TRIGGER[\s\S]*?;/gs);

function writeMigration(filename, upBlocks, downLines) {
  if (upBlocks.length === 0) return;
  const content = `-- Up Migration\n${upBlocks.join('\n\n')}\n\n-- Down Migration\n${downLines.join('\n')}\n`;
  fs.writeFileSync(path.join(OUTPUT_DIR, filename), content, 'utf8');
  console.log(`✅ ${filename} (${upBlocks.length} objects)`);
}

writeMigration('000_enable_extensions.sql', extensions,
  extensions.map(e => {
    const name = e.match(/CREATE EXTENSION.*?"([^"]+)"/i)?.[1] || 'unknown';
    return `DROP EXTENSION IF EXISTS "${name}" CASCADE;`;
  })
);

writeMigration('001_create_sequences.sql', sequences,
  sequences.map(s => {
    const name = s.match(/CREATE SEQUENCE\s+([\w.]+)/i)?.[1] || 'unknown';
    return `DROP SEQUENCE IF EXISTS ${name};`;
  })
);

writeMigration('002_create_functions.sql', functions,
  functions.map(f => {
    const sig = f.match(/CREATE (?:OR REPLACE )?FUNCTION\s+([\w.]+\([^)]*\))/i)?.[1];
    return sig ? `DROP FUNCTION IF EXISTS ${sig};` : `-- TODO: Drop function manually`;
  })
);

writeMigration('003_create_tables.sql', tables,
  tables.map(t => {
    const name = t.match(/CREATE TABLE\s+([\w.]+)/i)?.[1] || 'unknown';
    return `DROP TABLE IF EXISTS ${name} CASCADE;`;
  })
);

writeMigration('004_create_constraints.sql', constraints,
  ['-- Constraints are automatically dropped by DROP TABLE CASCADE in 003_create_tables.sql']
);

writeMigration('005_create_indexes.sql', indexes,
  indexes.map(i => {
    const name = i.match(/CREATE INDEX\s+([\w.]+)/i)?.[1] || 'unknown';
    return `DROP INDEX IF EXISTS ${name};`;
  })
);

writeMigration('006_create_triggers.sql', triggers,
  triggers.map(t => {
    const match = t.match(/CREATE TRIGGER\s+([\w.]+)\s+.*?ON\s+([\w.]+)/i);
    return match ? `DROP TRIGGER IF EXISTS ${match[1]} ON ${match[2]};` : `-- TODO: Drop trigger manually`;
  })
);

console.log('\n🎉 All migration files generated in /migrations');
console.log('⚠️  Quick check: Open each file and verify no manual INSERT INTO pgmigrations exists.');