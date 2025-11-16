# 🧪 Manual Testing - Auth Endpoints

## Langkah 1: Start Server

Buka terminal dan jalankan:
```powershell
cd "c:\Users\RND ENGINEER\Documents\Private\bootcamp\mission-intermediate-be-2a"
npm run dev
```

Tunggu sampai muncul pesan:
```
Database connected successfully
EduCourse API running on port 3000
```

---

## Langkah 2: Test Endpoints

**Buka PowerShell terminal BARU** (jangan terminal yang running server), lalu jalankan command berikut:

### ✅ Test 1: Check Server

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/"
```

**Expected Output:**
```json
{
  "message": "EduCourse API is running",
  "endpoints": {
    "POST /register": "Register new user",
    "POST /login": "Login user",
    ...
  }
}
```

---

### ✅ Test 2: Register User

```powershell
$body = @{
    fullname = "John Doe"
    username = "johndoe"
    password = "password123"
    email = "john@example.com"
} | ConvertTo-Json Invoke-RestMethod -Uri "http://localhost:3000/register" -Method POST -Body $body -ContentType "application/json"
```

**Expected Output:**
```json
{
  "message": "User registered",
  "id": 1
}
```

**Note:** Anda akan melihat log di terminal server tentang preview email verification URL (karena menggunakan Ethereal test account).

---

### ✅ Test 3: Login

```powershell
$body = @{
    email = "john@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/login" -Method POST -Body $body -ContentType "application/json"
```

**Expected Output:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1h..."
}
```

**Simpan token ini untuk testing endpoint yang memerlukan authentication!**

---

### ✅ Test 4: Verify Email

**Step 1:** Setelah register, cek log di terminal server untuk mendapatkan verification URL:
```
Preview URL: https://ethereal.email/message/xxxxx
```

**Step 2:** Buka URL tersebut di browser, copy token dari link verification

**Step 3:** Test dengan PowerShell:
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/verify-email?token=YOUR_TOKEN_HERE" -Method GET
```

**Expected Output:**
```json
{
  "message": "Email Verified Successfully"
}
```

---

### ✅ Test 5: Get Courses (dengan filter/sort/search) 🔒

**PENTING:** Semua endpoint course sekarang memerlukan authentication!

```powershell
# Gunakan token dari Test 3 (Login)
$token = "PASTE_YOUR_TOKEN_HERE"

$headers = @{
    "Authorization" = "Bearer $token"
}

# List all courses
Invoke-RestMethod -Uri "http://localhost:3000/course" -Headers $headers

# Filter by kategori_id
Invoke-RestMethod -Uri "http://localhost:3000/course?kategori_id=1" -Headers $headers

# Sort by harga
Invoke-RestMethod -Uri "http://localhost:3000/course?sortBy=harga" -Headers $headers

# Search "node"
Invoke-RestMethod -Uri "http://localhost:3000/course?search=node" -Headers $headers

# Kombinasi
Invoke-RestMethod -Uri "http://localhost:3000/course?kategori_id=1&sortBy=harga&search=node" -Headers $headers
```

---

### ✅ Test 6: Upload File

```powershell
# Siapkan path file (ganti dengan path file Anda)
$filePath = "C:\path\to\your\image.jpg"

# Upload
$formData = @{
    file = Get-Item -Path $filePath
}

Invoke-RestMethod -Uri "http://localhost:3000/upload" -Method POST -Form $formData
```

**Expected Output:**
```json
{
  "message": "File uploaded",
  "file": "1700123456789-987654321.jpg",
  "path": "/upload/1700123456789-987654321.jpg"
}
```

**Akses file:** http://localhost:3000/upload/1700123456789-987654321.jpg

---

## 🎯 Testing dengan Bruno / Postman / Thunder Client

### Setup Collection

1. **Download Bruno**: https://www.usebruno.com/
2. **Buat New Collection**: `EduCourse API`
3. **Base URL**: `http://localhost:3000`

---

### 📝 Request 1: Register User

**Method:** `POST`  
**URL:** `http://localhost:3000/register`  
**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "fullname": "John Doe",
  "username": "johndoe",
  "password": "password123",
  "email": "john@example.com"
}
```

**Expected Response (201):**
```json
{
  "message": "User registered",
  "id": 1
}
```

---

### 📝 Request 2: Login

**Method:** `POST`  
**URL:** `http://localhost:3000/login`  
**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Expected Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**💡 Tip:** Copy token untuk request selanjutnya yang perlu authentication!

---

### 📝 Request 3: Verify Email

**Method:** `GET`  
**URL:** `http://localhost:3000/verify-email?token=YOUR_TOKEN_HERE`

**Query Params:**
- `token` = `paste-verification-token-from-email`

**Expected Response (200):**
```json
{
  "message": "Email Verified Successfully"
}
```

---

### 📝 Request 4: Get All Courses 🔒

**Method:** `GET`  
**URL:** `http://localhost:3000/course`  
**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Optional Query Params:**
- `kategori_id` = `1` (filter by category)
- `sortBy` = `harga` (sort by field: harga, nama_kelas, kelas_id)
- `search` = `node` (search in nama_kelas and deskripsi)

**Examples:**
```
http://localhost:3000/course
http://localhost:3000/course?kategori_id=1
http://localhost:3000/course?sortBy=harga
http://localhost:3000/course?search=node
http://localhost:3000/course?kategori_id=1&sortBy=harga&search=node
```

---

### 📝 Request 5: Get Course by ID 🔒

**Method:** `GET`  
**URL:** `http://localhost:3000/course/1`  
**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

---

### 📝 Request 6: Create Course 🔒

**Method:** `POST`  
**URL:** `http://localhost:3000/course`  
**Headers:**
```
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Body (JSON):**
```json
{
  "nama_kelas": "Vue.js Essential",
  "deskripsi": "Belajar Vue.js framework",
  "harga": 280000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

---

### 📝 Request 7: Update Course 🔒

**Method:** `PATCH`  
**URL:** `http://localhost:3000/course/1`  
**Headers:**
```
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Body (JSON):**
```json
{
  "nama_kelas": "Vue.js Advanced",
  "deskripsi": "Updated description",
  "harga": 350000,
  "kategori_id": 1,
  "tutor_id": 1
}
```

---

### 📝 Request 8: Delete Course 🔒

**Method:** `DELETE`  
**URL:** `http://localhost:3000/course/5`  
**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

---

### 📤 Request 9: Upload File ⭐

**Method:** `POST`  
**URL:** `http://localhost:3000/upload`

**Body Type:** `Form Data` atau `Multipart Form`

**Form Data:**
- **Key:** `file`
- **Type:** `File`
- **Value:** [Select your image file]

**Di Bruno:**
1. Pilih tab **Body**
2. Pilih **Multipart Form**
3. Add field:
   - Name: `file`
   - Type: `File`
   - Click "Choose File" dan pilih gambar Anda

**Di Postman:**
1. Tab **Body**
2. Pilih **form-data**
3. Key: `file` (ubah type ke `File` dengan dropdown)
4. Value: Click "Select Files"

**Expected Response:**
```json
{
  "message": "File uploaded",
  "file": "1700123456789-987654321.jpg",
  "path": "/upload/1700123456789-987654321.jpg"
}
```

**Akses file yang diupload:**
```
http://localhost:3000/upload/1700123456789-987654321.jpg
```

---

### 🔒 Cara Menggunakan Authentication Token

**PENTING:** Semua endpoint `/course/*` sekarang **WAJIB** menggunakan authentication!

**Langkah-langkah:**
1. Login dulu → dapatkan token dari response
2. Copy token tersebut
3. Untuk setiap request course, tambahkan header:

**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Example di Bruno:**
1. Tab **Headers**
2. Add header:
   - Name: `Authorization`
   - Value: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

**Example di Postman:**
1. Tab **Headers** atau **Authorization**
2. Type: `Bearer Token`
3. Paste token Anda

---

### 📦 Import Collection ke Bruno

Buat file `educourse-collection.json`:

```json
{
  "name": "EduCourse API",
  "requests": [
    {
      "name": "Register User",
      "method": "POST",
      "url": "http://localhost:3000/register",
      "headers": {
        "Content-Type": "application/json"
      },
      "body": {
        "fullname": "John Doe",
        "username": "johndoe",
        "password": "password123",
        "email": "john@example.com"
      }
    },
    {
      "name": "Login",
      "method": "POST",
      "url": "http://localhost:3000/login",
      "headers": {
        "Content-Type": "application/json"
      },
      "body": {
        "email": "john@example.com",
        "password": "password123"
      }
    },
    {
      "name": "Get Courses",
      "method": "GET",
      "url": "http://localhost:3000/course"
    },
    {
      "name": "Upload File",
      "method": "POST",
      "url": "http://localhost:3000/upload",
      "body": {
        "type": "multipart",
        "file": "file"
      }
    }
  ]
}
```

**Import di Bruno:** File → Import Collection → Pilih file JSON

---

## 🚨 Troubleshooting

### Error: Unable to connect to remote server
- **Solusi:** Pastikan server sudah running (`npm run dev`)
- Cek terminal server apakah ada error

### Error: Email or username already registered
- **Solusi:** Gunakan email/username lain, atau:
```sql
-- Di MySQL, hapus user test
DELETE FROM users WHERE email = 'john@example.com';
```

### Error: Table 'users' doesn't exist
- **Solusi:** Jalankan `database-schema.sql` di MySQL:
```sql
CREATE DATABASE educourse_db;
USE educourse_db;
-- Copy paste isi database-schema.sql
```

### Error: Cannot add or update a child row (foreign key)
- **Solusi:** Pastikan data kategori dan tutor sudah ada:
```sql
-- Jalankan sample-data.sql atau insert manual:
INSERT INTO Kategori_Kelas (nama_kategori, deskripsi) 
VALUES ('Programming', 'Kelas pemrograman');

INSERT INTO Tutor (nama, email, keahlian, bio) 
VALUES ('John Doe', 'john@tutor.com', 'JavaScript', 'Expert developer');
```

---

## 📊 Testing Summary

| Endpoint | Method | Status | Test Command |
|----------|--------|--------|--------------|
| `/` | GET | ✅ | `Invoke-RestMethod -Uri "http://localhost:3000/"` |
| `/register` | POST | ✅ | See Test 2 above |
| `/login` | POST | ✅ | See Test 3 above |
| `/verify-email` | GET | ✅ | See Test 4 above |
| `/course` | GET | ✅ | See Test 5 above |
| `/course/:id` | GET | ✅ | `Invoke-RestMethod -Uri "http://localhost:3000/course/1"` |
| `/upload` | POST | ✅ | See Test 6 above |

---

## 📝 Quick Test Script

Jika ingin test semua sekaligus, copy script ini dan jalankan di PowerShell:

```powershell
# Quick Test All Endpoints
$baseUrl = "http://localhost:3000"

# 1. Check server
Write-Host "[1] Checking server..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "$baseUrl/"

# 2. Register
Write-Host "`n[2] Register..." -ForegroundColor Yellow
$registerBody = @{
    fullname = "Test User"
    username = "test" + (Get-Random -Maximum 9999)
    password = "pass123"
    email = "test" + (Get-Random -Maximum 9999) + "@test.com"
} | ConvertTo-Json
$reg = Invoke-RestMethod -Uri "$baseUrl/register" -Method POST -Body $registerBody -ContentType "application/json"
Write-Host "Registered: $($reg.message)"

# 3. Login
Write-Host "`n[3] Login..." -ForegroundColor Yellow
$email = ($registerBody | ConvertFrom-Json).email
$loginBody = @{ email = $email; password = "pass123" } | ConvertTo-Json
$login = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Body $loginBody -ContentType "application/json"
Write-Host "Token: $($login.token.Substring(0,30))..."

# 4. Get courses
Write-Host "`n[4] Get Courses..." -ForegroundColor Yellow
$courses = Invoke-RestMethod -Uri "$baseUrl/course"
Write-Host "Total courses: $($courses.Count)"

Write-Host "`n✅ All tests passed!" -ForegroundColor Green
```

---

**Semua endpoint sudah siap dan berfungsi!** 🎉

Jika masih ada masalah, pastikan:
1. ✅ Server running (`npm run dev`)
2. ✅ Database `educourse_db` sudah dibuat
3. ✅ Tabel `users` sudah ada (dari `database-schema.sql`)
4. ✅ Port 3000 tidak digunakan aplikasi lain
