import { Router } from 'express';
import {
    createReportingManager,
    getReportingManagers,
    updateReportingManager,
    deleteReportingManager,
} from '../controllers/reporting-manager-controller.js';

const router = Router();

router.post('/reporting-managers', createReportingManager);
router.get('/reporting-managers', getReportingManagers);
router.get('/reporting-managers/:id', getReportingManagers);
router.put('/reporting-managers/:id', updateReportingManager);
router.delete('/reporting-managers/:id', deleteReportingManager);

export default router;
