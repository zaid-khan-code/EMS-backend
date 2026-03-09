import { Router } from 'express';
import userController from '../controllers/userController.js';
import { verifyToken, superAdminOnly } from '../middleware/authMiddleware.js';

const router = Router();

router.get('/', verifyToken, superAdminOnly, userController.getAll);
router.get('/:id', verifyToken, superAdminOnly, userController.getById);
router.post('/', verifyToken, superAdminOnly, userController.create);
router.patch('/:id', verifyToken, superAdminOnly, userController.updateStatus);
router.delete('/:id', verifyToken, superAdminOnly, userController.delete);

export default router;