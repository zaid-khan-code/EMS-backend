import reportingManagerTable from '../models/reporting-manager-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeManagerName = (managerName) => {
    const normalized = managerName?.trim();
    if (!normalized) {
        throw createValidationError('manager_name is required');
    }
    return normalized;
};

const reportingManagerService = {
    create: (data) => reportingManagerTable.create({ manager_name: normalizeManagerName(data.manager_name) }),
    read: (id) => reportingManagerTable.read(id),
    update: (data) =>
        reportingManagerTable.update({ id: data.id, manager_name: normalizeManagerName(data.manager_name) }),
    delete: (id) => reportingManagerTable.delete(id),
};

export default reportingManagerService;
