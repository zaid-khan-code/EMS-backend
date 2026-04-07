-- ============================================================
-- EMS — Employee Management System
-- Complete Database Schema
-- Electronic Safety & Security (Pvt.) Ltd — ESSPL
-- March 2026
-- ============================================================
-- STATUS LEGEND:
--   CREATED  = already in the database, do not re-run
--   PENDING  = not yet created, run when building that module
--   MIGRATED = table exists but was altered, migration already done
-- ============================================================
-- CURRENT BUILD STATUS (End of Session 2026-03-28):
--   ✓ COMPLETED: 10 CORE MODULES (all backend fully built)
--   PENDING: attendance, leave_requests, payroll, penalties, promotions (waiting for stakeholder meeting)
-- ============================================================
-- Run in order. Dependencies must exist before FKs.
-- ============================================================


-- ============================================================
-- SECTION 1 — USERS (CREATED)
-- HR accounts + super_admin. Employee login pending meeting.
-- role defaults to 'hr'. super_admin inserted once manually.
-- ============================================================

/*
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'hr'
        CHECK (role IN ('super_admin', 'hr')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_users_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id)
);
*/


-- ============================================================
-- SECTION 2 — EMPLOYEE INFO (CREATED)
-- Core employee personal data. Core fields are real columns.
-- Additional custom fields managed via Section 19.
-- ============================================================

/*
CREATE TABLE employee_info (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    father_name VARCHAR(100) NOT NULL,
    cnic VARCHAR(20) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);
*/


-- ============================================================
-- SECTION 3 — EXTRA EMPLOYEE INFO (CREATED)
-- ============================================================

/*
CREATE TABLE extra_employee_info (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE NOT NULL,
    contact_1 VARCHAR(15) NOT NULL,
    contact_2 VARCHAR(15),
    emergence_contact_1 VARCHAR(15),
    emergence_contact_2 VARCHAR(15),
    bank_name VARCHAR(100),
    bank_acc_num VARCHAR(30),
    payment_mode VARCHAR(20)
        CHECK (payment_mode IN ('cash', 'online_transfer', 'cheque')),
    perment_address VARCHAR(255),
    postal_address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_extra_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id)
        ON DELETE CASCADE
);
*/


-- ============================================================
-- SECTION 4 — LOOKUP TABLES (CREATED ✓)
-- All configurable from dashboard. Each has its own CRUD module.
-- designations: CREATED with department_id FK and getByDepartment() method
-- reporting_managers: CREATED with department_id FK and getByDepartment() method
-- ============================================================

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE designations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    department_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_designation_dept
        FOREIGN KEY (department_id) REFERENCES departments(id)
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
    name VARCHAR(100) UNIQUE NOT NULL,
    department_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_manager_dept
        FOREIGN KEY (department_id) REFERENCES departments(id)
);


-- ============================================================
-- SECTION 5 — SHIFTS (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern.
-- Fields: name (unique), start_time, end_time, grace_period (late_after_minutes)
-- Backend model methods: findById(), readAll(), create(), update(), delete()
-- ============================================================

CREATE TABLE shifts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    grace_period INT NOT NULL DEFAULT 15,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO shifts (name, start_time, end_time, grace_period) VALUES
    ('Morning Shift', '09:00', '18:00', 15),
    ('Evening Shift', '14:00', '23:00', 15),
    ('Night Shift',   '22:00', '06:00', 15);


-- ============================================================
-- SECTION 6 — JOB INFO (CREATED + MIGRATED)
-- shift_timing VARCHAR dropped. shift_id FK added.
-- All existing rows point to Morning Shift (id = 1).
-- ============================================================

/*
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
    shift_id INT NOT NULL,
    commission_eligible BOOLEAN DEFAULT false,
    date_of_joining DATE NOT NULL,
    date_of_exit DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_job_employee    FOREIGN KEY (employee_id)          REFERENCES employee_info(employee_id),
    CONSTRAINT fk_job_dept        FOREIGN KEY (department_id)        REFERENCES departments(id),
    CONSTRAINT fk_job_desig       FOREIGN KEY (designation_id)       REFERENCES designations(id),
    CONSTRAINT fk_job_emp_type    FOREIGN KEY (employment_type_id)   REFERENCES employment_types(id),
    CONSTRAINT fk_job_status      FOREIGN KEY (job_status_id)        REFERENCES job_statuses(id),
    CONSTRAINT fk_job_mode        FOREIGN KEY (work_mode_id)         REFERENCES work_modes(id),
    CONSTRAINT fk_job_location    FOREIGN KEY (work_location_id)     REFERENCES work_locations(id),
    CONSTRAINT fk_job_manager     FOREIGN KEY (reporting_manager_id) REFERENCES reporting_managers(id),
    CONSTRAINT fk_job_shift       FOREIGN KEY (shift_id)             REFERENCES shifts(id)
);
*/

-- MIGRATION ALREADY DONE ON EXISTING job_info TABLE:
-- ALTER TABLE job_info ADD COLUMN shift_id INT;
-- UPDATE job_info SET shift_id = 1;
-- ALTER TABLE job_info ALTER COLUMN shift_id SET NOT NULL;
-- ALTER TABLE job_info ADD CONSTRAINT fk_job_shift FOREIGN KEY (shift_id) REFERENCES shifts(id);
-- ALTER TABLE job_info DROP COLUMN shift_timing;


-- ============================================================
-- SECTION 7 — LEAVE TYPES (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern.
-- Fields: name (unique), code (unique), is_active
-- Backend model methods: findById(), readAll(), findByName(), findByCode(), create(), update(), delete()
-- Validation: checks if leave_type used in leave_policies/balances/requests before delete
-- ============================================================

CREATE TABLE leave_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO leave_types (name, code) VALUES
    ('Annual Leave',  'annual'),
    ('Casual Leave',  'casual'),
    ('Medical Leave', 'medical'),
    ('Other',         'other');


-- ============================================================
-- SECTION 8 — LEAVE POLICIES (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern.
-- Fields: leave_type_id (FK), department_id (FK), days_allowed, year
-- Backend model methods: findById(), readAll(), readByYear(), create(), update(), delete()
-- Validation: unique constraint (leave_type_id, year), checks if used in leave_balances before delete
-- ============================================================

CREATE TABLE leave_policies (
    id SERIAL PRIMARY KEY,
    department_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    days_allowed INT NOT NULL CHECK (days_allowed >= 0),
    year INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT unique_policy_per_type_year
        UNIQUE (leave_type_id, department_id, year),
    CONSTRAINT fk_policy_dept
        FOREIGN KEY (department_id) REFERENCES departments(id),
    CONSTRAINT fk_policy_leave_type
        FOREIGN KEY (leave_type_id) REFERENCES leave_types(id)
);

-- 2026 policy: 12 annual, 12 casual, 8 medical
INSERT INTO leave_policies (leave_type_id, days_allowed, year) VALUES
    (1, 12, 2026),
    (2, 12, 2026),
    (3,  8, 2026);


-- ============================================================
-- SECTION 9 — LEAVE BALANCES (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern.
-- Fields: employee_id (FK), leave_type_id (FK), balance, used, year
-- Backend model methods: findById(), readAll(), readByEmployee(), readByYear(), adjustUsed(), upsertValue(), create(), update(), delete()
-- Methods: initializeForEmployee() reads leave_policies and creates balances for all leave types in a year
-- ============================================================

CREATE TABLE leave_balances (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    leave_type_id INT NOT NULL,
    year INT NOT NULL,
    balance INT NOT NULL DEFAULT 0,
    used INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT unique_balance
        UNIQUE (employee_id, leave_type_id, year),
    CONSTRAINT fk_balance_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_balance_type
        FOREIGN KEY (leave_type_id) REFERENCES leave_types(id)
);

CREATE INDEX idx_balance_emp_year ON leave_balances(employee_id, year);


-- ============================================================
-- SECTION 10 — LEAVE REQUESTS (PENDING — wait for meeting)
-- end_date = original approved end. NEVER modified after submission.
-- end_by_force = set when employee returns early.
-- Service uses end_by_force if set, otherwise end_date.
-- Balance recalculated from start_date to whichever end applies.
-- ============================================================

CREATE TABLE leave_requests (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    end_by_force DATE,
    reason TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    reviewed_by INT,
    reviewed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT chk_leave_dates
        CHECK (end_date >= start_date),
    CONSTRAINT chk_end_by_force
        CHECK (
            end_by_force IS NULL OR
            (end_by_force >= start_date AND end_by_force <= end_date)
        ),
    CONSTRAINT fk_leave_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_leave_type
        FOREIGN KEY (leave_type_id) REFERENCES leave_types(id),
    CONSTRAINT fk_leave_reviewed_by
        FOREIGN KEY (reviewed_by) REFERENCES users(id)
);

CREATE INDEX idx_leave_employee ON leave_requests(employee_id);
CREATE INDEX idx_leave_status   ON leave_requests(status);
CREATE INDEX idx_leave_dates    ON leave_requests(start_date, end_date);


-- ============================================================
-- SECTION 11 — ATTENDANCE (PENDING — wait for meeting)
-- One record per employee per day (strict constraint).
-- Night shifts: date = shift START date, not next calendar day.
-- Late detection: service compares check_in to
--   shifts.start_time + shifts.late_after_minutes.
-- on_leave: auto-set when approved leave exists for that date.
-- ============================================================

CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    shift_id INT NOT NULL,
    date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    status VARCHAR(20) NOT NULL DEFAULT 'absent'
        CHECK (status IN (
            'present', 'absent', 'late', 'half_day', 'holiday', 'on_leave'
        )),
    notes TEXT,
    marked_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT unique_attendance_per_day
        UNIQUE (employee_id, date),
    CONSTRAINT fk_attendance_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_attendance_shift
        FOREIGN KEY (shift_id) REFERENCES shifts(id),
    CONSTRAINT fk_attendance_marked_by
        FOREIGN KEY (marked_by) REFERENCES users(id)
);

CREATE INDEX idx_attendance_employee_date ON attendance(employee_id, date);
CREATE INDEX idx_attendance_date          ON attendance(date);
CREATE INDEX idx_attendance_status        ON attendance(status);


-- ============================================================
-- SECTION 12 — PAYROLL COMPONENTS (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern.
-- Fields: name (unique), type (earning/deduction), is_active
-- Backend model methods: findById(), readAll(), readByType(), readActive(), create(), update(), delete()
-- Validation: type must be 'earning' or 'deduction', checks if used in payroll_details before delete
-- ============================================================

CREATE TABLE payroll_components (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    type VARCHAR(20) NOT NULL
        CHECK (type IN ('earning', 'deduction')),
    is_taxable BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO payroll_components (name, type, is_taxable, display_order) VALUES
    ('Basic Salary',         'earning',   false, 1),
    ('House Rent Allowance', 'earning',   false, 2),
    ('Medical Allowance',    'earning',   false, 3),
    ('Conveyance Allowance', 'earning',   false, 4),
    ('Commission',           'earning',   false, 5),
    ('Absent Deduction',     'deduction', false, 1),
    ('Late Penalty',         'deduction', false, 2),
    ('Advance',              'deduction', false, 3),
    ('Loan Installment',     'deduction', false, 4),
    ('Tax',                  'deduction', true,  5),
    ('Other Deductions',     'deduction', false, 6);


-- ============================================================
-- SECTION 13 — PAYROLL HEADER (PENDING — wait for meeting)
-- One record per employee per month.
-- status: draft = editable, finalized = locked.
-- gross and net calculated in service from payroll_details rows.
-- ============================================================

CREATE TABLE payroll (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year INT NOT NULL,
    working_days INT,
    paid_days INT,
    cl_used INT DEFAULT 0,
    ml_used INT DEFAULT 0,
    al_used INT DEFAULT 0,
    absents INT DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'finalized')),
    payment_mode VARCHAR(20)
        CHECK (payment_mode IN ('cash', 'online_transfer', 'cheque')),
    created_by INT,
    finalized_by INT,
    finalized_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT unique_payroll_per_month
        UNIQUE (employee_id, month, year),
    CONSTRAINT fk_payroll_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_payroll_created_by
        FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT fk_payroll_finalized_by
        FOREIGN KEY (finalized_by) REFERENCES users(id)
);

CREATE INDEX idx_payroll_employee   ON payroll(employee_id);
CREATE INDEX idx_payroll_month_year ON payroll(month, year);


-- ============================================================
-- SECTION 14 — PAYROLL DETAILS (PENDING — wait for meeting)
-- One row per component per payroll record.
-- gross = SUM of amount WHERE type = 'earning'
-- net   = gross - SUM of amount WHERE type = 'deduction'
-- Both calculated in service layer, not stored.
-- ============================================================

CREATE TABLE payroll_details (
    id SERIAL PRIMARY KEY,
    payroll_id INT NOT NULL,
    component_id INT NOT NULL,
    amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    CONSTRAINT unique_detail_per_component
        UNIQUE (payroll_id, component_id),
    CONSTRAINT fk_detail_payroll
        FOREIGN KEY (payroll_id) REFERENCES payroll(id) ON DELETE CASCADE,
    CONSTRAINT fk_detail_component
        FOREIGN KEY (component_id) REFERENCES payroll_components(id)
);

CREATE INDEX idx_payroll_details_parent ON payroll_details(payroll_id);


-- ============================================================
-- SECTION 15 — TAX CONFIG (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern.
-- Fields: salary_from, salary_to (nullable for open-ended brackets), tax_rate
-- Backend model methods: findById(), readAll(), findBracketForSalary(), create(), update(), delete()
-- Special method calculateTax() returns {tax, bracket} for given salary
-- ============================================================

CREATE TABLE tax_config (
    id SERIAL PRIMARY KEY,
    salary_from NUMERIC(12, 2) NOT NULL,
    salary_to NUMERIC(12, 2),
    tax_rate NUMERIC(5, 2) NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO tax_config (salary_from, salary_to, tax_rate) VALUES
    (0,      50000,  0),
    (50001,  100000, 2),
    (100001, 200000, 5),
    (200001, NULL,   10);


-- ============================================================
-- SECTION 16 — PENALTIES CONFIG (PENDING — wait for meeting)
-- Each penalty type is a configurable row.
-- default_fine = 0 until confirmed in stakeholder meeting (Q59).
-- ============================================================

CREATE TABLE penalties_config (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL
        CHECK (category IN ('behaviour', 'performance', 'attendance', 'dress_code')),
    default_fine NUMERIC(12, 2) DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO penalties_config (name, category, default_fine) VALUES
    ('Late 3+ days in month',         'attendance', 0),
    ('Eating at desk',                'behaviour',  0),
    ('Smoking on premises',           'behaviour',  0),
    ('Drinking at desk',              'behaviour',  0),
    ('Dress code violation (Male)',   'dress_code', 0),
    ('Dress code violation (Female)', 'dress_code', 0),
    ('Other rule violation',          'behaviour',  0);


-- ============================================================
-- SECTION 17 — DEDUCTIONS (PENDING — wait for meeting)
-- One row per deduction applied to an employee.
-- auto_from_attendance = true means system-generated.
-- ============================================================

CREATE TABLE deductions (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    penalty_config_id INT,
    type VARCHAR(50) NOT NULL
        CHECK (type IN ('penalty', 'advance', 'loan', 'tax', 'other')),
    amount NUMERIC(12, 2) NOT NULL,
    month INT CHECK (month BETWEEN 1 AND 12),
    year INT,
    reason TEXT,
    auto_from_attendance BOOLEAN DEFAULT false,
    applied_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_deduction_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_deduction_config
        FOREIGN KEY (penalty_config_id) REFERENCES penalties_config(id),
    CONSTRAINT fk_deduction_applied
        FOREIGN KEY (applied_by) REFERENCES users(id)
);


-- ============================================================
-- SECTION 18 — PROMOTIONS (PENDING — wait for meeting)
-- Full history, one row per promotion. Never updates old rows.
-- Trigger method pending meeting (Q10, Q11, Q12).
-- ============================================================

CREATE TABLE promotions (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    old_designation_id INT,
    new_designation_id INT NOT NULL,
    old_salary NUMERIC(12, 2),
    new_salary NUMERIC(12, 2) NOT NULL,
    promotion_date DATE NOT NULL,
    notes TEXT,
    approved_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_promotion_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_promotion_old_desig
        FOREIGN KEY (old_designation_id) REFERENCES designations(id),
    CONSTRAINT fk_promotion_new_desig
        FOREIGN KEY (new_designation_id) REFERENCES designations(id),
    CONSTRAINT fk_promotion_approved
        FOREIGN KEY (approved_by) REFERENCES users(id)
);


-- ============================================================
-- SECTION 19 — CUSTOM FIELDS (CREATED ✓)
-- Module built with Route→Controller→Service→Model pattern (3 interconnected tables).
-- Definitions: super_admin manages field definitions (field_name, field_label, field_type, section, is_required)
-- Options: super_admin manages dropdown options (for field_type='dropdown')
-- Values: employees/HR manage custom field values per employee
-- Backend endpoints: 6 definition endpoints, 4 option endpoints, 3 value endpoints
-- ============================================================

CREATE TABLE custom_field_definitions (
    id SERIAL PRIMARY KEY,
    field_name VARCHAR(100) UNIQUE NOT NULL,
    field_label VARCHAR(100) NOT NULL,
    field_type VARCHAR(20) NOT NULL
        CHECK (field_type IN (
            'text', 'textarea', 'number', 'date',
            'dropdown', 'checkbox', 'file'
        )),
    section VARCHAR(30) NOT NULL
        CHECK (section IN (
            'personal_info', 'job_info', 'medical_info', 'extra_info'
        )),
    is_required BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    display_order INT DEFAULT 0,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_custom_created_by
        FOREIGN KEY (created_by) REFERENCES users(id)
);

-- dropdown options for custom_field_definitions of type 'dropdown'
CREATE TABLE custom_field_options (
    id SERIAL PRIMARY KEY,
    definition_id INT NOT NULL,
    option_label VARCHAR(100) NOT NULL,
    option_value VARCHAR(100) NOT NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_option_field
        FOREIGN KEY (definition_id)
        REFERENCES custom_field_definitions(id) ON DELETE CASCADE
);

-- actual employee data for custom fields
-- all types stored as TEXT, cast when reading
CREATE TABLE custom_field_values (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    definition_id INT NOT NULL,
    value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT unique_field_value
        UNIQUE (employee_id, definition_id),
    CONSTRAINT fk_value_employee
        FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_value_field
        FOREIGN KEY (definition_id)
        REFERENCES custom_field_definitions(id) ON DELETE CASCADE
);


-- ============================================================
-- SECTION 20 — AUDIT LOG (PENDING)
-- Every CREATE, UPDATE, DELETE, LOGIN, LOGOUT system-wide.
-- JSONB for old/new values — schema changes never break this.
-- Visible to super_admin only.
-- ============================================================

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INT,
    username VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL,
    action VARCHAR(20) NOT NULL
        CHECK (action IN ('CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT')),
    table_name VARCHAR(100) NOT NULL,
    record_id VARCHAR(50),
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_audit_created_at ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_user_id    ON audit_logs(user_id);
CREATE INDEX idx_audit_table      ON audit_logs(table_name);
CREATE INDEX idx_audit_action     ON audit_logs(action);




-- ============================================================
-- SUMMARY OF COMPLETED BUILD (Session 2026-03-28)
-- ============================================================
-- Total Modules Created: 10
-- Backend Architecture: Route → Controller → Service → Model
-- All modules use default exports and ES Modules (import/export)
-- All routes protected with verifyToken middleware
-- ============================================================

-- MODULE 1: SHIFTS
-- Table: shifts
-- Columns: id, name, start_time, end_time, grace_period, is_active, created_at, updated_at
-- API Routes:
--   GET    /api/shifts
--   POST   /api/shifts
--   GET    /api/shifts/:id
--   PUT    /api/shifts/:id
--   DELETE /api/shifts/:id
-- Model Methods: findById(id), readAll(), create(data), update(id, data), delete(id)

-- MODULE 2: LEAVE_TYPES
-- Table: leave_types
-- Columns: id, name, code, is_active, created_at
-- API Routes:
--   GET    /api/leave-types
--   POST   /api/leave-types
--   GET    /api/leave-types/:id
--   PUT    /api/leave-types/:id
--   DELETE /api/leave-types/:id
-- Model Methods: findById(id), readAll(), findByName(name), findByCode(code), create(data), update(id, data), delete(id)
-- Validations: Checks leave_policies, leave_balances, leave_requests before delete

-- MODULE 3: LEAVE_POLICIES
-- Table: leave_policies
-- Columns: id, department_id, leave_type_id, days_allowed, year, is_active, created_at, updated_at
-- API Routes:
--   GET    /api/leave-policies
--   POST   /api/leave-policies
--   GET    /api/leave-policies/:id
--   GET    /api/leave-policies/year/:year
--   PUT    /api/leave-policies/:id
--   DELETE /api/leave-policies/:id
-- Model Methods: findById(id), readAll(), readByYear(year), create(data), update(id, data), delete(id)
-- Validations: department_id and leave_type_id FK validation, unique constraint on (leave_type_id, department_id, year)

-- MODULE 4: LEAVE_BALANCES
-- Table: leave_balances
-- Columns: id, employee_id, leave_type_id, year, balance, used, created_at, updated_at
-- API Routes:
--   GET    /api/leave-balances
--   POST   /api/leave-balances
--   GET    /api/leave-balances/:id
--   PATCH  /api/leave-balances/:id/adjust
--   POST   /api/leave-balances/employee/:employeeId/initialize
--   DELETE /api/leave-balances/:id
-- Model Methods: findById(id), readAll(), readByEmployee(employeeId), readByYear(year), adjustUsed(id, adjustment), upsertValue(data), create(data), update(id, data), delete(id)
-- Special Methods: initializeForEmployee(employeeId, year) - reads leave_policies and creates balances for all leave types

-- MODULE 5: PAYROLL_COMPONENTS
-- Table: payroll_components
-- Columns: id, name, type, is_taxable, is_active, display_order, created_at, updated_at
-- API Routes:
--   GET    /api/payroll-components
--   POST   /api/payroll-components
--   GET    /api/payroll-components/:id
--   GET    /api/payroll-components/active
--   GET    /api/payroll-components/type/:type
--   PUT    /api/payroll-components/:id
--   DELETE /api/payroll-components/:id
-- Model Methods: findById(id), readAll(), readByType(type), readActive(), create(data), update(id, data), delete(id)
-- Validations: type must be 'earning' or 'deduction', checks payroll_details before delete

-- MODULE 6: TAX_CONFIG
-- Table: tax_config
-- Columns: id, salary_from, salary_to, tax_rate, is_active, created_at, updated_at
-- API Routes:
--   GET    /api/tax-config
--   POST   /api/tax-config
--   GET    /api/tax-config/:id
--   GET    /api/tax-config/calculate?salary=X
--   PUT    /api/tax-config/:id
--   DELETE /api/tax-config/:id
-- Model Methods: findById(id), readAll(), findBracketForSalary(salary), create(data), update(id, data), delete(id)
-- Special Methods: calculateTax(salary) - returns {tax, bracket}
-- Validations: salary_to can be NULL for open-ended bracket, tax_rate between 0-100

-- MODULE 7: DESIGNATIONS (UPDATED with Department Support)
-- Table: designations
-- Columns: id, name, department_id, description, created_at, updated_at
-- API Routes:
--   GET    /api/designations
--   POST   /api/designations
--   GET    /api/designations/:id
--   GET    /api/designations/department/:departmentId
--   PUT    /api/designations/:id
--   DELETE /api/designations/:id
-- Model Methods: findById(id), readAll(), readByDepartment(departmentId), create(data), update(id, data), delete(id)
-- Enhanced: Includes LEFT JOIN with departments table to return department_name in responses
-- Validations: department_id FK validation, checks job_info references before delete

-- MODULE 8: REPORTING_MANAGERS (UPDATED with Department Support)
-- Table: reporting_managers
-- Columns: id, name, department_id, created_at, updated_at
-- API Routes:
--   GET    /api/reporting-managers
--   POST   /api/reporting-managers
--   GET    /api/reporting-managers/:id
--   GET    /api/reporting-managers/department/:departmentId
--   PUT    /api/reporting-managers/:id
--   DELETE /api/reporting-managers/:id
-- Model Methods: findById(id), readAll(), readByDepartment(departmentId), create(data), update(id, data), delete(id)
-- Enhanced: Includes LEFT JOIN with departments table to return department_name in responses
-- Validations: department_id FK validation, checks job_info references before delete

-- MODULE 9: CUSTOM_FIELD_DEFINITIONS (THREE INTERCONNECTED TABLES)
-- Tables: custom_field_definitions, custom_field_options, custom_field_values
-- API Routes (Definitions):
--   GET    /api/custom-fields/definitions
--   POST   /api/custom-fields/definitions (super_admin only)
--   GET    /api/custom-fields/definitions/:id
--   PUT    /api/custom-fields/definitions/:id (super_admin only)
--   DELETE /api/custom-fields/definitions/:id (super_admin only)
-- API Routes (Options):
--   POST   /api/custom-fields/options (super_admin only)
--   GET    /api/custom-fields/options/:definitionId
--   PUT    /api/custom-fields/options/:id (super_admin only)
--   DELETE /api/custom-fields/options/:id (super_admin only)
-- API Routes (Values):
--   POST   /api/custom-fields/values (verifyToken)
--   GET    /api/custom-fields/values/:definitionId/:employeeId (verifyToken)
--   PUT    /api/custom-fields/values/:id (verifyToken)
--   DELETE /api/custom-fields/values/:id (verifyToken)
-- Model Methods:
--   Definitions: createDefinition(), readDefinitions(), updateDefinition(), deleteDefinition()
--   Options: createOption(), readOptions(), updateOption(), deleteOption()
--   Values: createValue(), readValues(), updateValue(), deleteValue(), upsertValue()
-- Field Types: text, textarea, number, date, dropdown, checkbox, file
-- Sections: personal_info, job_info, medical_info, extra_info
-- Special Feature: Cascading delete from definitions → options → values

-- ============================================================
-- PENDING MODULES (Waiting for Stakeholder Meeting)
-- ============================================================
-- - attendance: Time tracking, check_in/check_out, late detection
-- - leave_requests: Leave request workflow with approval flow
-- - payroll: Monthly payroll generation and finalization
-- - penalties: Penalty configuration and deduction tracking
-- - promotions: Promotion history and salary change tracking
-- ============================================================

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name  AS references_table,
    ccu.column_name AS references_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;

SELECT 'shifts'             AS tbl, COUNT(*) FROM shifts
UNION ALL
SELECT 'leave_types'        AS tbl, COUNT(*) FROM leave_types
UNION ALL
SELECT 'leave_policies'     AS tbl, COUNT(*) FROM leave_policies
UNION ALL
SELECT 'leave_balances'     AS tbl, COUNT(*) FROM leave_balances
UNION ALL
SELECT 'payroll_components' AS tbl, COUNT(*) FROM payroll_components
UNION ALL
SELECT 'tax_config'         AS tbl, COUNT(*) FROM tax_config
UNION ALL
SELECT 'designations'       AS tbl, COUNT(*) FROM designations
UNION ALL
SELECT 'reporting_managers' AS tbl, COUNT(*) FROM reporting_managers
UNION ALL
SELECT 'custom_field_definitions' AS tbl, COUNT(*) FROM custom_field_definitions
UNION ALL
SELECT 'custom_field_options'     AS tbl, COUNT(*) FROM custom_field_options
UNION ALL
SELECT 'custom_field_values'      AS tbl, COUNT(*) FROM custom_field_values;
