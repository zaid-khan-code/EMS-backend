import jwt from 'jsonwebtoken' ;

export const verifyToken = (req, res, next) => {
    try {
        console.log('=================================');
        console.log('🔒 MIDDLEWARE TRIGGERED');
        console.log('📍 Route hit:', req.method, req.originalUrl);
        console.log('=================================');

        // STEP 1: check if header exists
        const authHeader = req.headers.authorization;
        console.log('📨 Authorization Header:', authHeader);

        if (!authHeader) {
            console.log('❌ No token found in header — BLOCKED');
            return res.status(401).json({ 
                message: 'No token. Please login first.' 
            });
        }

        // STEP 2: extract token from "Bearer eyJhbG..."
        const token = authHeader.split(' ')[1];
        console.log('🎫 Extracted Token:', token);

        // STEP 3: verify the token
        console.log('🔑 Verifying token with SECRET...');
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        console.log('✅ Token is VALID!');
        console.log('👤 Decoded User Info:', decoded);
        // decoded will show:
        // {
        //   userId: 1,
        //   username: 'superadmin',
        //   role: 'super_admin',
        //   iat: 1234567 (issued at),
        //   exp: 1234567 (expires at)
        // }

        // STEP 4: attach user to request
        req.user = decoded;
        console.log('📌 User attached to request:', req.user);
        console.log('➡️  Passing to actual route now...');
        console.log('=================================');

        next(); // ← GO to the actual route

    } catch (err) {
        console.log('=================================');
        console.log('❌ MIDDLEWARE BLOCKED REQUEST');
        console.log('🚨 Reason:', err.message);
        // err.message will be one of:
        // "jwt expired"
        // "invalid token"
        // "invalid signature"
        // "jwt malformed"
        console.log('=================================');
        return res.status(401).json({ 
            message: 'Invalid or expired token. Please login again.' 
        });
    }
};

export const superAdminOnly = (req, res, next) => {
    console.log('=================================');
    console.log('👑 SUPER ADMIN CHECK');
    console.log('👤 User role is:', req.user.role);

    if (req.user.role !== 'super_admin') {
        console.log('❌ NOT super_admin — BLOCKED');
        console.log('=================================');
        return res.status(403).json({ 
            message: 'Access denied. Super admin only.' 
        });
    }

    console.log('✅ Is super_admin — ALLOWED');
    console.log('=================================');
    next();
};

