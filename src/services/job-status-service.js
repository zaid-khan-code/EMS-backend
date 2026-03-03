import jobStatusTable from '../models/job-status-model.js';

const jobStatusService = {
    create: (data) => jobStatusTable.create(data),
    read: (id) => jobStatusTable.read(id),
    update: (data) => jobStatusTable.update(data),
    delete: (id) => jobStatusTable.delete(id),
};

export default jobStatusService;
