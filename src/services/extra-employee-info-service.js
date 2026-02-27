import extraEmployeeInfoTable from '../models/extra-employee-info-model.js';

const extraEmployeeInfoService = {
    create: (data) => extraEmployeeInfoTable.create(data),
    read: () => extraEmployeeInfoTable.read(),
    update: (data) => extraEmployeeInfoTable.update(data) 
};

export default extraEmployeeInfoService;
