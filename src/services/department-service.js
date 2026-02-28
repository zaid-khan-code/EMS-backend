import departmentTable from '../models/department-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeName = (name) => {
    const normalized = name?.trim();
    if (!normalized) {
        throw createValidationError('name is required');
    }
    return normalized;
};

const departmentService = {
    create: (data) => departmentTable.create({ name: normalizeName(data.name) }),
    read: (id) => departmentTable.read(id),
    update: (data) => departmentTable.update({ id: data.id, name: normalizeName(data.name) }),
    delete: (id) => departmentTable.delete(id),
};

export default departmentService;
