import employmentTypeTable from '../models/employment-type-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeTypeName = (typeName) => {
    const normalized = typeName?.trim();
    if (!normalized) {
        throw createValidationError('type_name is required');
    }
    return normalized;
};

const employmentTypeService = {
    create: (data) => employmentTypeTable.create({ type_name: normalizeTypeName(data.type_name) }),
    read: (id) => employmentTypeTable.read(id),
    update: (data) =>
        employmentTypeTable.update({ id: data.id, type_name: normalizeTypeName(data.type_name) }),
    delete: (id) => employmentTypeTable.delete(id),
};

export default employmentTypeService;
