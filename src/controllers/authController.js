import { loginUser }  from '../services/authService';

export const login = async (req, res) => {
    try {
        const { username, password } = req.body;

        // basic validation
        if (!username || !password) {
            return res.status(400).json({
                message: 'Username and password are required'
            });
        }

        const data = await loginUser(username, password);

        res.status(200).json({
            message: 'Login successful',
            token: data.token,
            user: data.user
        });

    } catch (err) {
        res.status(401).json({ message: err.message });
    }
};