import jwt from 'jsonwebtoken';

const HTTP_STATUS = {
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    INTERNAL_SERVER_ERROR: 500
};

const sendError = (res, statusCode, message) => {
    return res.status(statusCode).json({ message });
};

const extractBearerToken = (authorizationHeader) => {
    if (typeof authorizationHeader !== 'string') {
        return { token: null, statusCode: HTTP_STATUS.UNAUTHORIZED };
    }

    const [scheme, token] = authorizationHeader.split(' ');

    if (scheme?.toLowerCase() !== 'bearer' || !token) {
        return { token: null, statusCode: HTTP_STATUS.BAD_REQUEST };
    }

    return { token, statusCode: null };
};

export const verifyToken = (req, res, next) => {
    const { token, statusCode } = extractBearerToken(req.headers.authorization);

    if (!token) {
        return sendError(
            res,
            statusCode,
            statusCode === HTTP_STATUS.BAD_REQUEST
                ? 'Authorization header must use the Bearer token format.'
                : 'Authentication token is required.'
        );
    }

    if (!process.env.JWT_SECRET) {
        return sendError(
            res,
            HTTP_STATUS.INTERNAL_SERVER_ERROR,
            'Authentication service is not configured.'
        );
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;

        return next();
    } catch (error) {
        if (
            error.name === 'TokenExpiredError' ||
            error.name === 'JsonWebTokenError' ||
            error.name === 'NotBeforeError'
        ) {
            return sendError(
                res,
                HTTP_STATUS.UNAUTHORIZED,
                'Invalid or expired authentication token.'
            );
        }

        return sendError(
            res,
            HTTP_STATUS.INTERNAL_SERVER_ERROR,
            'Unable to authenticate the request.'
        );
    }
};

export const superAdminOnly = (req, res, next) => {
    if (!req.user) {
        return sendError(
            res,
            HTTP_STATUS.UNAUTHORIZED,
            'Authentication is required.'
        );
    }

    if (req.user.role !== 'super_admin') {
        return sendError(
            res,
            HTTP_STATUS.FORBIDDEN,
            'Access denied. Super admin only.'
        );
    }

    return next();
};
