import { Router } from 'express';
import payrollComponentController from '../controllers/payroll-component-controller.js';
import { verifyToken } from '../middleware/auth-middleware.js';

const router = Router();

router.get('/', verifyToken, payrollComponentController.getAll);
router.get('/active', verifyToken, payrollComponentController.getActive);
router.get('/type/:type', verifyToken, payrollComponentController.getByType);
router.get('/:id', verifyToken, payrollComponentController.getById);
router.post('/', verifyToken, payrollComponentController.create);
router.put('/:id', verifyToken, payrollComponentController.update);
router.delete('/:id', verifyToken, payrollComponentController.delete);

export default router;
