import { Router } from 'express';
import shiftController from '../controllers/shift-controller.js';
import { verifyToken } from '../middleware/auth-middleware.js';

const router = Router();

router.get('/', verifyToken, shiftController.getAll);
router.get('/:id', verifyToken, shiftController.getById);
router.post('/', verifyToken, shiftController.create);
router.put('/:id', verifyToken, shiftController.update);
router.delete('/:id', verifyToken, shiftController.delete);

export default router;
