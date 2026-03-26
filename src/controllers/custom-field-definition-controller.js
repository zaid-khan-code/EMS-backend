import customFieldDefinitionService from '../services/custom-field-definition-service.js';

const customFieldDefinitionController = {
    // Field Definitions
    getAll: async (req, res) => {
        try {
            const definitions = await customFieldDefinitionService.readDefinitions();
            res.status(200).json(definitions);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getById: async (req, res) => {
        try {
            const definition = await customFieldDefinitionService.readDefinitions(req.params.id);
            if (!definition) {
                return res.status(404).json({ message: 'Field definition not found' });
            }
            res.status(200).json(definition);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getBySection: async (req, res) => {
        try {
            const definitions = await customFieldDefinitionService.readDefinitionsBySection(req.params.section);
            res.status(200).json(definitions);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    createDefinition: async (req, res) => {
        try {
            const definition = await customFieldDefinitionService.createDefinition({
                ...req.body,
                created_by: req.user?.userId,
            });
            res.status(201).json({
                message: 'Field definition created successfully',
                definition,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    updateDefinition: async (req, res) => {
        try {
            const definition = await customFieldDefinitionService.updateDefinition({
                id: req.params.id,
                ...req.body,
            });
            if (!definition) {
                return res.status(404).json({ message: 'Field definition not found' });
            }
            res.status(200).json({
                message: 'Field definition updated successfully',
                definition,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    deleteDefinition: async (req, res) => {
        try {
            const definition = await customFieldDefinitionService.deleteDefinition(req.params.id);
            if (!definition) {
                return res.status(404).json({ message: 'Field definition not found' });
            }
            res.status(200).json({
                message: 'Field definition deleted successfully',
                definition,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    // Field Options
    getOptions: async (req, res) => {
        try {
            const options = await customFieldDefinitionService.readOptions(req.params.fieldDefinitionId);
            res.status(200).json(options);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    createOption: async (req, res) => {
        try {
            const { option_value } = req.body;
            const option = await customFieldDefinitionService.createOption(req.params.fieldDefinitionId, option_value);
            res.status(201).json({
                message: 'Option created successfully',
                option,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    updateOption: async (req, res) => {
        try {
            const option = await customFieldDefinitionService.updateOption(req.params.optionId, req.body);
            if (!option) {
                return res.status(404).json({ message: 'Option not found' });
            }
            res.status(200).json({
                message: 'Option updated successfully',
                option,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    deleteOption: async (req, res) => {
        try {
            const option = await customFieldDefinitionService.deleteOption(req.params.optionId);
            if (!option) {
                return res.status(404).json({ message: 'Option not found' });
            }
            res.status(200).json({
                message: 'Option deleted successfully',
                option,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    // Field Values (for employees)
    getEmployeeValues: async (req, res) => {
        try {
            const values = await customFieldDefinitionService.readValues(req.params.employeeId);
            res.status(200).json(values);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    upsertEmployeeValue: async (req, res) => {
        try {
            const { field_definition_id, value } = req.body;
            const result = await customFieldDefinitionService.upsertValue(req.params.employeeId, field_definition_id, value);
            res.status(200).json({
                message: 'Employee field value saved successfully',
                value: result,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    deleteEmployeeValue: async (req, res) => {
        try {
            const value = await customFieldDefinitionService.deleteValue(req.params.valueId);
            if (!value) {
                return res.status(404).json({ message: 'Field value not found' });
            }
            res.status(200).json({
                message: 'Employee field value deleted successfully',
                value,
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },
};

export default customFieldDefinitionController;
