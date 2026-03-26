import pool from '../config/db.js';

const taxConfigTable = {
    create: async (data) => {
        const { salary_from, salary_to = null, tax_rate_percent = 0, fixed_amount = 0, is_active = true } = data;
        const query = `
            INSERT INTO tax_config (salary_from, salary_to, tax_rate_percent, fixed_amount, is_active)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING *
        `;
        const resp = await pool.query(query, [salary_from, salary_to, tax_rate_percent, fixed_amount, is_active]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const res = await pool.query('SELECT * FROM tax_config WHERE id = $1', [id]);
            return res.rows[0];
        }
        const res = await pool.query('SELECT * FROM tax_config ORDER BY salary_from ASC');
        return res.rows;
    },

    readActive: async () => {
        const query = 'SELECT * FROM tax_config WHERE is_active = true ORDER BY salary_from ASC';
        const res = await pool.query(query);
        return res.rows;
    },

    update: async (data) => {
        const { id, salary_from, salary_to, tax_rate_percent, fixed_amount, is_active } = data;
        const query = `
            UPDATE tax_config
            SET salary_from = $2,
                salary_to = $3,
                tax_rate_percent = $4,
                fixed_amount = $5,
                is_active = $6,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = $1
            RETURNING *
        `;
        const resp = await pool.query(query, [id, salary_from, salary_to, tax_rate_percent, fixed_amount, is_active]);
        return resp.rows[0];
    },

    delete: async (id) => {
        const query = 'DELETE FROM tax_config WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },

    // Find bracket for a given salary amount
    findBracketForSalary: async (salary) => {
        const query = `
            SELECT * FROM tax_config
            WHERE is_active = true
              AND salary_from <= $1
              AND (salary_to IS NULL OR salary_to >= $1)
            ORDER BY salary_from DESC
            LIMIT 1
        `;
        const res = await pool.query(query, [salary]);
        return res.rows[0];
    },

    // Check for overlapping brackets
    findOverlapping: async (salaryFrom, salaryTo, excludeId = null) => {
        let query = `
            SELECT * FROM tax_config
            WHERE (
                (salary_from <= $1 AND (salary_to IS NULL OR salary_to >= $1))
                OR (salary_from <= $2 AND (salary_to IS NULL OR salary_to >= $2))
                OR (salary_from >= $1 AND (salary_to IS NULL OR salary_to <= $2))
            )
        `;
        const params = [salaryFrom, salaryTo || 999999999];

        if (excludeId) {
            query += ' AND id != $3';
            params.push(excludeId);
        }

        const res = await pool.query(query, params);
        return res.rows;
    },
};

export default taxConfigTable;
