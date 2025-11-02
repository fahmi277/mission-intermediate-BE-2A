# 🚀 Panduan Testing API EduCourse

## 📝 Urutan Setup dan Testing

### 1️⃣ Setup Database
```bash
# Di MySQL/phpMyAdmin, jalankan berurutan:
1. database-schema.sql    # Buat struktur tabel
2. sample-data.sql         # Insert data sample
```

### 2️⃣ Konfigurasi Environment
File `.env` sudah siap dengan konfigurasi:
```
DB_HOST=localhost
DB_USER=root
DB_PASS=
DB_PORT=3306
DB_NAME=educourse_db
```

### 3️⃣ Jalankan Server
```bash
npm run dev
```

Server akan running di: http://localhost:3000

---

## 🎯 Testing Endpoints

### **GET - List Semua Course**
```powershell
# PowerShell
Invoke-RestMethod -Uri "http://localhost:3000/course" -Method GET

# Atau buka di browser:
http://localhost:3000/course
```

**Response:**
```json
[
  {
    "kelas_id": 1,
    "nama_kelas": "Node.js Fundamentals",
    "deskripsi": "Belajar Node.js dari dasar hingga mahir",
    "harga": 250000,
    "kategori_id": 1,
    "tutor_id": 1
  },
  ...
]
```

---

### **GET - Detail Course by ID**
```powershell
# PowerShell
Invoke-RestMethod -Uri "http://localhost:3000/course/1" -Method GET
```

**Response:**
```json
{
  "kelas_id": 1,
  "nama_kelas": "Node.js Fundamentals",
  "deskripsi": "Belajar Node.js dari dasar hingga mahir",
  "harga": 250000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

---

### **POST - Tambah Course Baru** ⭐
```powershell
# PowerShell
$body = @{
    nama_kelas = "Vue.js Essential"
    deskripsi = "Belajar Vue.js framework"
    harga = 280000
    kategori_id = 1
    tutor_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/course" -Method POST -Body $body -ContentType "application/json"
```

**Atau dengan format inline:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/course" -Method POST -ContentType "application/json" -Body '{"nama_kelas":"Vue.js Essential","deskripsi":"Belajar Vue.js framework","harga":280000,"kategori_id":1,"tutor_id":1}'
```

**Response:**
```json
{
  "message": "Course created"
}
```

---

### **PATCH - Update Course**
```powershell
# Update course dengan ID 1
$body = @{
    nama_kelas = "Node.js Advanced"
    deskripsi = "Belajar Node.js tingkat lanjut"
    harga = 350000
    kategori_id = 1
    tutor_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/course/1" -Method PATCH -Body $body -ContentType "application/json"
```

**Response:**
```json
{
  "message": "Course updated"
}
```

---

### **DELETE - Hapus Course**
```powershell
# Hapus course dengan ID 5
Invoke-RestMethod -Uri "http://localhost:3000/course/5" -Method DELETE
```

**Response:**
```json
{
  "message": "Course deleted"
}
```

---

## 🧪 Testing dengan Curl

### GET
```bash
curl http://localhost:3000/course
curl http://localhost:3000/course/1
```

### POST
```bash
curl -X POST http://localhost:3000/course ^
  -H "Content-Type: application/json" ^
  -d "{\"nama_kelas\":\"Vue.js Essential\",\"deskripsi\":\"Belajar Vue.js\",\"harga\":280000,\"kategori_id\":1,\"tutor_id\":1}"
```

### PATCH
```bash
curl -X PATCH http://localhost:3000/course/1 ^
  -H "Content-Type: application/json" ^
  -d "{\"nama_kelas\":\"Node.js Advanced\",\"deskripsi\":\"Updated\",\"harga\":350000,\"kategori_id\":1,\"tutor_id\":1}"
```

### DELETE
```bash
curl -X DELETE http://localhost:3000/course/5
```

---

## 🎨 Testing dengan Postman/Thunder Client

### 1. GET All Courses
- Method: `GET`
- URL: `http://localhost:3000/course`

### 2. GET Course by ID
- Method: `GET`
- URL: `http://localhost:3000/course/1`

### 3. POST Create Course
- Method: `POST`
- URL: `http://localhost:3000/course`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
```json
{
  "nama_kelas": "Vue.js Essential",
  "deskripsi": "Belajar Vue.js framework",
  "harga": 280000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

### 4. PATCH Update Course
- Method: `PATCH`
- URL: `http://localhost:3000/course/1`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
```json
{
  "nama_kelas": "Node.js Advanced",
  "deskripsi": "Updated description",
  "harga": 350000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

### 5. DELETE Course
- Method: `DELETE`
- URL: `http://localhost:3000/course/5`

---

## ⚠️ Catatan Penting

### Urutan Menambah Course:
1. ✅ **Harus ada Kategori** (kategori_id harus valid)
2. ✅ **Harus ada Tutor** (tutor_id harus valid)
3. ✅ Baru bisa tambah Course (Produk_Kelas)

### Field Required untuk POST Course:
- `nama_kelas` (string)
- `deskripsi` (text)
- `harga` (decimal/number)
- `kategori_id` (integer - harus exist di tabel Kategori_Kelas)
- `tutor_id` (integer - harus exist di tabel Tutor)

### Error Common:
- `Cannot add or update a child row` = kategori_id atau tutor_id tidak ada di database
- `500 Internal Server Error` = Cek log server untuk detail error
- `Connection refused` = Server belum running atau salah port

---

## 🔍 Troubleshooting

### Server tidak bisa connect ke database?
1. Pastikan MySQL sudah running
2. Cek kredensial di file `.env`
3. Pastikan database `educourse_db` sudah dibuat
4. Pastikan tabel sudah dibuat dengan `database-schema.sql`

### Foreign key constraint fails?
1. Pastikan kategori_id ada di tabel Kategori_Kelas
2. Pastikan tutor_id ada di tabel Tutor
3. Jalankan `sample-data.sql` untuk insert data master

### Port 3000 already in use?
```powershell
# Matikan process yang menggunakan port 3000
# Atau ubah PORT di .env
```

---

## 📚 Resources

- Dokumentasi lengkap: `readme.md`
- Database schema: `database-schema.sql`
- Sample data: `sample-data.sql`
- API testing: `API-TESTING.md` (file ini)
