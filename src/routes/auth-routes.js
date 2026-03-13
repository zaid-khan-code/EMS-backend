import express from 'express';
import { login } from '../controllers/auth-controller.js';
export const router = express.Router();

router.post('/login', login);
