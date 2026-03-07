import { Router } from 'express';
import { verifyToken } from '../middleware/authMiddleware.js';
import {
    createDesignation,
    getDesignations,
    updateDesignation,
    deleteDesignation,
} from '../controllers/designation-controller.js';

const router = Router();

router.post('/designations', verifyToken, createDesignation);
router.get('/designations', verifyToken, getDesignations);
router.get('/designations/:id', verifyToken, getDesignations);
router.put('/designations/:id', verifyToken, updateDesignation);
router.delete('/designations/:id', verifyToken, deleteDesignation);

export default router;
