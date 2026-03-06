import bcrypt from "bcrypt";
import jwt from "jsonwebtoken"
import { findUserByUsername } from '../models/authModel';

export const loginUser = async (username, password) => {

    // 1. find user in DB
    const user = await findUserByUsername(username);

    // 2. user not found
    if (!user) {
        throw new Error('Invalid username or password');
    }

    // 3. compare password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        throw new Error('Invalid username or password');
    }

    // 4. create token
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
};

