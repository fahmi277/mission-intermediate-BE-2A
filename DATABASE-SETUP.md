# 🗄️ Cara Setup Database - EduCourse

## 📋 Tabel Baru yang Ditambahkan

Tabel **`users`** untuk authentication dengan field:
- `id` - Primary key
- `fullname` - Nama lengkap user
- `username` - Username (unique)
- `email` - Email (unique)
- `password` - Password yang sudah di-hash
- `verification_token` - Token untuk verifikasi email
- `is_verified` - Status verifikasi (0/1)
- `created_at` - Timestamp pembuatan
- `updated_at` - Timestamp update

---

## 🚀 Cara Execute Database (3 Metode)

### **Metode 1: MySQL Command Line** ⭐ Recommended

```bash
# 1. Masuk ke MySQL
mysql -u root -p

# 2. Jalankan setup script
source C:/Users/RND ENGINEER/Documents/Private/bootcamp/mission-intermediate-be-2a/setup-database.sql

# Atau dengan perintah langsung
mysql -u root -p < "C:\Users\RND ENGINEER\Documents\Private\bootcamp\mission-intermediate-be-2a\setup-database.sql"
```

---

### **Metode 2: phpMyAdmin** 

1. Buka **phpMyAdmin** di browser: `http://localhost/phpmyadmin`

2. Klik tab **"SQL"** di menu atas

3. **Copy-paste** isi file `setup-database.sql` ke text area

4. Klik tombol **"Go"** atau **"Jalankan"**

5. Cek tab **"Structure"** untuk memastikan tabel `users` sudah ada

---

### **Metode 3: MySQL Workbench**

1. Buka **MySQL Workbench**

2. Connect ke MySQL server Anda

3. Klik menu **File → Open SQL Script**

4. Pilih file: `setup-database.sql`

5. Klik ⚡ icon **"Execute"** (atau tekan `Ctrl+Shift+Enter`)

6. Cek sidebar untuk memastikan tabel `users` ada di `educourse_db`

---

## ✅ Verifikasi Database

Setelah execute, jalankan query ini untuk verifikasi:

```sql
-- Check database
SHOW DATABASES LIKE 'educourse_db';

-- Use database
USE educourse_db;

-- Check all tables
SHOW TABLES;

-- Check users table structure
DESC users;

-- Check if users table is empty
SELECT COUNT(*) as total_users FROM users;
```

**Expected Output:**
```
+------------------+
| Tables_in_educourse_db |
+------------------+
| Kategori_Kelas   |
| Kelas_Saya       |
| Material         |
| Modul_Kelas      |
| Order            |
| Pembayaran       |
| Pretest          |
| Produk_Kelas     |
| Review           |
| Tutor            |
| User             |
| users            |  ← Tabel baru!
+------------------+
```

---

## 📝 Jika Sudah Ada Database Lama

### **Opsi A: Tambah Tabel `users` Saja**

Jika database `educourse_db` sudah ada dan Anda hanya ingin menambah tabel `users`:

```sql
USE educourse_db;

-- Hanya create tabel users
CREATE TABLE IF NOT EXISTS `users` (
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

-- Verify
DESC users;
```

### **Opsi B: Reset Database (Hati-hati! Data akan hilang)**

```sql
-- Drop database lama
DROP DATABASE IF EXISTS educourse_db;

-- Jalankan setup-database.sql dari awal
```

---

## 🎯 Quick Setup (PowerShell)

Jika MySQL sudah terinstall dan ada di PATH:

```powershell
# Navigate to project folder
cd "C:\Users\RND ENGINEER\Documents\Private\bootcamp\mission-intermediate-be-2a"

# Execute SQL (ganti password sesuai MySQL Anda)
Get-Content setup-database.sql | mysql -u root -p
```

---

## 🐛 Troubleshooting

### Error: "IF NOT EXISTS" syntax error
Gunakan MySQL versi 8.0+, atau hapus `IF NOT EXISTS` dari ALTER TABLE statements

### Error: Table already exists
Sudah oke! Tabel sudah ada, skip error ini.

### Error: Database tidak ada
```sql
CREATE DATABASE educourse_db;
```

### Error: Access denied for user 'root'
- Pastikan password MySQL benar
- Atau gunakan user MySQL lain yang punya permission

---

## 📊 Insert Sample Data (Opsional)

Setelah tabel `users` ada, Anda bisa insert sample data:

```sql
USE educourse_db;

-- Sample kategori
INSERT INTO Kategori_Kelas (nama_kategori, deskripsi) VALUES 
('Programming', 'Kelas pemrograman'),
('Design', 'Kelas desain');

-- Sample tutor
INSERT INTO Tutor (nama, email, keahlian, bio) VALUES 
('John Doe', 'john@example.com', 'JavaScript', 'Expert developer');

-- Sample course
INSERT INTO Produk_Kelas (nama_kelas, deskripsi, harga, kategori_id, tutor_id) VALUES 
('Node.js Fundamentals', 'Belajar Node.js', 250000, 1, 1);
```

Atau jalankan file: `sample-data.sql`

---

## ✅ Checklist Setup

- [ ] MySQL server running
- [ ] Database `educourse_db` dibuat
- [ ] File `setup-database.sql` di-execute
- [ ] Tabel `users` sudah ada (verify dengan `SHOW TABLES;`)
- [ ] Struktur tabel `users` benar (verify dengan `DESC users;`)
- [ ] File `.env` sudah dikonfigurasi
- [ ] Server bisa connect ke database (`npm run dev`)

---

## 🚀 Next Step

Setelah database setup:

1. **Start Server:**
```powershell
npm run dev
```

2. **Test Register:**
```powershell
$body = @{
    fullname = "John Doe"
    username = "johndoe"
    password = "password123"
    email = "john@example.com"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/register" -Method POST -Body $body -ContentType "application/json"
```

3. **Check MANUAL-TESTING.md** untuk testing lengkap

---

**Database siap digunakan!** 🎉
