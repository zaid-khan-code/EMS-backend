import { Router } from 'express';
import { verifyToken } from '../middleware/auth-middleware.js';
import {
    createReportingManager,
    getReportingManagers,
    updateReportingManager,
    deleteReportingManager,
} from '../controllers/reporting-manager-controller.js';

const router = Router();

router.post('/reporting-managers', verifyToken, createReportingManager);
router.get('/reporting-managers', verifyToken, getReportingManagers);
router.get('/reporting-managers/:id', verifyToken, getReportingManagers);
router.put('/reporting-managers/:id', verifyToken, updateReportingManager);
router.delete('/reporting-managers/:id', verifyToken, deleteReportingManager);

export default router;
