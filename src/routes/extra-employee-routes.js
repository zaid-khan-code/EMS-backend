import { Router } from 'express';
import {
    createEmployee,
    getEmployees,
    updateEmployee,
    deleteEmployee,
} from '../controllers/extra-employee-info-controller.js';

const router = Router();

router.post('/extra-employees', createEmployee);
router.get('/extra-employees', getEmployees);
router.get('/extra-employees/:id', getEmployees);
router.put('/extra-employees/:id', updateEmployee);
router.delete('/extra-employees/:id', deleteEmployee);

export default router;
