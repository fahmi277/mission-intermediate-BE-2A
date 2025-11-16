import express from 'express';
import courseRoutes from './routes/courseRoutes.js';
import authRoutes from './routes/authRoutes.js';
import uploadRoutes from './routes/uploadRoutes.js';
import './config/db.js';
import path from 'path';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use(courseRoutes);
app.use(authRoutes);
app.use(uploadRoutes);

// serve uploaded files statically
app.use('/upload', express.static(path.join(process.cwd(), 'upload')));

// Root endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'EduCourse API is running',
    endpoints: {
      'POST /register': 'Register new user',
      'POST /login': 'Login user',
      'GET /verify-email': 'Verify email',
      'GET /course': 'Get all courses',
      'GET /course/:id': 'Get course by ID',
      'POST /course': 'Create new course',
      'PATCH /course/:id': 'Update course',
      'DELETE /course/:id': 'Delete course',
      'POST /upload': 'Upload file'
    }
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error', message: err.message });
});

// Start server
app.listen(PORT, () => {
  console.log(`EduCourse API running on port ${PORT}`);
  console.log(`Visit http://localhost:${PORT}/ to see all endpoints`);
}).on('error', (err) => {
  console.error('Server error:', err);
});
