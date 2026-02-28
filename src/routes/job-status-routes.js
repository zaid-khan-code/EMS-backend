import { Router } from 'express';
import {
    createJobStatus,
    getJobStatuses,
    updateJobStatus,
    deleteJobStatus,
} from '../controllers/job-status-controller.js';

const router = Router();

router.post('/job-statuses', createJobStatus);
router.get('/job-statuses', getJobStatuses);
router.get('/job-statuses/:id', getJobStatuses);
router.put('/job-statuses/:id', updateJobStatus);
router.delete('/job-statuses/:id', deleteJobStatus);

export default router;
