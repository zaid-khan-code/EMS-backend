import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import authTable from '../models/auth-model.js';
console.log(authTable);

const authService = {
    login: async (username, password) => {
        // find user in DB
        const user = await authTable.findByUsername(username);

        if (!user) throw new Error('Invalid username or password');

        // compare password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) throw new Error('Invalid username or password');

        // create token
        const token = jwt.sign(
            {
                userId: user.id,
                username: user.username,
                role: user.role,
                employeeId: user.employee_id
            },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );

        return {
            token,
            user: {
                id: user.id,
                username: user.username,
                role: user.role,
                employeeId: user.employee_id
            }
        };
    }
};

export default authService;