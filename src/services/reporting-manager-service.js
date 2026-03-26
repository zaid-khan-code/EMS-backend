import reportingManagerTable from '../models/reporting-manager-model.js';
import pool from '../config/db.js';

const reportingManagerService = {
    create: async (data) => {
        // Check for duplicate name
        const existing = await reportingManagerTable.findByName(data.manager_name);
        if (existing) {
            throw { status: 400, message: 'Manager name already exists' };
        }

        // Validate department_id if provided
        if (data.department_id) {
            const deptCheck = await pool.query(
                'SELECT id FROM departments WHERE id = $1',
                [data.department_id]
            );
            if (deptCheck.rows.length === 0) {
                throw { status: 404, message: 'Department not found' };
            }
        }

        return reportingManagerTable.create(data);
    },

    read: (id) => reportingManagerTable.read(id),

    readByDepartment: (departmentId) => reportingManagerTable.readByDepartment(departmentId),

    update: async (data) => {
        // Check for duplicate name excluding current
        const existing = await reportingManagerTable.findByName(data.manager_name, data.id);
        if (existing) {
            throw { status: 400, message: 'Manager name already exists' };
        }

        // Validate department_id if provided
        if (data.department_id) {
            const deptCheck = await pool.query(
                'SELECT id FROM departments WHERE id = $1',
                [data.department_id]
            );
            if (deptCheck.rows.length === 0) {
                throw { status: 404, message: 'Department not found' };
            }
        }

        return reportingManagerTable.update(data);
    },

    delete: async (id) => {
        // Check if manager is used in job_info
        const usage = await pool.query(
            'SELECT COUNT(*) FROM job_info WHERE reporting_manager_id = $1',
            [id]
        );
        if (parseInt(usage.rows[0].count) > 0) {
            throw { status: 400, message: 'Cannot delete manager assigned to employees' };
        }

        return reportingManagerTable.delete(id);
    },
};

export default reportingManagerService;
