import jobInfoTable from '../models/job-info-model.js';

const createValidationError = (message) => {
    const err = new Error(message);
    err.status = 400;
    return err;
};

const validateDates = (data) => {
    const { date_of_joining, date_of_exit } = data;

    if (!date_of_joining) {
        throw createValidationError('date_of_joining is required');
    }

    if (date_of_exit && new Date(date_of_exit) < new Date(date_of_joining)) {
        throw createValidationError('date_of_exit cannot be earlier than date_of_joining');
    }
};

const normalizePayload = (data) => ({
    ...data,
    employee_id: data.employee_id?.trim(),
    shift_timing: data.shift_timing?.trim() || null,
    date_of_exit: data.date_of_exit || null,
});

const jobInfoService = {
    create: (data) => {
        const payload = normalizePayload(data);
        validateDates(payload);
        return jobInfoTable.create(payload);
    },

    read: (id) => jobInfoTable.read(id),

    update: (data) => {
        const payload = normalizePayload(data);
        validateDates(payload);
        return jobInfoTable.update(payload);
    },

     
};

export default jobInfoService;
