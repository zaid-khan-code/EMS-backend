import reportingManagerService from '../services/reporting-manager-service.js';

export const createReportingManager = async (req, res, next) => {
    try {
        const reportingManager = await reportingManagerService.create(req.body);
        return res.status(201).json(reportingManager);
    } catch (err) {
        return next(err);
    }
};

export const getReportingManagers = async (req, res, next) => {
    try {
        const { id } = req.params;
        const data = await reportingManagerService.read(id);

        if (id && !data) {
            return res.status(404).json({ error: 'Reporting manager not found' });
        }

        return res.status(200).json(data);
    } catch (err) {
        return next(err);
    }
};

export const updateReportingManager = async (req, res, next) => {
    try {
        const { id } = req.params;
        const reportingManager = await reportingManagerService.update({ id, ...req.body });

        if (!reportingManager) {
            return res.status(404).json({ error: 'Reporting manager not found' });
        }

        return res.status(200).json(reportingManager);
    } catch (err) {
        return next(err);
    }
};

export const deleteReportingManager = async (req, res, next) => {
    try {
        const { id } = req.params;
        const reportingManager = await reportingManagerService.delete(id);

        if (!reportingManager) {
            return res.status(404).json({ error: 'Reporting manager not found' });
        }

        return res.status(200).json(reportingManager);
    } catch (err) {
        return next(err);
    }
};
