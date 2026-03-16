import pool from '../config/db.js';

const authTable = {
    findByUsername: async (username) => {
        const res = await pool.query(
            `SELECT * FROM users WHERE username = $1 AND is_active = true`,
            [username]
        );
        return res.rows[0];
    }
};

export default authTable;