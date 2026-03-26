import pool from '../config/db.js';

const payrollComponentTable = {
    create: async (data) => {
        const { name, type, is_taxable = false, is_active = true, display_order = 0 } = data;
        const query = `
            INSERT INTO payroll_components (name, type, is_taxable, is_active, display_order)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING *
        `;
        const resp = await pool.query(query, [name, type, is_taxable, is_active, display_order]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const res = await pool.query('SELECT * FROM payroll_components WHERE id = $1', [id]);
            return res.rows[0];
        }
        const res = await pool.query('SELECT * FROM payroll_components ORDER BY type, display_order, name');
        return res.rows;
    },

    readByType: async (type) => {
        const query = 'SELECT * FROM payroll_components WHERE type = $1 ORDER BY display_order, name';
        const res = await pool.query(query, [type]);
        return res.rows;
    },

    readActive: async () => {
        const query = 'SELECT * FROM payroll_components WHERE is_active = true ORDER BY type, display_order, name';
        const res = await pool.query(query);
        return res.rows;
    },

    update: async (data) => {
        const { id, name, type, is_taxable, is_active, display_order } = data;
        const query = `
            UPDATE payroll_components
            SET name = $2,
                type = $3,
                is_taxable = $4,
                is_active = $5,
                display_order = $6,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = $1
            RETURNING *
        `;
        const resp = await pool.query(query, [id, name, type, is_taxable, is_active, display_order]);
        return resp.rows[0];
    },

    delete: async (id) => {
        const query = 'DELETE FROM payroll_components WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },

    findByName: async (name, excludeId = null) => {
        const query = excludeId
            ? 'SELECT * FROM payroll_components WHERE name = $1 AND id != $2'
            : 'SELECT * FROM payroll_components WHERE name = $1';
        const params = excludeId ? [name, excludeId] : [name];
        const res = await pool.query(query, params);
        return res.rows[0];
    },
};

export default payrollComponentTable;
