import pool from '../config/db.js';

const designationTable = {
    create: async (data) => {
        const { title } = data;
        const query = 'INSERT INTO designations (title) VALUES ($1) RETURNING *';
        const resp = await pool.query(query, [title]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const res = await pool.query('SELECT * FROM designations WHERE id = $1 ORDER BY title ASC', [id]);
            return res.rows[0];
        }

        const res = await pool.query('SELECT * FROM designations ORDER BY title ASC');
        return res.rows;
    },

    update: async (data) => {
        const { id, title } = data;
        const query = 'UPDATE designations SET title = $2 WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id, title]);
        return resp.rows[0];
    },

    delete: async (id) => {
        const query = 'DELETE FROM designations WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },
};

export default designationTable;
