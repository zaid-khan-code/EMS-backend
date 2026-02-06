import employeeTable from '../models/employee-info-model';

const employeeService = {
    create: (data) => employeeTable.create(data),
    read: (id) => employeeTable.read(id),
    update: (data) => employeeTable.update(data),
    delete: (id) => employeeTable.delete(id),
};

export default employeeService;
