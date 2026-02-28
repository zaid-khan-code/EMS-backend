import { Router } from 'express';
import {
    createDesignation,
    getDesignations,
    updateDesignation,
    deleteDesignation,
} from '../controllers/designation-controller.js';

const router = Router();

router.post('/designations', createDesignation);
router.get('/designations', getDesignations);
router.get('/designations/:id', getDesignations);
router.put('/designations/:id', updateDesignation);
router.delete('/designations/:id', deleteDesignation);

export default router;
