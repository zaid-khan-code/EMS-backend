import workLocationTable from '../models/work-location-model.js';

const workLocationService = {
    create: (data) => workLocationTable.create(data),
    read: (id) => workLocationTable.read(id),
    update: (data) => workLocationTable.update(data),
    delete: (id) => workLocationTable.delete(id),
};

export default workLocationService;
