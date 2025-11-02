# EduCourse App Backend

Backend sederhana untuk aplikasi **EduCourse App**, menggunakan Node.js + Express + MySQL. Panduan ini mencakup langkah-langkah konfigurasi database, implementasi query SQL (DML), pembuatan REST API endpoint, serta instalasi package yang diperlukan.

---

## ⚙️ 1. Konfigurasi Database

Sesuaikan konfigurasi database dengan kredensial yang kamu gunakan.

**File `.env`:**
```env
DB_HOST=localhost
DB_USER=root
DB_PASS=123456
DB_PORT=3306
DB_NAME=educourse_db
```

**File `config/db.js`:**
```js
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

export const db = await mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});
```

---

## 🧱 2. Struktur Database (Schema SQL)

Gunakan skema berikut untuk membuat seluruh tabel di MySQL:

```sql
CREATE TABLE `User` (
  `user_id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `email` varchar(255),
  `password` varchar(255),
  `role` varchar(255)
);

CREATE TABLE `Kategori_Kelas` (
  `kategori_id` int PRIMARY KEY AUTO_INCREMENT,
  `nama_kategori` varchar(255),
  `deskripsi` text
);

CREATE TABLE `Tutor` (
  `tutor_id` int PRIMARY KEY AUTO_INCREMENT,
  `nama` varchar(255),
  `email` varchar(255),
  `keahlian` varchar(255),
  `bio` text
);

CREATE TABLE `Produk_Kelas` (
  `kelas_id` int PRIMARY KEY AUTO_INCREMENT,
  `nama_kelas` varchar(255),
  `deskripsi` text,
  `harga` decimal,
  `kategori_id` int,
  `tutor_id` int
);

CREATE TABLE `Kelas_Saya` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `kelas_id` int,
  `progress` int,
  `status` varchar(255)
);

CREATE TABLE `Modul_Kelas` (
  `modul_id` int PRIMARY KEY AUTO_INCREMENT,
  `kelas_id` int,
  `judul_modul` varchar(255),
  `urutan` int
);

CREATE TABLE `Material` (
  `material_id` int PRIMARY KEY AUTO_INCREMENT,
  `modul_id` int,
  `jenis` varchar(255),
  `konten` text
);

CREATE TABLE `Pretest` (
  `pretest_id` int PRIMARY KEY AUTO_INCREMENT,
  `kelas_id` int,
  `pertanyaan` text,
  `jawaban_benar` text
);

CREATE TABLE `Order` (
  `order_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `kelas_id` int,
  `tanggal_order` datetime,
  `total_harga` decimal,
  `status` varchar(255)
);

CREATE TABLE `Pembayaran` (
  `pembayaran_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `order_id` int,
  `tanggal` datetime,
  `jumlah` decimal,
  `status` varchar(255)
);

CREATE TABLE `Review` (
  `review_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `kelas_id` int,
  `rating` int,
  `komentar` text,
  `tanggal` datetime
);

ALTER TABLE `Produk_Kelas` ADD FOREIGN KEY (`kategori_id`) REFERENCES `Kategori_Kelas` (`kategori_id`);
ALTER TABLE `Produk_Kelas` ADD FOREIGN KEY (`tutor_id`) REFERENCES `Tutor` (`tutor_id`);
ALTER TABLE `Kelas_Saya` ADD FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);
ALTER TABLE `Kelas_Saya` ADD FOREIGN KEY (`kelas_id`) REFERENCES `Produk_Kelas` (`kelas_id`);
ALTER TABLE `Modul_Kelas` ADD FOREIGN KEY (`kelas_id`) REFERENCES `Produk_Kelas` (`kelas_id`);
ALTER TABLE `Material` ADD FOREIGN KEY (`modul_id`) REFERENCES `Modul_Kelas` (`modul_id`);
ALTER TABLE `Pretest` ADD FOREIGN KEY (`kelas_id`) REFERENCES `Produk_Kelas` (`kelas_id`);
ALTER TABLE `Order` ADD FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);
ALTER TABLE `Order` ADD FOREIGN KEY (`kelas_id`) REFERENCES `Produk_Kelas` (`kelas_id`);
ALTER TABLE `Pembayaran` ADD FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);
ALTER TABLE `Pembayaran` ADD FOREIGN KEY (`order_id`) REFERENCES `Order` (`order_id`);
ALTER TABLE `Review` ADD FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);
ALTER TABLE `Review` ADD FOREIGN KEY (`kelas_id`) REFERENCES `Produk_Kelas` (`kelas_id`);
```

---

## 💾 3. Implementing Data Manipulation Language (DML)

Gunakan query manual (tanpa ORM) untuk operasi CRUD:

- `SELECT` → Ambil semua atau data tertentu.
- `INSERT` → Tambahkan data baru.
- `UPDATE` → Ubah data spesifik.
- `DELETE` → Hapus data tertentu.

**File `services/courseService.js`:**
```js
export const CourseService = {
  getAll: async () => {
    const [rows] = await db.query('SELECT * FROM Produk_Kelas');
    return rows;
  },
  getById: async (id) => {
    const [rows] = await db.query('SELECT * FROM Produk_Kelas WHERE kelas_id=?', [id]);
    return rows[0];
  },
  create: async (data) => {
    const { nama_kelas, deskripsi, harga, kategori_id, tutor_id } = data;
    await db.query('INSERT INTO Produk_Kelas (nama_kelas, deskripsi, harga, kategori_id, tutor_id) VALUES (?, ?, ?, ?, ?)', [nama_kelas, deskripsi, harga, kategori_id, tutor_id]);
  },
  update: async (id, data) => {
    const { nama_kelas, deskripsi, harga, kategori_id, tutor_id } = data;
    await db.query('UPDATE Produk_Kelas SET nama_kelas=?, deskripsi=?, harga=?, kategori_id=?, tutor_id=? WHERE kelas_id=?', [nama_kelas, deskripsi, harga, kategori_id, tutor_id, id]);
  },
  remove: async (id) => {
    await db.query('DELETE FROM Produk_Kelas WHERE kelas_id=?', [id]);
  }
};
```

---

## 🌐 4. Implementing REST API

**File `routes/courseRoutes.js`:**
```js
import express from 'express';
import { CourseService } from '../services/courseService.js';
const router = express.Router();

router.get('/course', async (req, res) => res.json(await CourseService.getAll()));
router.get('/course/:id', async (req, res) => res.json(await CourseService.getById(req.params.id)));
router.post('/course', async (req, res) => { await CourseService.create(req.body); res.json({ message: 'Course created' }); });
router.patch('/course/:id', async (req, res) => { await CourseService.update(req.params.id, req.body); res.json({ message: 'Course updated' }); });
router.delete('/course/:id', async (req, res) => { await CourseService.remove(req.params.id); res.json({ message: 'Course deleted' }); });

export default router;
```

**File `server.js`:**
```js
import express from 'express';
import courseRoutes from './routes/courseRoutes.js';

const app = express();
app.use(express.json());
app.use(courseRoutes);

app.listen(3000, () => console.log('EduCourse API running on port 3000'));
```

---

## 📦 5. Instalasi Package

### 🧩 Package Utama
```bash
npm install express mysql2 dotenv
```

### 🧪 Package Tambahan (opsional)
```bash
npm install nodemon --save-dev
```

### 🚀 Inisialisasi Project
```bash
mkdir educourse-app
cd educourse-app
npm init -y
npm install express mysql2 dotenv
npm install nodemon --save-dev
```
Tambahkan ke `package.json` bagian **scripts**:
```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}
```
Jalankan server:
```bash
npm run dev
```

---

## 📑 6. Daftar Endpoint

| Endpoint | Method | Keterangan |
|-----------|---------|------------|
| `/course` | **GET** | List semua kelas |
| `/course/:id` | **GET** | Menampilkan satu kelas berdasarkan ID |
| `/course/:id` | **PUT/PATCH** | Mengubah data kelas |
| `/course/:id` | **DELETE** | Menghapus kelas berdasarkan ID |
| `/course` | **POST** | Menambahkan kelas baru |

---

## 📁 7. Struktur Folder
```
educourse-app/
├── server.js
├── routes/
│   └── courseRoutes.js
├── services/
│   └── courseService.js
├── config/
│   └── db.js
├── .env
├── package.json
└── package-lock.json
```

---

## ✅ 8. Hasil Akhir
Setelah mengikuti langkah-langkah di atas, kamu akan memiliki:
- Database lengkap dengan relasi antar tabel.
- Service CRUD berbasis manual query (tanpa ORM).
- REST API modular dan ringan.
- Backend siap dikembangkan untuk EduCourse App.
