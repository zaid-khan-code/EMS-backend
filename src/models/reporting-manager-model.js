import pool from '../config/db.js';

const reportingManagerTable = {
    create: async (data) => {
        const { manager_name, department_id = null } = data;
        const query = 'INSERT INTO reporting_managers (manager_name, department_id) VALUES ($1, $2) RETURNING *';
        const resp = await pool.query(query, [manager_name, department_id]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const query = `
                SELECT rm.*, dep.name AS department_name
                FROM reporting_managers rm
                LEFT JOIN departments dep ON rm.department_id = dep.id
                WHERE rm.id = $1
            `;
            const res = await pool.query(query, [id]);
            return res.rows[0];
        }

        const query = `
            SELECT rm.*, dep.name AS department_name
            FROM reporting_managers rm
            LEFT JOIN departments dep ON rm.department_id = dep.id
            ORDER BY dep.name ASC, rm.manager_name ASC
        `;
        const res = await pool.query(query);
        return res.rows;
    },

    readByDepartment: async (departmentId) => {
        const query = `
            SELECT rm.*, dep.name AS department_name
            FROM reporting_managers rm
            LEFT JOIN departments dep ON rm.department_id = dep.id
            WHERE rm.department_id = $1
            ORDER BY rm.manager_name ASC
        `;
        const res = await pool.query(query, [departmentId]);
        return res.rows;
    },

    update: async (data) => {
        const { id, manager_name, department_id } = data;
        const query = 'UPDATE reporting_managers SET manager_name = $2, department_id = $3 WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id, manager_name, department_id]);
        return resp.rows[0];
    },

    delete: async (id) => {
        const query = 'DELETE FROM reporting_managers WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },

    findByName: async (managerName, excludeId = null) => {
        const query = excludeId
            ? 'SELECT * FROM reporting_managers WHERE manager_name = $1 AND id != $2'
            : 'SELECT * FROM reporting_managers WHERE manager_name = $1';
        const params = excludeId ? [managerName, excludeId] : [managerName];
        const res = await pool.query(query, params);
        return res.rows[0];
    },
};

export default reportingManagerTable;
