import taxConfigTable from '../models/tax-config-model.js';

const taxConfigService = {
    create: async (data) => {
        // Validate salary_from
        if (data.salary_from < 0) {
            throw { status: 400, message: 'Salary from cannot be negative' };
        }

        // Validate salary_to if provided
        if (data.salary_to !== null && data.salary_to !== undefined) {
            if (data.salary_to <= data.salary_from) {
                throw { status: 400, message: 'Salary to must be greater than salary from' };
            }
        }

        // Validate tax_rate_percent
        if (data.tax_rate_percent < 0 || data.tax_rate_percent > 100) {
            throw { status: 400, message: 'Tax rate must be between 0 and 100' };
        }

        return taxConfigTable.create(data);
    },

    read: (id) => taxConfigTable.read(id),

    readActive: () => taxConfigTable.readActive(),

    update: async (data) => {
        // Validate salary_from
        if (data.salary_from < 0) {
            throw { status: 400, message: 'Salary from cannot be negative' };
        }

        // Validate salary_to if provided
        if (data.salary_to !== null && data.salary_to !== undefined) {
            if (data.salary_to <= data.salary_from) {
                throw { status: 400, message: 'Salary to must be greater than salary from' };
            }
        }

        // Validate tax_rate_percent
        if (data.tax_rate_percent < 0 || data.tax_rate_percent > 100) {
            throw { status: 400, message: 'Tax rate must be between 0 and 100' };
        }

        return taxConfigTable.update(data);
    },

    delete: (id) => taxConfigTable.delete(id),

    // Get tax bracket for a salary (for payroll calculation)
    getBracketForSalary: (salary) => taxConfigTable.findBracketForSalary(salary),

    // Calculate tax for a given salary
    calculateTax: async (salary) => {
        const bracket = await taxConfigTable.findBracketForSalary(salary);
        if (!bracket) {
            return { tax: 0, bracket: null };
        }

        const percentTax = (salary * bracket.tax_rate_percent) / 100;
        const totalTax = percentTax + parseFloat(bracket.fixed_amount || 0);

        return {
            tax: Math.round(totalTax * 100) / 100,
            bracket
        };
    },
};

export default taxConfigService;
