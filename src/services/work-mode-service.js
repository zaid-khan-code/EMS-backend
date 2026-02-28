import workModeTable from '../models/work-mode-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeModeName = (modeName) => {
    const normalized = modeName?.trim();
    if (!normalized) {
        throw createValidationError('mode_name is required');
    }
    return normalized;
};

const workModeService = {
    create: (data) => workModeTable.create({ mode_name: normalizeModeName(data.mode_name) }),
    read: (id) => workModeTable.read(id),
    update: (data) => workModeTable.update({ id: data.id, mode_name: normalizeModeName(data.mode_name) }),
    delete: (id) => workModeTable.delete(id),
};

export default workModeService;
