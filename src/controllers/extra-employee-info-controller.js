import employeeService from '../services/extra-employee-info-service.js';

export const createEmployee = async (req, res, next) => {
    try {
        const employee = await employeeService.create(req.body);
        return res.status(201).json(employee);
    } catch (err) {
        return next(err);
    }
};

export const getEmployees = async (req, res, next) => {
    try {
        const data = await employeeService.read();
        return res.status(200).json(data);
    } catch (err) {
        return next(err);
    }
};

export const updateEmployee = async (req, res, next) => {
    try {
        const employee = await employeeService.update(req.body);
        return res.status(200).json(employee);
    } catch (err) {
        return next(err);
    }
};

