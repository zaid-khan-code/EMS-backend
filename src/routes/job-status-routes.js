import { Router } from 'express';
import { verifyToken } from '../middleware/auth-middleware.js';
import {
    createJobStatus,
    getJobStatuses,
    updateJobStatus,
    deleteJobStatus,
} from '../controllers/job-status-controller.js';

const router = Router();

router.post('/job-statuses', verifyToken, createJobStatus);
router.get('/job-statuses', verifyToken, getJobStatuses);
router.get('/job-statuses/:id', verifyToken, getJobStatuses);
router.put('/job-statuses/:id', verifyToken, updateJobStatus);
router.delete('/job-statuses/:id', verifyToken, deleteJobStatus);

export default router;
