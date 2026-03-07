import { Router } from 'express';
import { verifyToken } from '../middleware/authMiddleware.js';
import {
    createWorkLocation,
    getWorkLocations,
    updateWorkLocation,
    deleteWorkLocation,
} from '../controllers/work-location-controller.js';

const router = Router();

router.post('/work-locations', verifyToken, createWorkLocation);
router.get('/work-locations', verifyToken, getWorkLocations);
router.get('/work-locations/:id', verifyToken, getWorkLocations);
router.put('/work-locations/:id', verifyToken, updateWorkLocation);
router.delete('/work-locations/:id', verifyToken, deleteWorkLocation);

export default router;
