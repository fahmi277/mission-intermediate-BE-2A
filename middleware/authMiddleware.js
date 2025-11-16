import jwt from 'jsonwebtoken';
const JWT_SECRET = process.env.JWT_SECRET || 'secretkey';

export const authMiddleware = {
  verifyToken: (req, res, next) => {
    try {
      const authHeader = req.headers.authorization || req.headers.Authorization;
      if (!authHeader) return res.status(401).json({ message: 'Authentication failed: token missing' });

      // support "Bearer <token>" or raw token
      const parts = authHeader.split(' ');
      const token = parts.length === 2 ? parts[1] : parts[0];

      const decoded = jwt.verify(token, JWT_SECRET);
      req.user = decoded;
      next();
    } catch (err) {
      return res.status(401).json({ message: 'Authentication failed: invalid token' });
    }
  }
};

export default authMiddleware;
