# 📘 Implementation Guide - EduCourse Backend

Panduan lengkap implementasi fitur-fitur backend EduCourse sesuai requirement di `readme2.md`.

---

## 📋 Daftar Fitur yang Diimplementasikan

✅ **1. Tabel Users** - Entitas user dengan fullname, username, password, email, verification_token  
✅ **2. Register User (POST /register)** - Registrasi dengan bcrypt password hashing  
✅ **3. Login & JWT (POST /login)** - Login dengan JWT token  
✅ **4. Middleware Auth** - JWT verification middleware  
✅ **5. Query Params di GET /course** - Filter, sort, search  
✅ **6. Email Verification (GET /verify-email)** - Verifikasi email dengan token  
✅ **7. Upload Image (POST /upload)** - Upload file dengan multer  

---

## 1️⃣ Entitas & Tabel User

### Database Schema (`database-schema.sql`)

```sql
CREATE TABLE `users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `fullname` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL UNIQUE,
  `email` varchar(255) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `verification_token` varchar(255),
  `is_verified` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Field Explanation:**
- `fullname` - Nama lengkap user
- `username` - Username unik
- `email` - Email unik untuk login
- `password` - Password yang sudah di-hash dengan bcrypt
- `verification_token` - Token UUID untuk verifikasi email
- `is_verified` - Status verifikasi (0=belum, 1=sudah)

---

## 2️⃣ Register User (POST /register)

### Service Layer (`services/authService.js`)

```javascript
register: async ({ fullname, username, password, email }) => {
  // 1. Check existing user
  const [exists] = await db.query(
    'SELECT id FROM users WHERE email=? OR username=?', 
    [email, username]
  );
  if (exists.length > 0) {
    throw new Error('Email or username already registered');
  }

  // 2. Hash password dengan bcrypt
  const hashed = await bcrypt.hash(password, 10);
  
  // 3. Generate verification token dengan uuid
  const token = uuidv4();

  // 4. Insert ke database
  const q = 'INSERT INTO users (fullname, username, email, password, verification_token) VALUES (?, ?, ?, ?, ?)';
  const [result] = await db.query(q, [fullname, username, email, hashed, token]);

  // 5. Send verification email
  try {
    await mailService.sendVerificationEmail(email, token);
  } catch (err) {
    console.warn('Failed to send verification email:', err.message);
  }

  return { id: result.insertId };
}
```

### Route Layer (`routes/authRoutes.js`)

```javascript
router.post('/register', async (req, res) => {
  try {
    const { fullname, username, password, email } = req.body;
    
    // Validasi input
    if (!fullname || !username || !password || !email) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const result = await authService.register({ fullname, username, password, email });
    res.status(201).json({ message: 'User registered', id: result.id });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});
```

**Testing:**
```powershell
$body = @{
    fullname = "John Doe"
    username = "johndoe"
    password = "password123"
    email = "john@example.com"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/register" -Method POST -Body $body -ContentType "application/json"
```

---

## 3️⃣ Login & JWT (POST /login)

### Service Layer (`services/authService.js`)

```javascript
login: async ({ email, password }) => {
  // 1. Cari user berdasarkan email
  const [rows] = await db.query('SELECT * FROM users WHERE email=?', [email]);
  const user = rows[0];
  
  // 2. Jika tidak ada, kirim error
  if (!user) {
    throw new Error('Email or password wrong');
  }

  // 3. Compare password dengan bcrypt
  const match = await bcrypt.compare(password, user.password);
  if (!match) {
    throw new Error('Email or password wrong');
  }

  // 4. Generate JWT token
  const payload = { id: user.id, email: user.email };
  const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '7d' });

  return { token };
}
```

### Route Layer (`routes/authRoutes.js`)

```javascript
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: 'Missing credentials' });
    }

    const { token } = await authService.login({ email, password });
    res.json({ token });
  } catch (err) {
    res.status(401).json({ error: err.message });
  }
});
```

**Testing:**
```powershell
$body = @{
    email = "john@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/login" -Method POST -Body $body -ContentType "application/json"
```

---

## 4️⃣ Middleware Auth (JWT)

### Middleware (`middleware/authMiddleware.js`)

```javascript
import jwt from 'jsonwebtoken';
const JWT_SECRET = process.env.JWT_SECRET || 'secretkey';

export const authMiddleware = {
  verifyToken: (req, res, next) => {
    try {
      // 1. Ambil token dari header Authorization
      const authHeader = req.headers.authorization || req.headers.Authorization;
      if (!authHeader) {
        return res.status(401).json({ 
          message: 'Authentication failed: token missing' 
        });
      }

      // 2. Support "Bearer <token>" atau raw token
      const parts = authHeader.split(' ');
      const token = parts.length === 2 ? parts[1] : parts[0];

      // 3. Verify token dengan jwt.verify
      const decoded = jwt.verify(token, JWT_SECRET);
      
      // 4. Simpan data user di req.user
      req.user = decoded;
      
      // 5. Lanjutkan ke controller
      next();
    } catch (err) {
      return res.status(401).json({ 
        message: 'Authentication failed: invalid token' 
      });
    }
  }
};
```

### Penggunaan di Route

```javascript
import authMiddleware from '../middleware/authMiddleware.js';

// Endpoint yang memerlukan auth
router.get('/course', authMiddleware.verifyToken, async (req, res) => {
  // req.user berisi { id, email } dari JWT
  const courses = await CourseService.getAll();
  res.json(courses);
});
```

**Testing dengan Auth:**
```powershell
$token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
$headers = @{
    "Authorization" = "Bearer $token"
}

Invoke-RestMethod -Uri "http://localhost:3000/course" -Headers $headers -Method GET
```

---

## 5️⃣ Query Params: Filter, Sort, Search (GET /course)

### Service Layer (`services/courseService.js`)

```javascript
getAll: async (options = {}) => {
  // Base query
  let base = 'SELECT * FROM Produk_Kelas';
  const clauses = [];
  const params = [];

  // 1. FILTERING - WHERE kategori_id = ?
  if (options.kategori_id) {
    clauses.push('kategori_id = ?');
    params.push(options.kategori_id);
  }

  // 2. SEARCH - WHERE nama_kelas LIKE ? OR deskripsi LIKE ?
  if (options.search) {
    clauses.push('(nama_kelas LIKE ? OR deskripsi LIKE ?)');
    params.push(`%${options.search}%`, `%${options.search}%`);
  }

  // Gabungkan WHERE clauses
  if (clauses.length > 0) {
    base += ' WHERE ' + clauses.join(' AND ');
  }

  // 3. SORTING - ORDER BY field
  const allowedSort = ['kelas_id', 'nama_kelas', 'harga'];
  if (options.sortBy && allowedSort.includes(options.sortBy)) {
    base += ` ORDER BY ${options.sortBy}`;
  }

  const [rows] = await db.query(base, params);
  return rows;
}
```

### Route Layer (`routes/courseRoutes.js`)

```javascript
router.get('/course', async (req, res) => {
  try {
    // Ambil query params dari req.query
    const { kategori_id, sortBy, search } = req.query;
    
    const courses = await CourseService.getAll({ 
      kategori_id, 
      sortBy, 
      search 
    });
    
    res.json(courses);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

**Testing:**
```powershell
# Filter kategori 1
Invoke-RestMethod -Uri "http://localhost:3000/course?kategori_id=1"

# Sort by harga
Invoke-RestMethod -Uri "http://localhost:3000/course?sortBy=harga"

# Search "node"
Invoke-RestMethod -Uri "http://localhost:3000/course?search=node"

# Kombinasi
Invoke-RestMethod -Uri "http://localhost:3000/course?kategori_id=1&search=react&sortBy=harga"
```

---

## 6️⃣ Send Email Verifikasi (GET /verify-email)

### Mail Service (`services/mailService.js`)

```javascript
import nodemailer from 'nodemailer';
import { createTransport } from 'nodemailer';

const createMailer = async () => {
  // Jika ada SMTP config di .env, gunakan itu
  if (process.env.SMTP_HOST && process.env.SMTP_USER && process.env.SMTP_PASS) {
    return createTransport({
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT ? Number(process.env.SMTP_PORT) : 587,
      secure: false,
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
    });
  }

  // Fallback: gunakan Ethereal test account
  const testAccount = await nodemailer.createTestAccount();
  return createTransport({
    host: 'smtp.ethereal.email',
    port: 587,
    secure: false,
    auth: {
      user: testAccount.user,
      pass: testAccount.pass,
    },
  });
};

export const mailService = {
  sendVerificationEmail: async (toEmail, token) => {
    const transporter = await createMailer();
    const appUrl = process.env.APP_URL || 'http://localhost:3000';
    const verifyLink = `${appUrl}/verify-email?token=${token}`;

    const mailOptions = {
      from: process.env.MAIL_FROM || 'no-reply@educourse.app',
      to: toEmail,
      subject: 'Verify your EduCourse account',
      html: `
        <h2>Verifikasi Email Anda</h2>
        <p>Klik link berikut untuk verifikasi:</p>
        <a href="${verifyLink}">${verifyLink}</a>
      `,
    };

    const info = await transporter.sendMail(mailOptions);

    // Jika pakai Ethereal, log preview URL
    if (nodemailer.getTestMessageUrl(info)) {
      console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
    }

    return info;
  }
};
```

### Auth Service - Verify Token

```javascript
verifyToken: async (token) => {
  // 1. Cari user berdasarkan verification_token
  const [rows] = await db.query(
    'SELECT * FROM users WHERE verification_token=?', 
    [token]
  );
  const user = rows[0];
  
  // 2. Jika tidak ada, return false
  if (!user) return false;

  // 3. Update is_verified menjadi 1, set token null
  await db.query(
    'UPDATE users SET is_verified=1, verification_token=NULL WHERE id=?', 
    [user.id]
  );
  
  return true;
}
```

### Route Layer

```javascript
router.get('/verify-email', async (req, res) => {
  try {
    const token = req.query.token;
    if (!token) {
      return res.status(400).json({ message: 'Token is required' });
    }

    const ok = await authService.verifyToken(token);
    if (!ok) {
      return res.status(400).json({ message: 'Invalid Verification Token' });
    }

    res.json({ message: 'Email Verified Successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
```

**Testing:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/verify-email?token=abc-123-xyz"
```

---

## 7️⃣ Upload Image (POST /upload)

### Upload Route (`routes/uploadRoutes.js`)

```javascript
import express from 'express';
import multer from 'multer';
import path from 'path';

const router = express.Router();

// 1. Konfigurasi Multer Storage
const storage = multer.diskStorage({
  // Destination folder
  destination: (req, file, cb) => {
    cb(null, path.join(process.cwd(), 'upload'));
  },
  // Filename dengan timestamp
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const name = `${Date.now()}-${Math.round(Math.random()*1e9)}${ext}`;
    cb(null, name);
  }
});

// 2. Initialize multer
const upload = multer({ storage });

// 3. Route upload dengan middleware multer
router.post('/upload', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'File is required' });
  }
  
  res.json({ 
    message: 'File uploaded', 
    file: req.file.filename, 
    path: `/upload/${req.file.filename}` 
  });
});

export default router;
```

### Server.js - Serve Static Files

```javascript
import path from 'path';

// Serve uploaded files statically
app.use('/upload', express.static(path.join(process.cwd(), 'upload')));
```

**Testing:**
```powershell
# Upload file
$filePath = "C:\path\to\image.jpg"
$formData = @{
    file = Get-Item -Path $filePath
}

Invoke-RestMethod -Uri "http://localhost:3000/upload" -Method POST -Form $formData
```

**Mengakses file:**
```
http://localhost:3000/upload/1699999999999-123456789.jpg
```

---

## 📊 Rekap Endpoint EduCourse App

| Endpoint | Method | Deskripsi | Auth Required |
|----------|--------|-----------|---------------|
| `/register` | POST | Registrasi user baru | ❌ |
| `/login` | POST | Login dan dapat JWT token | ❌ |
| `/verify-email` | GET | Verifikasi email dengan token | ❌ |
| `/course` | GET | List courses (filter, sort, search) | ✅ Optional |
| `/course/:id` | GET | Detail course by ID | ✅ Optional |
| `/course` | POST | Create new course | ✅ Optional |
| `/course/:id` | PATCH | Update course | ✅ Optional |
| `/course/:id` | DELETE | Delete course | ✅ Optional |
| `/upload` | POST | Upload image file | ✅ Optional |

---

## 🔧 Environment Variables

File `.env`:
```env
# Database
DB_HOST=localhost
DB_USER=root
DB_PASS=
DB_PORT=3306
DB_NAME=educourse_db

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production

# Email (opsional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
MAIL_FROM=no-reply@educourse.app

# App
APP_URL=http://localhost:3000
PORT=3000
```

---

## 🚀 Cara Menjalankan

1. **Install Dependencies:**
```bash
npm install
```

2. **Setup Database:**
```sql
-- Jalankan di MySQL
CREATE DATABASE educourse_db;
USE educourse_db;

-- Jalankan database-schema.sql
-- Jalankan sample-data.sql (opsional)
```

3. **Konfigurasi .env:**
- Copy `.env.example` ke `.env`
- Sesuaikan kredensial database
- Set JWT_SECRET

4. **Jalankan Server:**
```bash
npm run dev
```

5. **Test Endpoints:**
- Lihat `API-TESTING.md` untuk contoh lengkap
- Gunakan Postman, Thunder Client, atau PowerShell

---

## 📚 Dependencies yang Digunakan

```json
{
  "bcrypt": "^6.0.0",          // Password hashing
  "jsonwebtoken": "^9.0.2",    // JWT authentication
  "nodemailer": "^7.0.10",     // Send email
  "uuid": "^13.0.0",           // Generate unique token
  "multer": "^2.0.2",          // File upload
  "express": "^5.1.0",         // Web framework
  "mysql2": "^3.15.3",         // MySQL driver
  "dotenv": "^17.2.3"          // Environment variables
}
```

---

## ✅ Checklist Implementation

- [x] Tabel `users` dengan verification_token
- [x] POST /register dengan bcrypt password hashing
- [x] POST /login dengan JWT token
- [x] Middleware authMiddleware.verifyToken
- [x] GET /course dengan filter, sort, search query params
- [x] GET /verify-email untuk verifikasi email
- [x] POST /upload dengan multer
- [x] Mail service dengan nodemailer
- [x] .env configuration untuk JWT & email
- [x] Documentation lengkap di API-TESTING.md

---

**🎉 Project sudah lengkap dan siap digunakan!**

Untuk pertanyaan atau issue, silakan cek dokumentasi di:
- `readme.md` - Panduan dasar
- `readme2.md` - Requirement lengkap
- `API-TESTING.md` - Testing guide
- `IMPLEMENTATION-GUIDE.md` - Implementation details (file ini)
