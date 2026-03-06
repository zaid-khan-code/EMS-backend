import jwt from 'jsonwebtoken';

export const verifyToken = (req, res, next) => {
    try {
        // get token from header
        const authHeader = req.headers.authorization;

        if (!authHeader) {
            return res.status(401).json({
                message: 'No token. Please login first.'
            });
        }

        // token format: "Bearer eyJhbG..."
        const token = authHeader.split(' ')[1];

        // verify token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        
        // attach user info to request
        req.user = decoded;

        next(); // ← move to next (the actual route)

    } catch (err) {
        return res.status(401).json({
            message: 'Invalid or expired token. Please login again.'
        });
    }
};

// extra middleware: super_admin only routes
export const superAdminOnly = (req, res, next) => {
    if (req.user.role !== 'super_admin') {
        return res.status(403).json({
            message: 'Access denied. Super admin only.'
        });
    }
    next();
};