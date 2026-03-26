import payrollComponentService from '../services/payroll-component-service.js';

const payrollComponentController = {
    getAll: async (req, res) => {
        try {
            const components = await payrollComponentService.read();
            res.status(200).json(components);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getById: async (req, res) => {
        try {
            const component = await payrollComponentService.read(req.params.id);
            if (!component) {
                return res.status(404).json({ message: 'Payroll component not found' });
            }
            res.status(200).json(component);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getByType: async (req, res) => {
        try {
            const components = await payrollComponentService.readByType(req.params.type);
            res.status(200).json(components);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getActive: async (req, res) => {
        try {
            const components = await payrollComponentService.readActive();
            res.status(200).json(components);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    create: async (req, res) => {
        try {
            const component = await payrollComponentService.create(req.body);
            res.status(201).json({
                message: 'Payroll component created successfully',
                component
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    update: async (req, res) => {
        try {
            const component = await payrollComponentService.update({ id: req.params.id, ...req.body });
            if (!component) {
                return res.status(404).json({ message: 'Payroll component not found' });
            }
            res.status(200).json({
                message: 'Payroll component updated successfully',
                component
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    delete: async (req, res) => {
        try {
            const component = await payrollComponentService.delete(req.params.id);
            if (!component) {
                return res.status(404).json({ message: 'Payroll component not found' });
            }
            res.status(200).json({
                message: 'Payroll component deleted successfully',
                component
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },
};

export default payrollComponentController;
