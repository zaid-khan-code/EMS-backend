import pool from '../config/db.js';
const employeeTable = {
    create: async (data) => {
        const { employee_id, name, father_name, cnic } = data;

        const query = "INSERT INTO employee_info (employee_id, name, father_name, cnic) VALUES ($1,$2,$3,$4) RETURNING *"
        const resp = await pool.query(query, [employee_id, name, father_name, cnic]);
        return resp.rows[0]


    },
    read: async (id) => {

        if (id) {
            const res = await pool.query('SELECT * FROM employee_info WHERE id = $1 ', [id]);
            return res.rows[0];
        }
        const res = await pool.query('SELECT * FROM employee_info');
        return res.rows
    },
    update: async (data) => {
        const { id, employee_id, name, father_name, cnic } = data;

        const query = "UPDATE employee_info SET employee_id = $2,name = $3, father_name= $4, cnic= $5,updated_at = CURRENT_TIMESTAMP  WHERE id = $1 RETURNING *";
        const resp = await pool.query(query, [id, employee_id, name, father_name, cnic]);
        return resp.rows[0];
    },
    delete: async (id) => {
        const query = "DELETE FROM employee_info WHERE id = $1 RETURNING * ";
        const resp = await pool.query(query, [id]);
        return resp.rows[0]
    },
};
export default employeeTable;