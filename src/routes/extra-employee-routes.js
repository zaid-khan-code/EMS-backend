import { Router } from 'express';
import {
    createEmployee,
    getEmployees,
    updateEmployee,
} from '../controllers/extra-employee-info-controller.js';

const router = Router();

router.post('/extra-employees', createEmployee);
router.get('/extra-employees', getEmployees);
router.put('/extra-employees', updateEmployee);
 
export default router;
