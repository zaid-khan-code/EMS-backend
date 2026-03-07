import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import employeeRoutes from './src/routes/employee-routes.js';
import extraEmployeeRoutes from './src/routes/extra-employee-routes.js';
import departmentRoutes from './src/routes/department-routes.js';
import designationRoutes from './src/routes/designation-routes.js';
import employmentTypeRoutes from './src/routes/employment-type-routes.js';
import jobStatusRoutes from './src/routes/job-status-routes.js';
import jobInfoRoutes from './src/routes/job-info-routes.js';
import workModeRoutes from './src/routes/work-mode-routes.js';
import workLocationRoutes from './src/routes/work-location-routes.js';
import reportingManagerRoutes from './src/routes/reporting-manager-routes.js';
import authRoutes from './src/routes/authRoutes';
dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api', employeeRoutes);
app.use('/api', extraEmployeeRoutes);
app.use('/api', departmentRoutes);
app.use('/api', designationRoutes);
app.use('/api', employmentTypeRoutes);
app.use('/api', jobStatusRoutes);
app.use('/api', jobInfoRoutes);
app.use('/api', workModeRoutes);
app.use('/api', workLocationRoutes);
app.use('/api', reportingManagerRoutes);
app.use('/api/auth', authRoutes);


app.get('/', (req, res) => {
    res.send('server is running');
});
app.use((err, req, res, next) => {
    const status = err.status || 500;
    const message = err.message || 'Internal Server Error';
    res.status(status).json({ error: message });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
