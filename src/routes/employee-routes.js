// this is my employee-routes

import { Router } from 'express';
import {
    createEmployee,
    getEmployees,
    updateEmployee,
    deleteEmployee, 
    getEmployeesId,
} from '../controllers/employee-info-controller.js';

const router = Router();

router.post('/employees', createEmployee);
router.get('/employees', getEmployees);
router.get('/employees/ids', getEmployeesId);
router.get('/employees/:id', getEmployees);
router.put('/employees/:id', updateEmployee);
router.delete('/employees/:id', deleteEmployee);


export default router;
