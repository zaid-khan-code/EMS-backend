import  pool from "../config/db.js";

export const findUserByUsername = async (username) => {
    const result = await pool.query(
        `SELECT * FROM users WHERE username = $1 AND is_active = true`,
        [username]
    );
    return result.rows[0];
};
