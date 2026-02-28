import pool from '../config/db.js';

const reportingManagerTable = {
    create: async (data) => {
        const { manager_name } = data;
        const query = 'INSERT INTO reporting_managers (manager_name) VALUES ($1) RETURNING *';
        const resp = await pool.query(query, [manager_name]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const res = await pool.query(
                'SELECT * FROM reporting_managers WHERE id = $1 ORDER BY manager_name ASC',
                [id]
            );
            return res.rows[0];
        }

        const res = await pool.query('SELECT * FROM reporting_managers ORDER BY manager_name ASC');
        return res.rows;
    },

    update: async (data) => {
        const { id, manager_name } = data;
        const query = 'UPDATE reporting_managers SET manager_name = $2 WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id, manager_name]);
        return resp.rows[0];
    },

    delete: async (id) => {
        const query = 'DELETE FROM reporting_managers WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },
};

export default reportingManagerTable;
