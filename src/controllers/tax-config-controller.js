import taxConfigService from '../services/tax-config-service.js';

const taxConfigController = {
    getAll: async (req, res) => {
        try {
            const configs = await taxConfigService.read();
            res.status(200).json(configs);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getById: async (req, res) => {
        try {
            const config = await taxConfigService.read(req.params.id);
            if (!config) {
                return res.status(404).json({ message: 'Tax config not found' });
            }
            res.status(200).json(config);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getActive: async (req, res) => {
        try {
            const configs = await taxConfigService.readActive();
            res.status(200).json(configs);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    calculateTax: async (req, res) => {
        try {
            const { salary } = req.query;
            if (!salary) {
                return res.status(400).json({ message: 'Salary parameter is required' });
            }
            const result = await taxConfigService.calculateTax(parseFloat(salary));
            res.status(200).json(result);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    create: async (req, res) => {
        try {
            const config = await taxConfigService.create(req.body);
            res.status(201).json({
                message: 'Tax config created successfully',
                config
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    update: async (req, res) => {
        try {
            const config = await taxConfigService.update({ id: req.params.id, ...req.body });
            if (!config) {
                return res.status(404).json({ message: 'Tax config not found' });
            }
            res.status(200).json({
                message: 'Tax config updated successfully',
                config
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    delete: async (req, res) => {
        try {
            const config = await taxConfigService.delete(req.params.id);
            if (!config) {
                return res.status(404).json({ message: 'Tax config not found' });
            }
            res.status(200).json({
                message: 'Tax config deleted successfully',
                config
            });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },
};

export default taxConfigController;
