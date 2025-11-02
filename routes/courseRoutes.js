import express from 'express';
import { CourseService } from '../services/courseService.js';

const router = express.Router();

// GET all courses
router.get('/course', async (req, res) => {
  try {
    const courses = await CourseService.getAll();
    res.json(courses);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET course by ID
router.get('/course/:id', async (req, res) => {
  try {
    const course = await CourseService.getById(req.params.id);
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }
    res.json(course);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST create new course
router.post('/course', async (req, res) => {
  try {
    await CourseService.create(req.body);
    res.status(201).json({ message: 'Course created' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// PATCH update course
router.patch('/course/:id', async (req, res) => {
  try {
    await CourseService.update(req.params.id, req.body);
    res.json({ message: 'Course updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE remove course
router.delete('/course/:id', async (req, res) => {
  try {
    await CourseService.remove(req.params.id);
    res.json({ message: 'Course deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
