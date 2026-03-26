import payrollComponentTable from '../models/payroll-component-model.js';
import pool from '../config/db.js';

const VALID_TYPES = ['earning', 'deduction'];

const payrollComponentService = {
    create: async (data) => {
        // Validate type
        if (!VALID_TYPES.includes(data.type)) {
            throw { status: 400, message: 'Type must be either "earning" or "deduction"' };
        }

        // Check duplicate name
        const existing = await payrollComponentTable.findByName(data.name);
        if (existing) {
            throw { status: 400, message: 'Component name already exists' };
        }

        return payrollComponentTable.create(data);
    },

    read: (id) => payrollComponentTable.read(id),

    readByType: (type) => payrollComponentTable.readByType(type),

    readActive: () => payrollComponentTable.readActive(),

    update: async (data) => {
        // Validate type
        if (!VALID_TYPES.includes(data.type)) {
            throw { status: 400, message: 'Type must be either "earning" or "deduction"' };
        }

        // Check duplicate name excluding current
        const existing = await payrollComponentTable.findByName(data.name, data.id);
        if (existing) {
            throw { status: 400, message: 'Component name already exists' };
        }

        return payrollComponentTable.update(data);
    },

    delete: async (id) => {
        // Check if component is used in any payroll_details
        const usage = await pool.query(
            'SELECT COUNT(*) FROM payroll_details WHERE component_id = $1',
            [id]
        );
        if (parseInt(usage.rows[0].count) > 0) {
            throw { status: 400, message: 'Cannot delete component used in payroll records' };
        }

        return payrollComponentTable.delete(id);
    },
};

export default payrollComponentService;
