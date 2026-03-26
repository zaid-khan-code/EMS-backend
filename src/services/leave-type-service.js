import leaveTypeTable from '../models/leave-type-model.js';
import pool from '../config/db.js';

const leaveTypeService = {
    create: async (data) => {
        const existingName = await leaveTypeTable.findByName(data.name);
        if (existingName) {
            throw { status: 400, message: 'Leave type name already exists' };
        }
        const existingCode = await leaveTypeTable.findByCode(data.code);
        if (existingCode) {
            throw { status: 400, message: 'Leave type code already exists' };
        }
        return leaveTypeTable.create(data);
    },

    read: (id) => leaveTypeTable.read(id),

    update: async (data) => {
        const existingName = await leaveTypeTable.findByName(data.name, data.id);
        if (existingName) {
            throw { status: 400, message: 'Leave type name already exists' };
        }
        const existingCode = await leaveTypeTable.findByCode(data.code, data.id);
        if (existingCode) {
            throw { status: 400, message: 'Leave type code already exists' };
        }
        return leaveTypeTable.update(data);
    },

    delete: async (id) => {
        // Check if leave type is used in leave_policies
        const policyUsage = await pool.query(
            'SELECT COUNT(*) FROM leave_policies WHERE leave_type_id = $1',
            [id]
        );
        if (parseInt(policyUsage.rows[0].count) > 0) {
            throw { status: 400, message: 'Cannot delete leave type used in policies' };
        }

        // Check if leave type is used in leave_balances
        const balanceUsage = await pool.query(
            'SELECT COUNT(*) FROM leave_balances WHERE leave_type_id = $1',
            [id]
        );
        if (parseInt(balanceUsage.rows[0].count) > 0) {
            throw { status: 400, message: 'Cannot delete leave type with existing balances' };
        }

        // Check if leave type is used in leave_requests
        const requestUsage = await pool.query(
            'SELECT COUNT(*) FROM leave_requests WHERE leave_type_id = $1',
            [id]
        );
        if (parseInt(requestUsage.rows[0].count) > 0) {
            throw { status: 400, message: 'Cannot delete leave type with existing requests' };
        }

        return leaveTypeTable.delete(id);
    },
};

export default leaveTypeService;
