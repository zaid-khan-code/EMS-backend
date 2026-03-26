import customFieldDefinitionTable from '../models/custom-field-definition-model.js';

const VALID_FIELD_TYPES = ['text', 'textarea', 'number', 'date', 'dropdown', 'checkbox', 'file'];
const VALID_SECTIONS = ['personal_info', 'job_info', 'medical_info', 'extra_info'];

const customFieldDefinitionService = {
    // Field Definitions
    createDefinition: async (data) => {
        if (!VALID_FIELD_TYPES.includes(data.field_type)) {
            throw { status: 400, message: `Invalid field_type. Must be one of: ${VALID_FIELD_TYPES.join(', ')}` };
        }

        if (!VALID_SECTIONS.includes(data.section)) {
            throw { status: 400, message: `Invalid section. Must be one of: ${VALID_SECTIONS.join(', ')}` };
        }

        if (!data.label) {
            throw { status: 400, message: 'Label is required' };
        }

        return customFieldDefinitionTable.createDefinition(data);
    },

    readDefinitions: (id) => customFieldDefinitionTable.readDefinitions(id),

    readDefinitionsBySection: (section) => customFieldDefinitionTable.readDefinitionsBySection(section),

    updateDefinition: async (data) => {
        if (!VALID_FIELD_TYPES.includes(data.field_type)) {
            throw { status: 400, message: `Invalid field_type. Must be one of: ${VALID_FIELD_TYPES.join(', ')}` };
        }

        if (!VALID_SECTIONS.includes(data.section)) {
            throw { status: 400, message: `Invalid section. Must be one of: ${VALID_SECTIONS.join(', ')}` };
        }

        if (!data.label) {
            throw { status: 400, message: 'Label is required' };
        }

        return customFieldDefinitionTable.updateDefinition(data);
    },

    deleteDefinition: (id) => customFieldDefinitionTable.deleteDefinition(id),

    // Field Options
    createOption: async (fieldDefinitionId, optionValue) => {
        if (!optionValue) {
            throw { status: 400, message: 'Option value is required' };
        }

        // Verify field definition exists
        const def = await customFieldDefinitionTable.readDefinitions(fieldDefinitionId);
        if (!def) {
            throw { status: 404, message: 'Field definition not found' };
        }

        return customFieldDefinitionTable.createOption(fieldDefinitionId, optionValue);
    },

    readOptions: (fieldDefinitionId) => customFieldDefinitionTable.readOptions(fieldDefinitionId),

    updateOption: (optionId, data) => customFieldDefinitionTable.updateOption(optionId, data),

    deleteOption: (optionId) => customFieldDefinitionTable.deleteOption(optionId),

    // Field Values (for employee data)
    upsertValue: (employeeId, fieldDefinitionId, value) => customFieldDefinitionTable.upsertValue(employeeId, fieldDefinitionId, value),

    readValues: (employeeId) => customFieldDefinitionTable.readValues(employeeId),

    deleteValue: (valueId) => customFieldDefinitionTable.deleteValue(valueId),
};

export default customFieldDefinitionService;
