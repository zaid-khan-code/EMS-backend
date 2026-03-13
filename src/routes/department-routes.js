import { Router } from 'express';
import { verifyToken } from '../middleware/auth-middleware.js';
import {
    createDepartment,
    getDepartments,
    updateDepartment,
    deleteDepartment,
} from '../controllers/department-controller.js';

const router = Router();

router.post('/departments', verifyToken, createDepartment);
router.get('/departments', verifyToken, getDepartments);
router.get('/departments/:id', verifyToken, getDepartments);
router.put('/departments/:id', verifyToken, updateDepartment);
router.delete('/departments/:id', verifyToken, deleteDepartment);

export default router;
