import workLocationTable from '../models/work-location-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const normalizeLocationName = (locationName) => {
    const normalized = locationName?.trim();
    if (!normalized) {
        throw createValidationError('location_name is required');
    }
    return normalized;
};

const workLocationService = {
    create: (data) => workLocationTable.create({ location_name: normalizeLocationName(data.location_name) }),
    read: (id) => workLocationTable.read(id),
    update: (data) =>
        workLocationTable.update({ id: data.id, location_name: normalizeLocationName(data.location_name) }),
    delete: (id) => workLocationTable.delete(id),
};

export default workLocationService;
