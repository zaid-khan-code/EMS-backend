import pool from '../config/db.js';
const baseSelect = `
  SELECT
    j.id,
    j.employee_id,
    j.department_id,
    j.designation_id,
    j.employment_type_id,
    j.job_status_id,
    j.shift_timing,
    j.date_of_joining,
    j.date_of_exit,
    j.created_at,
    j.updated_at,
    e.name AS employee_name,
    d.name AS department_name,
    ds.title AS designation_title,
    et.type_name AS employment_type_name,
    js.status_name AS job_status_name
  FROM job_info j
  INNER JOIN employee_info e ON e.employee_id = j.employee_id
  INNER JOIN departments d ON d.id = j.department_id
  INNER JOIN designations ds ON ds.id = j.designation_id
  INNER JOIN employment_types et ON et.id = j.employment_type_id
  INNER JOIN job_statuses js ON js.id = j.job_status_id
`;

const jobInfoTable = {
    create: async (data) => {
        const {
            employee_id,
            department_id,
            designation_id,
            employment_type_id,
            job_status_id,
            shift_timing = null,
            date_of_joining,
            date_of_exit = null,
        } = data;

        const query = `
            INSERT INTO job_info
            (
                employee_id,
                department_id,
                designation_id,
                employment_type_id,
                job_status_id,
                shift_timing,
                date_of_joining,
                date_of_exit
            )
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
            RETURNING *
        `;
        const resp = await pool.query(query, [
            employee_id,
            department_id,
            designation_id,
            employment_type_id,
            job_status_id,
            shift_timing,
            date_of_joining,
            date_of_exit,
        ]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const res = await pool.query(`${baseSelect} WHERE j.id = $1 ORDER BY j.id ASC`, [id]);
            return res.rows[0];
        }

        const res = await pool.query(`${baseSelect} ORDER BY j.employee_id ASC`);
        return res.rows;
    },

    update: async (data) => {
        const {
            id,
            employee_id,
            department_id,
            designation_id,
            employment_type_id,
            job_status_id,
            shift_timing = null,
            date_of_joining,
            date_of_exit = null,
        } = data;

        const query = `
            UPDATE job_info
            SET employee_id = $2,
                department_id = $3,
                designation_id = $4,
                employment_type_id = $5,
                job_status_id = $6,
                shift_timing = $7,
                date_of_joining = $8,
                date_of_exit = $9,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = $1
            RETURNING *
        `;
        const resp = await pool.query(query, [
            id,
            employee_id,
            department_id,
            designation_id,
            employment_type_id,
            job_status_id,
            shift_timing,
            date_of_joining,
            date_of_exit,
        ]);
        return resp.rows[0];
    },

   
};

export default jobInfoTable;
