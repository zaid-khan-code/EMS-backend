import extraEmployeeInfoTable from '../models/extra-employee-info-model.js';

const extraEmployeeInfoService = {
    create: (data) => extraEmployeeInfoTable.create(data),
    read: (id) => extraEmployeeInfoTable.read(id),
    update: (data) => extraEmployeeInfoTable.update(data),
    delete: (id) => extraEmployeeInfoTable.delete(id),
};

export default extraEmployeeInfoService;
