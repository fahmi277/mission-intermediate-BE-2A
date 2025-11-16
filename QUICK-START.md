# 🚀 Quick Start Guide - EduCourse Backend

Panduan cepat untuk menjalankan project EduCourse Backend.

---

## ⚡ Setup Cepat (5 Menit)

### 1. Install Dependencies
```bash
npm install
```

### 2. Setup Database
Jalankan SQL berikut di MySQL:

```sql
CREATE DATABASE educourse_db;
USE educourse_db;
```

Kemudian jalankan file:
1. `database-schema.sql` - Membuat tabel
2. `sample-data.sql` - Insert data sample (opsional)

### 3. Konfigurasi Environment
File `.env` sudah siap, pastikan kredensial database sesuai:

```env
DB_HOST=localhost
DB_USER=root
DB_PASS=
DB_NAME=educourse_db
```

### 4. Jalankan Server
```bash
npm run dev
```

Server running di: **http://localhost:3000**

---

## 🧪 Test Cepat

### Test 1: Register User
```powershell
$body = @{
    fullname = "Test User"
    username = "testuser"
    password = "password123"
    email = "test@example.com"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/register" -Method POST -Body $body -ContentType "application/json"
```

### Test 2: Login
```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/login" -Method POST -Body $body -ContentType "application/json"
```

### Test 3: Get Courses
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/course" -Method GET
```

---

## 📚 Endpoint Utama

| Endpoint | Method | Fungsi |
|----------|--------|--------|
| `/register` | POST | Daftar user baru |
| `/login` | POST | Login & dapat token |
| `/verify-email?token=xxx` | GET | Verifikasi email |
| `/course` | GET | List courses (bisa filter/sort/search) |
| `/course/:id` | GET | Detail course |
| `/course` | POST | Tambah course |
| `/course/:id` | PATCH | Update course |
| `/course/:id` | DELETE | Hapus course |
| `/upload` | POST | Upload gambar |

---

## 📖 Dokumentasi Lengkap

- **`readme.md`** - Panduan dasar project
- **`readme2.md`** - Requirement lengkap fitur
- **`API-TESTING.md`** - Cara testing semua endpoint dengan contoh PowerShell
- **`IMPLEMENTATION-GUIDE.md`** - Penjelasan detail implementasi setiap fitur

---

## 🔧 Troubleshooting

### Error: Cannot connect to database
- Pastikan MySQL sudah running
- Cek kredensial di file `.env`
- Pastikan database `educourse_db` sudah dibuat

### Error: Port 3000 already in use
- Ubah PORT di `.env`
- Atau matikan aplikasi yang menggunakan port 3000

### Error: Missing dependencies
```bash
npm install
```

### Error: Cannot find module
- Pastikan `"type": "module"` ada di `package.json`
- Gunakan `.js` extension di semua import

---

## 🎯 Fitur yang Sudah Diimplementasikan

✅ **Authentication & Authorization**
- Register dengan bcrypt password hashing
- Login dengan JWT token
- Email verification dengan nodemailer
- JWT middleware untuk protected routes

✅ **Course Management**
- CRUD operations (Create, Read, Update, Delete)
- Filter by kategori_id
- Sort by field (nama_kelas, harga, dll)
- Search di nama_kelas dan deskripsi

✅ **File Upload**
- Upload image dengan multer
- Store di folder `upload/`
- Serve static files

✅ **Database**
- MySQL dengan raw queries (tanpa ORM)
- Relasi antar tabel dengan foreign keys
- Sample data untuk testing

---

## 🚀 Next Steps

1. **Tambah Validation** - Validasi input lebih ketat (email format, password strength)
2. **Error Handling** - Global error handler
3. **Logging** - Add morgan atau winston
4. **Rate Limiting** - Prevent abuse
5. **CORS** - Configure untuk frontend
6. **Testing** - Unit test & integration test
7. **Deployment** - Deploy ke production server

---

## 📞 Support

Jika ada pertanyaan atau masalah:
1. Cek `API-TESTING.md` untuk contoh testing
2. Cek `IMPLEMENTATION-GUIDE.md` untuk detail implementasi
3. Cek console log untuk error details
4. Pastikan semua dependencies terinstall

---

**Happy Coding! 🎉**
