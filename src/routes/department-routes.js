import { Router } from 'express';
import {
    createDepartment,
    getDepartments,
    updateDepartment,
    deleteDepartment,
} from '../controllers/department-controller.js';

const router = Router();

router.post('/departments', createDepartment);
router.get('/departments', getDepartments);
router.get('/departments/:id', getDepartments);
router.put('/departments/:id', updateDepartment);
router.delete('/departments/:id', deleteDepartment);

export default router;
