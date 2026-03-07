import { Router } from 'express';
import { verifyToken } from '../middleware/authMiddleware.js';
import {
    createEmploymentType,
    getEmploymentTypes,
    updateEmploymentType,
    deleteEmploymentType,
} from '../controllers/employment-type-controller.js';

const router = Router();

router.post('/employment-types', verifyToken, createEmploymentType);
router.get('/employment-types', verifyToken, getEmploymentTypes);
router.get('/employment-types/:id', verifyToken, getEmploymentTypes);
router.put('/employment-types/:id', verifyToken, updateEmploymentType);
router.delete('/employment-types/:id', verifyToken, deleteEmploymentType);

export default router;
