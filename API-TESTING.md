# 🚀 Panduan Testing API EduCourse

## 📝 Urutan Setup dan Testing

### 1️⃣ Setup Database
```bash
# Di MySQL/phpMyAdmin, jalankan berurutan:
1. database-schema.sql    # Buat struktur tabel (termasuk tabel users)
2. sample-data.sql         # Insert data sample
```

### 2️⃣ Konfigurasi Environment
File `.env` sudah siap dengan konfigurasi:
```env
DB_HOST=localhost
DB_USER=root
DB_PASS=
DB_PORT=3306
DB_NAME=educourse_db

JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
APP_URL=http://localhost:3000
PORT=3000

# Email (opsional - gunakan Ethereal test jika kosong)
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=
MAIL_FROM=no-reply@educourse.app
```

### 3️⃣ Jalankan Server
```bash
npm run dev
```

Server akan running di: http://localhost:3000

---

## 🔐 Authentication Endpoints

### **POST /register** - Register User Baru

**Request Body:**
```json
{
  "fullname": "John Doe",
  "username": "johndoe",
  "password": "password123",
  "email": "john@example.com"
}
```

**PowerShell:**
```powershell
$body = @{
    fullname = "John Doe"
    username = "johndoe"
    password = "password123"
    email = "john@example.com"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/register" -Method POST -Body $body -ContentType "application/json"
```

**Response Success (201):**
```json
{
  "message": "User registered",
  "id": 1
}
```

**Response Error (400):**
```json
{
  "error": "Email or username already registered"
}
```

---

### **POST /login** - Login User

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**PowerShell:**
```powershell
$body = @{
    email = "john@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/login" -Method POST -Body $body -ContentType "application/json"
```

**Response Success (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response Error (401):**
```json
{
  "error": "Email or password wrong"
}
```

---

### **GET /verify-email** - Verifikasi Email

**Query Parameters:**
- `token` - Token verifikasi dari email

**PowerShell:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/verify-email?token=abc123-token-xyz" -Method GET
```

**Response Success (200):**
```json
{
  "message": "Email Verified Successfully"
}
```

**Response Error (400):**
```json
{
  "message": "Invalid Verification Token"
}
```

---

## 📚 Course Endpoints

### **GET /course** - List Semua Course (dengan Filter, Sort, Search)

**Query Parameters (opsional):**
- `kategori_id` - Filter berdasarkan kategori (contoh: `kategori_id=1`)
- `sortBy` - Urut berdasarkan field (contoh: `sortBy=harga`, `sortBy=nama_kelas`)
- `search` - Cari di nama_kelas atau deskripsi (contoh: `search=node`)

**PowerShell - Tanpa Filter:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/course" -Method GET
```

**PowerShell - Dengan Filter & Sort:**
```powershell
# Filter kategori 1, sort by harga
Invoke-RestMethod -Uri "http://localhost:3000/course?kategori_id=1&sortBy=harga" -Method GET

# Search "node"
Invoke-RestMethod -Uri "http://localhost:3000/course?search=node" -Method GET

# Kombinasi: kategori 1, search "react", sort by nama_kelas
Invoke-RestMethod -Uri "http://localhost:3000/course?kategori_id=1&search=react&sortBy=nama_kelas" -Method GET
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
  }
]
```

---

### **GET /course/:id** - Detail Course by ID

```powershell
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

### **POST /course** - Tambah Course Baru

**Request Body:**
```json
{
  "nama_kelas": "Vue.js Essential",
  "deskripsi": "Belajar Vue.js framework",
  "harga": 280000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

**PowerShell:**
```powershell
$body = @{
    nama_kelas = "Vue.js Essential"
    deskripsi = "Belajar Vue.js framework"
    harga = 280000
    kategori_id = 1
    tutor_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/course" -Method POST -Body $body -ContentType "application/json"
```

**Response:**
```json
{
  "message": "Course created"
}
```

---

### **PATCH /course/:id** - Update Course

**Request Body:**
```json
{
  "nama_kelas": "Node.js Advanced",
  "deskripsi": "Updated description",
  "harga": 350000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

**PowerShell:**
```powershell
$body = @{
    nama_kelas = "Node.js Advanced"
    deskripsi = "Updated description"
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

### **DELETE /course/:id** - Hapus Course

**PowerShell:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/course/5" -Method DELETE
```

**Response:**
```json
{
  "message": "Course deleted"
}
```

---

## 📤 Upload Endpoint

### **POST /upload** - Upload Image

**Form Data:**
- `file` - File image yang akan diupload

**PowerShell:**
```powershell
# Upload file menggunakan PowerShell
$filePath = "C:\path\to\your\image.jpg"
$uri = "http://localhost:3000/upload"

# Method 1: Using multipart form-data
$formData = @{
    file = Get-Item -Path $filePath
}

Invoke-RestMethod -Uri $uri -Method POST -Form $formData

# Method 2: Manual multipart (jika method 1 tidak work)
$boundary = [System.Guid]::NewGuid().ToString()
$fileName = [System.IO.Path]::GetFileName($filePath)
$fileBytes = [System.IO.File]::ReadAllBytes($filePath)

$bodyLines = @(
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"",
    "Content-Type: application/octet-stream",
    "",
    [System.Text.Encoding]::GetEncoding("iso-8859-1").GetString($fileBytes),
    "--$boundary--"
) -join "`r`n"

Invoke-RestMethod -Uri $uri -Method POST -ContentType "multipart/form-data; boundary=$boundary" -Body $bodyLines
```

**Curl (Command Prompt):**
```bash
curl -X POST http://localhost:3000/upload -F "file=@C:\path\to\image.jpg"
```

**Response Success:**
```json
{
  "message": "File uploaded",
  "file": "1699999999999-123456789.jpg",
  "path": "/upload/1699999999999-123456789.jpg"
}
```

**Response Error:**
```json
{
  "message": "File is required"
}
```

**Mengakses File yang Diupload:**
```
http://localhost:3000/upload/1699999999999-123456789.jpg
```

---

## 🔒 Menggunakan Authentication di Endpoint

Untuk endpoint yang memerlukan authentication, tambahkan header `Authorization` dengan token JWT:

**Contoh - GET Course dengan Auth:**
```powershell
$token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
$headers = @{
    "Authorization" = "Bearer $token"
}

Invoke-RestMethod -Uri "http://localhost:3000/course" -Method GET -Headers $headers
```

**Catatan:** 
- Middleware auth sudah tersedia di `middleware/authMiddleware.js`
- Untuk mengaktifkan auth di route tertentu, tambahkan `authMiddleware.verifyToken` di route
- Contoh: `router.get('/course', authMiddleware.verifyToken, async (req, res) => {...})`

---
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
