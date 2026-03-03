import reportingManagerTable from '../models/reporting-manager-model.js';

const reportingManagerService = {
    create: (data) => reportingManagerTable.create(data),
    read: (id) => reportingManagerTable.read(id),
    update: (data) => reportingManagerTable.update(data),
    delete: (id) => reportingManagerTable.delete(id),
};

export default reportingManagerService;
