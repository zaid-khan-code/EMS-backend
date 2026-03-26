import pool from '../config/db.js';

const customFieldDefinitionTable = {
    // Field Definitions CRUD
    createDefinition: async (data) => {
        const { label, field_type, section, is_required = false, is_active = true, display_order = 0, created_by } = data;
        const query = `
            INSERT INTO custom_field_definitions (label, field_type, section, is_required, is_active, display_order, created_by)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *
        `;
        const resp = await pool.query(query, [label, field_type, section, is_required, is_active, display_order, created_by]);
        return resp.rows[0];
    },

    readDefinitions: async (id = null) => {
        if (id) {
            const query = `
                SELECT cfd.*, u.username AS created_by_username
                FROM custom_field_definitions cfd
                LEFT JOIN users u ON cfd.created_by = u.id
                WHERE cfd.id = $1
            `;
            const res = await pool.query(query, [id]);
            return res.rows[0];
        }

        const query = `
            SELECT cfd.*, u.username AS created_by_username
            FROM custom_field_definitions cfd
            LEFT JOIN users u ON cfd.created_by = u.id
            ORDER BY cfd.section, cfd.display_order, cfd.label
        `;
        const res = await pool.query(query);
        return res.rows;
    },

    readDefinitionsBySection: async (section) => {
        const query = `
            SELECT * FROM custom_field_definitions
            WHERE section = $1 AND is_active = true
            ORDER BY display_order, label
        `;
        const res = await pool.query(query, [section]);
        return res.rows;
    },

    updateDefinition: async (data) => {
        const { id, label, field_type, section, is_required, is_active, display_order } = data;
        const query = `
            UPDATE custom_field_definitions
            SET label = $2, field_type = $3, section = $4, is_required = $5, is_active = $6, display_order = $7, updated_at = CURRENT_TIMESTAMP
            WHERE id = $1
            RETURNING *
        `;
        const resp = await pool.query(query, [id, label, field_type, section, is_required, is_active, display_order]);
        return resp.rows[0];
    },

    deleteDefinition: async (id) => {
        // Cascading delete is handled by FK ON DELETE CASCADE
        const query = 'DELETE FROM custom_field_definitions WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [id]);
        return resp.rows[0];
    },

    // Field Options CRUD
    createOption: async (fieldDefinitionId, optionValue, displayOrder = 0) => {
        const query = `
            INSERT INTO custom_field_options (field_definition_id, option_value, display_order)
            VALUES ($1, $2, $3)
            RETURNING *
        `;
        const resp = await pool.query(query, [fieldDefinitionId, optionValue, displayOrder]);
        return resp.rows[0];
    },

    readOptions: async (fieldDefinitionId) => {
        const query = `
            SELECT * FROM custom_field_options
            WHERE field_definition_id = $1
            ORDER BY display_order, option_value
        `;
        const res = await pool.query(query, [fieldDefinitionId]);
        return res.rows;
    },

    updateOption: async (optionId, data) => {
        const { option_value, display_order } = data;
        const query = `
            UPDATE custom_field_options
            SET option_value = $2, display_order = $3
            WHERE id = $1
            RETURNING *
        `;
        const resp = await pool.query(query, [optionId, option_value, display_order]);
        return resp.rows[0];
    },

    deleteOption: async (optionId) => {
        const query = 'DELETE FROM custom_field_options WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [optionId]);
        return resp.rows[0];
    },

    // Field Values CRUD
    createValue: async (employeeId, fieldDefinitionId, value) => {
        const query = `
            INSERT INTO custom_field_values (employee_id, field_definition_id, value)
            VALUES ($1, $2, $3)
            RETURNING *
        `;
        const resp = await pool.query(query, [employeeId, fieldDefinitionId, value]);
        return resp.rows[0];
    },

    readValues: async (employeeId) => {
        const query = `
            SELECT cfv.*, cfd.label, cfd.field_type, cfd.section
            FROM custom_field_values cfv
            JOIN custom_field_definitions cfd ON cfv.field_definition_id = cfd.id
            WHERE cfv.employee_id = $1
            ORDER BY cfd.section, cfd.display_order
        `;
        const res = await pool.query(query, [employeeId]);
        return res.rows;
    },

    updateValue: async (valueId, newValue) => {
        const query = `
            UPDATE custom_field_values
            SET value = $2, updated_at = CURRENT_TIMESTAMP
            WHERE id = $1
            RETURNING *
        `;
        const resp = await pool.query(query, [valueId, newValue]);
        return resp.rows[0];
    },

    deleteValue: async (valueId) => {
        const query = 'DELETE FROM custom_field_values WHERE id = $1 RETURNING *';
        const resp = await pool.query(query, [valueId]);
        return resp.rows[0];
    },

    // Upsert value (create or update)
    upsertValue: async (employeeId, fieldDefinitionId, value) => {
        const query = `
            INSERT INTO custom_field_values (employee_id, field_definition_id, value)
            VALUES ($1, $2, $3)
            ON CONFLICT (employee_id, field_definition_id)
            DO UPDATE SET value = $3, updated_at = CURRENT_TIMESTAMP
            RETURNING *
        `;
        const resp = await pool.query(query, [employeeId, fieldDefinitionId, value]);
        return resp.rows[0];
    },
};

export default customFieldDefinitionTable;
