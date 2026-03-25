import shiftTable from '../models/shift-model.js';
import pool from '../config/db.js';

const shiftService = {
    create: async (data) => {
        const existing = await shiftTable.findByName(data.name);
        if (existing) {
            throw { status: 400, message: 'Shift name already exists' };
        }
        return shiftTable.create(data);
    },

    read: (id) => shiftTable.read(id),

    update: async (data) => {
        const existing = await shiftTable.findByName(data.name, data.id);
        if (existing) {
            throw { status: 400, message: 'Shift name already exists' };
        }
        return shiftTable.update(data);
    },

    delete: async (id) => {
        // Prevent delete if shift is assigned to employees
        const usage = await pool.query(
            'SELECT COUNT(*) FROM job_info WHERE shift_id = $1',
            [id]
        );
        if (parseInt(usage.rows[0].count) > 0) {
            throw { status: 400, message: 'Cannot delete shift assigned to employees' };
        }
        return shiftTable.delete(id);
    },
};

export default shiftService;
