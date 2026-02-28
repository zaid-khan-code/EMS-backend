import jobStatusTable from '../models/job-status-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeStatusName = (statusName) => {
    const normalized = statusName?.trim();
    if (!normalized) {
        throw createValidationError('status_name is required');
    }
    return normalized;
};

const jobStatusService = {
    create: (data) => jobStatusTable.create({ status_name: normalizeStatusName(data.status_name) }),
    read: (id) => jobStatusTable.read(id),
    update: (data) => jobStatusTable.update({ id: data.id, status_name: normalizeStatusName(data.status_name) }),
    delete: (id) => jobStatusTable.delete(id),
};

export default jobStatusService;
