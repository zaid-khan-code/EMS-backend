import { Router } from 'express';
import customFieldDefinitionController from '../controllers/custom-field-definition-controller.js';
import { verifyToken, superAdminOnly } from '../middleware/auth-middleware.js';

const router = Router();

// Field Definitions - super_admin only
router.get('/', verifyToken, superAdminOnly, customFieldDefinitionController.getAll);
router.get('/section/:section', verifyToken, superAdminOnly, customFieldDefinitionController.getBySection);
router.get('/:id', verifyToken, superAdminOnly, customFieldDefinitionController.getById);
router.post('/', verifyToken, superAdminOnly, customFieldDefinitionController.createDefinition);
router.put('/:id', verifyToken, superAdminOnly, customFieldDefinitionController.updateDefinition);
router.delete('/:id', verifyToken, superAdminOnly, customFieldDefinitionController.deleteDefinition);

// Field Options - super_admin only
router.get('/:fieldDefinitionId/options', verifyToken, superAdminOnly, customFieldDefinitionController.getOptions);
router.post('/:fieldDefinitionId/options', verifyToken, superAdminOnly, customFieldDefinitionController.createOption);
router.put('/options/:optionId', verifyToken, superAdminOnly, customFieldDefinitionController.updateOption);
router.delete('/options/:optionId', verifyToken, superAdminOnly, customFieldDefinitionController.deleteOption);

// Field Values - all authenticated users can read own, all can upsert for their own
router.get('/employee/:employeeId', verifyToken, customFieldDefinitionController.getEmployeeValues);
router.post('/employee/:employeeId/values', verifyToken, customFieldDefinitionController.upsertEmployeeValue);
router.delete('/values/:valueId', verifyToken, customFieldDefinitionController.deleteEmployeeValue);

export default router;
