import authService from '../services/auth-service.js';

const authController = {
    login: async (req, res) => {
        try {
            const { username, password } = req.body;

            if (!username || !password) {
                return res.status(400).json({
                    message: 'Username and password are required'
                });
            }

            const data = await authService.login(username, password);

            res.status(200).json({
                message: 'Login successful',
                token: data.token,
                user: data.user
            });

        } catch (err) {
            res.status(401).json({ message: err.message });
        }
    }
};

export default authController;