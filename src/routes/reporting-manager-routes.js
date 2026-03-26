import { Router } from 'express';
import reportingManagerController from '../controllers/reporting-manager-controller.js';
import { verifyToken } from '../middleware/auth-middleware.js';

const router = Router();

router.get('/', verifyToken, reportingManagerController.getAll);
router.get('/department/:departmentId', verifyToken, reportingManagerController.getByDepartment);
router.get('/:id', verifyToken, reportingManagerController.getById);
router.post('/', verifyToken, reportingManagerController.create);
router.put('/:id', verifyToken, reportingManagerController.update);
router.delete('/:id', verifyToken, reportingManagerController.delete);

export default router;
