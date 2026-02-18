







CREATE TABLE employee_info(
	id SERIAL PRIMARY KEY,
	employee_id VARCHAR(10) UNIQUE NOT NULL ,
	name VARCHAR(100) NOT NULL ,
	father_name VARCHAR(100) NOT NULL ,
	cnic VARCHAR(20) NOT NULL UNIQUE,
	date_of_birth DATE NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP
)



CREATE TABLE extra_employee_info(
	id SERIAL PRIMARY KEY,
	employee_id VARCHAR(10) UNIQUE NOT NULL ,
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
)


CREATE TABLE job_info(
	id SERIAL PRIMARY KEY,
	employee_id VARCHAR(10) UNIQUE NOT NULL ,
	department_id INT NOT NULL,
	designation_id INT NOT NULL,
	employment_type_id INT NOT NULL,
	job_status_id INT NOT NULL,
	date_of_joining DATE NOT NULL,
  	date_of_exit DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP,
	CONSTRAINT fk_job_info_id FOREIGN KEY (employee_id) REFERENCES employee_info(employee_id),
	CONSTRAINT fk_job_department_id FOREIGN KEY (department_id) REFERENCES departments(id),
	CONSTRAINT fk_job_designation_id FOREIGN KEY (designation_id) REFERENCES designations(id),
	CONSTRAINT fk_job_employment_type_id FOREIGN KEY (employment_type_id) REFERENCES employment_types(id),
	CONSTRAINT fk_job_status_id FOREIGN KEY (job_status_id) REFERENCES job_statuses(id)	
)

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

-- DROP TABLE job_info;
-- DROP TABLE employee_info;
-- DROP TABLE extra_employee_info;
-- DROP TABLE job_statuses;
-- DROP TABLE departments;
-- DROP TABLE designations;
-- DROP TABLE employment_types;


-- SELECT * FROM employee_info 

SELECT * FROM employee_info ORDER BY id ASC

