import { db } from '../config/db.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import mailService from './mailService.js';

const JWT_SECRET = process.env.JWT_SECRET || 'secretkey';

export const authService = {
  register: async ({ fullname, username, password, email }) => {
    // check existing
    const [exists] = await db.query('SELECT id FROM users WHERE email=? OR username=?', [email, username]);
    if (exists.length > 0) {
      throw new Error('Email or username already registered');
    }

    const hashed = await bcrypt.hash(password, 10);
    const token = uuidv4();

    const q = 'INSERT INTO users (fullname, username, email, password, verification_token) VALUES (?, ?, ?, ?, ?)';
    const [result] = await db.query(q, [fullname, username, email, hashed, token]);

    try {
      await mailService.sendVerificationEmail(email, token);
    } catch (err) {
      console.warn('Failed to send verification email:', err.message);
    }

    return { id: result.insertId };
  },

  login: async ({ email, password }) => {
    const [rows] = await db.query('SELECT * FROM users WHERE email=?', [email]);
    const user = rows[0];
    if (!user) {
      throw new Error('Email or password wrong');
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      throw new Error('Email or password wrong');
    }

    const payload = { id: user.id, email: user.email };
    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '7d' });

    return { token };
  },

  verifyToken: async (token) => {
    const [rows] = await db.query('SELECT * FROM users WHERE verification_token=?', [token]);
    const user = rows[0];
    if (!user) return false;

    await db.query('UPDATE users SET is_verified=1, verification_token=NULL WHERE id=?', [user.id]);
    return true;
  }
};

export default authService;
