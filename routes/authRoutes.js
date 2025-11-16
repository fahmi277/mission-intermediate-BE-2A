import express from 'express';
import authService from '../services/authService.js';

const router = express.Router();

router.post('/register', async (req, res) => {
  try {
    const { fullname, username, password, email } = req.body;
    if (!fullname || !username || !password || !email) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const result = await authService.register({ fullname, username, password, email });
    res.status(201).json({ message: 'User registered', id: result.id });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'Missing credentials' });

    const { token } = await authService.login({ email, password });
    res.json({ token });
  } catch (err) {
    res.status(401).json({ error: err.message });
  }
});

router.get('/verify-email', async (req, res) => {
  try {
    const token = req.query.token;
    if (!token) return res.status(400).json({ message: 'Token is required' });

    const ok = await authService.verifyToken(token);
    if (!ok) return res.status(400).json({ message: 'Invalid Verification Token' });

    res.json({ message: 'Email Verified Successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
