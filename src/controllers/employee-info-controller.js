import employeeService from '../services/employee-info-service';

export const createEmployee = async (req, res, next) => {
    try {
        const employee = await employeeService.create(req.body);
        return res.status(201).json({ ok: true, data: employee });
    } catch (err) {
        return next(err);
    }
};

export const getEmployees = async (req, res, next) => {
    try {
        const { id } = req.params;
        const data = await employeeService.read(id);
        return res.status(200).json({ ok: true, data });
    } catch (err) {
        return next(err);
    }
};

export const updateEmployee = async (req, res, next) => {
    try {
        const { id } = req.params;
        const employee = await employeeService.update({ id, ...req.body });
        return res.status(200).json({ ok: true, data: employee });
    } catch (err) {
        return next(err);
    }
};

export const deleteEmployee = async (req, res, next) => {
    try {
        const { id } = req.params;
        const employee = await employeeService.delete(id);
        return res.status(200).json({ ok: true, data: employee });
    } catch (err) {
        return next(err);
    }
};
