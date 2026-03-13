import { Router } from 'express';
import { verifyToken } from '../middleware/auth-middleware.js';
import {
    createJobInfo,
    getJobInfo,
    updateJobInfo,
    deleteJobInfo,
} from '../controllers/job-info-controller.js';

const router = Router();

router.post('/job-info', verifyToken, createJobInfo);
router.get('/job-info', verifyToken, getJobInfo);
router.get('/job-info/:id', verifyToken, getJobInfo);
router.put('/job-info/:id', verifyToken, updateJobInfo);
router.delete('/job-info/:id', verifyToken, deleteJobInfo);

export default router;
