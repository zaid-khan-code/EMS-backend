import { Router } from 'express';
import {
    createWorkLocation,
    getWorkLocations,
    updateWorkLocation,
    deleteWorkLocation,
} from '../controllers/work-location-controller.js';

const router = Router();

router.post('/work-locations', createWorkLocation);
router.get('/work-locations', getWorkLocations);
router.get('/work-locations/:id', getWorkLocations);
router.put('/work-locations/:id', updateWorkLocation);
router.delete('/work-locations/:id', deleteWorkLocation);

export default router;
