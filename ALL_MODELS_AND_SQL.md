# Complete EMS Backend - All Model Files and Database Schema

---

## Model Files Documentation

### 1. auth-model.js

**File Name:** `auth-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const authTable = {
  findByUsername: async (username) => {
    const res = await pool.query(
      `SELECT * FROM users WHERE username = $1 AND is_active = true`,
      [username],
    );
    return res.rows[0];
  },
};

export default authTable;
```

---

### 2. user-model.js

**File Name:** `user-model.js`

**Complete Code:**

```javascript
// src/models/user-model.js
import pool from "../config/db.js";

const userTable = {
  create: async (data) => {
    const { username, password, employee_id } = data;
    const query = `
            INSERT INTO users (username, password, employee_id) 
            VALUES ($1, $2, $3) 
            RETURNING id, username, role, is_active, employee_id, created_at
        `;
    const res = await pool.query(query, [username, password, employee_id]);
    return res.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        `SELECT 
                    u.id, u.username, u.role, u.is_active,
                    u.employee_id, e.name as employee_name, u.created_at
                FROM users u
                LEFT JOIN employee_info e ON u.employee_id = e.employee_id
                WHERE u.id = $1`,
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      `SELECT 
                u.id, u.username, u.role, u.is_active,
                u.employee_id, e.name as employee_name, u.created_at
            FROM users u
            LEFT JOIN employee_info e ON u.employee_id = e.employee_id
            ORDER BY u.created_at DESC`,
    );
    return res.rows;
  },

  updateStatus: async (data) => {
    const { id, is_active } = data;
    const query = `
            UPDATE users 
            SET is_active = $2, updated_at = CURRENT_TIMESTAMP 
            WHERE id = $1 
            RETURNING id, username, role, is_active
        `;
    const res = await pool.query(query, [id, is_active]);
    return res.rows[0];
  },

  delete: async (id) => {
    const query = `
            DELETE FROM users 
            WHERE id = $1 AND role != 'super_admin' 
            RETURNING id, username
        `;
    const res = await pool.query(query, [id]);
    return res.rows[0];
  },

  checkUsername: async (username) => {
    const res = await pool.query(`SELECT id FROM users WHERE username = $1`, [
      username,
    ]);
    return res.rows[0];
  },
};

export default userTable;
```

---

### 3. employee-info-model.js

**File Name:** `employee-info-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";
const employeeTable = {
  create: async (data) => {
    const { employee_id, name, father_name, cnic, date_of_birth } = data;

    const query =
      "INSERT INTO employee_info (employee_id, name, father_name, cnic, date_of_birth) VALUES ($1,$2,$3,$4,$5) RETURNING *";
    const resp = await pool.query(query, [
      employee_id,
      name,
      father_name,
      cnic,
      date_of_birth,
    ]);
    return resp.rows[0];
  },
  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM employee_info WHERE id = $1 ORDER BY employee_id ASC",
        [id],
      );
      return res.rows[0];
    }
    const res = await pool.query(
      "SELECT * FROM employee_info ORDER BY employee_id ASC",
    );
    return res.rows;
  },
  readIds: async () => {
    const res = await pool.query(
      "SELECT employee_id FROM employee_info ORDER BY employee_id ASC",
    );
    return res.rows;
  },
  update: async (data) => {
    const { id, employee_id, name, father_name, cnic, date_of_birth } = data;
    const query =
      "UPDATE employee_info SET employee_id = $2,name = $3, father_name= $4, cnic= $5,date_of_birth=$6 ,updated_at = CURRENT_TIMESTAMP  WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [
      id,
      employee_id,
      name,
      father_name,
      cnic,
      date_of_birth,
    ]);
    return resp.rows[0];
  },
  delete: async (id) => {
    const query = "DELETE FROM employee_info WHERE id = $1 RETURNING * ";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};
export default employeeTable;
```

---

### 4. extra-employee-info-model.js

**File Name:** `extra-employee-info-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const extraEmployeeInfoTable = {
  create: async (data) => {
    const {
      employee_id,
      contact_1,
      contact_2 = null,
      emergence_contact_1 = null,
      emergence_contact_2,
      bank_name = null,
      bank_acc_num = null,
      perment_address,
      postal_address,
    } = data;

    const query = `
      INSERT INTO extra_employee_info
      (employee_id, contact_1, contact_2, emergence_contact_1, emergence_contact_2,
       bank_name, bank_acc_num, perment_address, postal_address )
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
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
    ]);
    return resp.rows[0];
  },

  read: async () => {
    const res = await pool.query(
      "SELECT * FROM employee_info e LEFT JOIN extra_employee_info ex USING (employee_id) ORDER BY e.employee_id ASC;",
    );
    return res.rows;
  },

  update: async (data) => {
    const {
      id,
      employee_id,
      contact_1,
      contact_2 = null,
      emergence_contact_1 = null,
      emergence_contact_2,
      bank_name = null,
      bank_acc_num = null,
      perment_address,
      postal_address,
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
    ]);
    return resp.rows[0];
  },
};

export default extraEmployeeInfoTable;
```

---

### 5. job-info-model.js

**File Name:** `job-info-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";
const baseSelect = `
  SELECT
    j.id,
    j.employee_id,
    j.department_id,
    j.designation_id,
    j.employment_type_id,
    j.job_status_id,
    j.work_mode_id,
    j.work_location_id,
    j.reporting_manager_id,
    j.shift_timing,
    j.date_of_joining,
    j.date_of_exit,
    j.created_at,
    j.updated_at,
    e.name AS employee_name,
    d.name AS department_name,
    ds.title AS designation_title,
    et.type_name AS employment_type_name,
    js.status_name AS job_status_name,
    wm.mode_name AS work_mode_name,
    wl.location_name AS work_location_name,
    rm.manager_name AS reporting_manager_name
  FROM job_info j
  INNER JOIN employee_info e ON e.employee_id = j.employee_id
  INNER JOIN departments d ON d.id = j.department_id
  INNER JOIN designations ds ON ds.id = j.designation_id
  INNER JOIN employment_types et ON et.id = j.employment_type_id
  INNER JOIN job_statuses js ON js.id = j.job_status_id
  INNER JOIN work_modes wm ON wm.id = j.work_mode_id
  INNER JOIN work_locations wl ON wl.id = j.work_location_id
  INNER JOIN reporting_managers rm ON rm.id = j.reporting_manager_id
`;

const jobInfoTable = {
  create: async (data) => {
    const {
      employee_id,
      department_id,
      designation_id,
      employment_type_id,
      job_status_id,
      work_mode_id,
      work_location_id,
      reporting_manager_id,
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
                work_mode_id,
                work_location_id,
                reporting_manager_id,
                 shift_timing,
                date_of_joining,
                date_of_exit
            )
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
            RETURNING *
        `;
    const resp = await pool.query(query, [
      employee_id,
      department_id,
      designation_id,
      employment_type_id,
      job_status_id,
      work_mode_id,
      work_location_id,
      reporting_manager_id,
      shift_timing,
      date_of_joining,
      date_of_exit,
    ]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        `${baseSelect} WHERE j.id = $1 ORDER BY j.id ASC`,
        [id],
      );
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
      work_mode_id,
      work_location_id,
      reporting_manager_id,
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
                work_mode_id = $7,
                work_location_id = $8,
                reporting_manager_id = $9,
                shift_timing = $10,
                date_of_joining = $11,
                date_of_exit = $12,
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
      work_mode_id,
      work_location_id,
      reporting_manager_id,
      shift_timing,
      date_of_joining,
      date_of_exit,
    ]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM job_info WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default jobInfoTable;
```

---

### 6. department-model.js

**File Name:** `department-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const departmentTable = {
  create: async (data) => {
    const { name } = data;
    const query = "INSERT INTO departments (name) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [name]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM departments WHERE id = $1 ORDER BY id ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query("SELECT * FROM departments ORDER BY name ASC");
    return res.rows;
  },

  update: async (data) => {
    const { id, name } = data;
    const query = "UPDATE departments SET name = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, name]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM departments WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default departmentTable;
```

---

### 7. designation-model.js

**File Name:** `designation-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const designationTable = {
  create: async (data) => {
    const { title } = data;
    const query = "INSERT INTO designations (title) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [title]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM designations WHERE id = $1 ORDER BY title ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      "SELECT * FROM designations ORDER BY title ASC",
    );
    return res.rows;
  },

  update: async (data) => {
    const { id, title } = data;
    const query =
      "UPDATE designations SET title = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, title]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM designations WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default designationTable;
```

---

### 8. employment-type-model.js

**File Name:** `employment-type-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const employmentTypeTable = {
  create: async (data) => {
    const { type_name } = data;
    const query =
      "INSERT INTO employment_types (type_name) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [type_name]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM employment_types WHERE id = $1 ORDER BY type_name ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      "SELECT * FROM employment_types ORDER BY type_name ASC",
    );
    return res.rows;
  },

  update: async (data) => {
    const { id, type_name } = data;
    const query =
      "UPDATE employment_types SET type_name = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, type_name]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM employment_types WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default employmentTypeTable;
```

---

### 9. job-status-model.js

**File Name:** `job-status-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const jobStatusTable = {
  create: async (data) => {
    const { status_name } = data;
    const query =
      "INSERT INTO job_statuses (status_name) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [status_name]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM job_statuses WHERE id = $1 ORDER BY status_name ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      "SELECT * FROM job_statuses ORDER BY status_name ASC",
    );
    return res.rows;
  },

  update: async (data) => {
    const { id, status_name } = data;
    const query =
      "UPDATE job_statuses SET status_name = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, status_name]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM job_statuses WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default jobStatusTable;
```

---

### 10. reporting-manager-model.js

**File Name:** `reporting-manager-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const reportingManagerTable = {
  create: async (data) => {
    const { manager_name } = data;
    const query =
      "INSERT INTO reporting_managers (manager_name) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [manager_name]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM reporting_managers WHERE id = $1 ORDER BY manager_name ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      "SELECT * FROM reporting_managers ORDER BY manager_name ASC",
    );
    return res.rows;
  },

  update: async (data) => {
    const { id, manager_name } = data;
    const query =
      "UPDATE reporting_managers SET manager_name = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, manager_name]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM reporting_managers WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default reportingManagerTable;
```

---

### 11. work-location-model.js

**File Name:** `work-location-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const workLocationTable = {
  create: async (data) => {
    const { location_name } = data;
    const query =
      "INSERT INTO work_locations (location_name) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [location_name]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM work_locations WHERE id = $1 ORDER BY location_name ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      "SELECT * FROM work_locations ORDER BY location_name ASC",
    );
    return res.rows;
  },

  update: async (data) => {
    const { id, location_name } = data;
    const query =
      "UPDATE work_locations SET location_name = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, location_name]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM work_locations WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default workLocationTable;
```

---

### 12. work-mode-model.js

**File Name:** `work-mode-model.js`

**Complete Code:**

```javascript
import pool from "../config/db.js";

const workModeTable = {
  create: async (data) => {
    const { mode_name } = data;
    const query = "INSERT INTO work_modes (mode_name) VALUES ($1) RETURNING *";
    const resp = await pool.query(query, [mode_name]);
    return resp.rows[0];
  },

  read: async (id) => {
    if (id) {
      const res = await pool.query(
        "SELECT * FROM work_modes WHERE id = $1 ORDER BY mode_name ASC",
        [id],
      );
      return res.rows[0];
    }

    const res = await pool.query(
      "SELECT * FROM work_modes ORDER BY mode_name ASC",
    );
    return res.rows;
  },

  update: async (data) => {
    const { id, mode_name } = data;
    const query =
      "UPDATE work_modes SET mode_name = $2 WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id, mode_name]);
    return resp.rows[0];
  },

  delete: async (id) => {
    const query = "DELETE FROM work_modes WHERE id = $1 RETURNING *";
    const resp = await pool.query(query, [id]);
    return resp.rows[0];
  },
};

export default workModeTable;
```

---

## Database Schema

### File Name: creatingtables.sql

**Complete SQL Code:**

```sql
CREATE TABLE employee_info (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    father_name VARCHAR(100) NOT NULL,
    cnic VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE extra_employee_info (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL,
    contact_1 VARCHAR(15) NOT NULL,
    contact_2 VARCHAR(15),
    emergence_contact_1 VARCHAR(15),
    emergence_contact_2 VARCHAR(15),
    bank_name VARCHAR(100),
    bank_acc_num VARCHAR(15),
    perment_address VARCHAR(255),
    postal_address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_employee_info_id FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id)
);

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE designations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE employment_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE job_statuses (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE work_modes (
    id SERIAL PRIMARY KEY,
    mode_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE work_locations (
    id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE reporting_managers (
    id SERIAL PRIMARY KEY,
    manager_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE job_info (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL,
    department_id INT NOT NULL,
    designation_id INT NOT NULL,
    employment_type_id INT NOT NULL,
    job_status_id INT NOT NULL,
    work_mode_id INT NOT NULL,
    work_location_id INT NOT NULL,
    reporting_manager_id INT NOT NULL,
    shift_timing VARCHAR(50),
    date_of_joining DATE NOT NULL,
    date_of_exit DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_job_info_id FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id),
    CONSTRAINT fk_job_department_id FOREIGN KEY (department_id) REFERENCES departments(id),
    CONSTRAINT fk_job_designation_id FOREIGN KEY (designation_id) REFERENCES designations(id),
    CONSTRAINT fk_job_employment_type_id FOREIGN KEY (employment_type_id) REFERENCES employment_types(id),
    CONSTRAINT fk_job_status_id FOREIGN KEY (job_status_id) REFERENCES job_statuses(id),
    CONSTRAINT fk_job_work_mode_id FOREIGN KEY (work_mode_id) REFERENCES work_modes(id),
    CONSTRAINT fk_job_work_location_id FOREIGN KEY (work_location_id) REFERENCES work_locations(id),
    CONSTRAINT fk_job_reporting_manager_id FOREIGN KEY (reporting_manager_id) REFERENCES reporting_managers(id)
);
```

---

## Summary

**Total Files Documented:**

- 12 Model Files (JavaScript)
- 1 Database Schema File (SQL)

**All files have been opened and displayed with their complete, unmodified code.**
