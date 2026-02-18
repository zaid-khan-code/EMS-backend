import pool from '../config/db.js';


/*
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL ,
    department_id INT NOT NULL,
    designation_id INT NOT NULL,
    employment_type_id INT NOT NULL,
    job_status_id INT NOT NULL,
    date_of_joining DATE NOT NULL,
    date_of_exit DATE,
         */
const extraEmployeeInfoTable = {
    create: async (data) => {
        const {
            employee_id,
            contact_1,
            contact_2 = null,
            emergence_contact_1 = null,
            emergence_contact_2 = null,
            bank_name = null,
            bank_acc_num = null,
            perment_address = null,
            postal_address = null,
            date_of_birth,
        } = data;

        const query = `
      INSERT INTO extra_employee_info
      (employee_id, contact_1, contact_2, emergence_contact_1, emergence_contact_2,
       bank_name, bank_acc_num, perment_address, postal_address, date_of_birth)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
      RETURNING *
    `;
        const resp = await pool.query(query, [
            employee_id,
            contact_1,
            contact_2,
            emergence_contact_1,
            emergence_contact_2,
            bank_name,
            bank_acc_num,
            perment_address,
            postal_address,
            date_of_birth,
        ]);
        return resp.rows[0];
    },

    read: async (id) => {
        if (id) {
            const res = await pool.query(
                'SELECT * FROM extra_employee_info WHERE id = $1',
                [id]
            );
            return res.rows[0];
        }
        const res = await pool.query('SELECT * FROM extra_employee_info');
        return res.rows;
    },

    update: async (data) => {
        const {
            id,
            employee_id,
            contact_1,
            contact_2 = null,
            emergence_contact_1 = null,
            emergence_contact_2 = null,
            bank_name = null,
            bank_acc_num = null,
            perment_address = null,
            postal_address = null,
            date_of_birth,
        } = data;

        const query = `
      UPDATE extra_employee_info
      SET employee_id = $2,
          contact_1 = $3,
          contact_2 = $4,
          emergence_contact_1 = $5,
          emergence_contact_2 = $6,
          bank_name = $7,
          bank_acc_num = $8,
          perment_address = $9,
          postal_address = $10,
          date_of_birth = $11,
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $1
      RETURNING *
    `;
        const resp = await pool.query(query, [
            id,
            employee_id,
            contact_1,
            contact_2,
            emergence_contact_1,
            emergence_contact_2,
            bank_name,
            bank_acc_num,
            perment_address,
            postal_address,
            date_of_birth,
        ]);
        return resp.rows[0];
    },

    delete: async (id) => {
        const query = 'DELETE FROM extra_employee_info WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },
};

export default extraEmployeeInfoTable;
