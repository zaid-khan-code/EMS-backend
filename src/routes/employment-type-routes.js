import { Router } from 'express';
import {
    createEmploymentType,
    getEmploymentTypes,
    updateEmploymentType,
    deleteEmploymentType,
} from '../controllers/employment-type-controller.js';

const router = Router();

router.post('/employment-types', createEmploymentType);
router.get('/employment-types', getEmploymentTypes);
router.get('/employment-types/:id', getEmploymentTypes);
router.put('/employment-types/:id', updateEmploymentType);
router.delete('/employment-types/:id', deleteEmploymentType);

export default router;
