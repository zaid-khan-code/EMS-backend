import reportingManagerService from '../services/reporting-manager-service.js';

const reportingManagerController = {
    getAll: async (req, res) => {
        try {
            const managers = await reportingManagerService.read();
            res.status(200).json(managers);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getById: async (req, res) => {
        try {
            const manager = await reportingManagerService.read(req.params.id);
            if (!manager) {
                return res.status(404).json({ message: 'Reporting manager not found' });
            }
            res.status(200).json(manager);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    getByDepartment: async (req, res) => {
        try {
            const managers = await reportingManagerService.readByDepartment(req.params.departmentId);
            res.status(200).json(managers);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    },

    create: async (req, res) => {
        try {
            const manager = await reportingManagerService.create(req.body);
            res.status(201).json({
                message: 'Reporting manager created successfully',
                manager
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    update: async (req, res) => {
        try {
            const manager = await reportingManagerService.update({ id: req.params.id, ...req.body });
            if (!manager) {
                return res.status(404).json({ message: 'Reporting manager not found' });
            }
            res.status(200).json({
                message: 'Reporting manager updated successfully',
                manager
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },

    delete: async (req, res) => {
        try {
            const manager = await reportingManagerService.delete(req.params.id);
            if (!manager) {
                return res.status(404).json({ message: 'Reporting manager not found' });
            }
            res.status(200).json({
                message: 'Reporting manager deleted successfully',
                manager
            });
        } catch (err) {
            const status = err.status || 500;
            res.status(status).json({ message: err.message });
        }
    },
};

export default reportingManagerController;
