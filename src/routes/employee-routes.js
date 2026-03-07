// this is my employee-routes

import { Router } from 'express';
import { verifyToken } from '../middleware/authMiddleware.js';
import {
    createEmployee,
    getEmployees,
    updateEmployee,
    deleteEmployee,
    getEmployeesId,
} from '../controllers/employee-info-controller.js';

const router = Router();

router.post('/employees', verifyToken, createEmployee);
router.get('/employees', verifyToken, getEmployees);
router.get('/employees/ids', verifyToken, getEmployeesId);
router.get('/employees/:id', verifyToken, getEmployees);
router.put('/employees/:id', verifyToken, updateEmployee);
router.delete('/employees/:id', verifyToken, deleteEmployee);


export default router;
