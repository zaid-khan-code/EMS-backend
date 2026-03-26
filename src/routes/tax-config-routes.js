import { Router } from 'express';
import taxConfigController from '../controllers/tax-config-controller.js';
import { verifyToken } from '../middleware/auth-middleware.js';

const router = Router();

router.get('/', verifyToken, taxConfigController.getAll);
router.get('/active', verifyToken, taxConfigController.getActive);
router.get('/calculate', verifyToken, taxConfigController.calculateTax);
router.get('/:id', verifyToken, taxConfigController.getById);
router.post('/', verifyToken, taxConfigController.create);
router.put('/:id', verifyToken, taxConfigController.update);
router.delete('/:id', verifyToken, taxConfigController.delete);

export default router;
