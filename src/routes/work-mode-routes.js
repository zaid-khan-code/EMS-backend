import { Router } from 'express';
import {
    createWorkMode,
    getWorkModes,
    updateWorkMode,
    deleteWorkMode,
} from '../controllers/work-mode-controller.js';

const router = Router();

router.post('/work-modes', createWorkMode);
router.get('/work-modes', getWorkModes);
router.get('/work-modes/:id', getWorkModes);
router.put('/work-modes/:id', updateWorkMode);
router.delete('/work-modes/:id', deleteWorkMode);

export default router;
