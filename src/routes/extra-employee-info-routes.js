import { Router } from 'express';
import { verifyToken } from '../middleware/auth-middleware.js';
import {
    createEmployee,
    getEmployees,
    updateEmployee,
} from '../controllers/extra-employee-info-controller.js';

const router = Router();

router.post('/extra-employees', verifyToken, createEmployee);
router.get('/extra-employees', verifyToken, getEmployees);
router.put('/extra-employees', verifyToken, updateEmployee);
 
export default router;
