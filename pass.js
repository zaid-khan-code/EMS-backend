import bcrypt from 'bcrypt';

// const bcrypt = require('bcrypt');

async function main() {
  const hashed = await bcrypt.hash("admin123", 10);
  console.log(hashed);
}

main();