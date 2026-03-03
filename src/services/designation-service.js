import designationTable from '../models/designation-model.js';

const designationService = {
    create: (data) => designationTable.create(data),
    read: (id) => designationTable.read(id),
    update: (data) => designationTable.update(data),
    delete: (id) => designationTable.delete(id),
};

export default designationService;
