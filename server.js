import express from 'express';
import courseRoutes from './routes/courseRoutes.js';
import './config/db.js';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use(courseRoutes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'EduCourse API is running',
    endpoints: {
      'GET /course': 'Get all courses',
      'GET /course/:id': 'Get course by ID',
      'POST /course': 'Create new course',
      'PATCH /course/:id': 'Update course',
      'DELETE /course/:id': 'Delete course'
    }
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`EduCourse API running on port ${PORT}`);
});
