import designationService from '../services/designation-service.js';

export const createDesignation = async (req, res, next) => {
    try {
        const designation = await designationService.create(req.body);
        return res.status(201).json(designation);
    } catch (err) {
        return next(err);
    }
};

export const getDesignations = async (req, res, next) => {
    try {
        const { id } = req.params;
        const data = await designationService.read(id);

        if (id && !data) {
            return res.status(404).json({ error: 'Designation not found' });
        }

        return res.status(200).json(data);
    } catch (err) {
        return next(err);
    }
};

export const updateDesignation = async (req, res, next) => {
    try {
        const { id } = req.params;
        const designation = await designationService.update({ id, ...req.body });

        if (!designation) {
            return res.status(404).json({ error: 'Designation not found' });
        }

        return res.status(200).json(designation);
    } catch (err) {
        return next(err);
    }
};

export const deleteDesignation = async (req, res, next) => {
    try {
        const { id } = req.params;
        const designation = await designationService.delete(id);

        if (!designation) {
            return res.status(404).json({ error: 'Designation not found' });
        }

        return res.status(200).json(designation);
    } catch (err) {
        return next(err);
    }
};
