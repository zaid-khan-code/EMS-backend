import { Router } from 'express';
import {
    createJobInfo,
    getJobInfo,
    updateJobInfo, 
} from '../controllers/job-info-controller.js';

const router = Router();

router.post('/job-info', createJobInfo);
router.get('/job-info', getJobInfo);
router.get('/job-info/:id', getJobInfo);
router.put('/job-info/:id', updateJobInfo); 

export default router;
