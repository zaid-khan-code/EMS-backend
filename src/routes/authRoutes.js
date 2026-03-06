import express from 'express';
import { login } from '../controllers/authController';
export const router = express.Router();

router.post('/login', login);
