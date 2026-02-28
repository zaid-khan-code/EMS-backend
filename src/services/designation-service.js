import designationTable from '../models/designation-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeTitle = (title) => {
    const normalized = title?.trim();
    if (!normalized) {
        throw createValidationError('title is required');
    }
    return normalized;
};

const designationService = {
    create: (data) => designationTable.create({ title: normalizeTitle(data.title) }),
    read: (id) => designationTable.read(id),
    update: (data) => designationTable.update({ id: data.id, title: normalizeTitle(data.title) }),
    delete: (id) => designationTable.delete(id),
};

export default designationService;
