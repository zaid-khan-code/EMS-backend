import jobInfoTable from '../models/job-info-model.js';

const jobInfoService = {
    create: (data) => jobInfoTable.create(data),
    read: (id) => jobInfoTable.read(id),
    update: (data) => jobInfoTable.update(data),
    delete: (id) => jobInfoTable.delete(id),
};

export default jobInfoService;
