1. Entitas & Tabel User

Tambah entitas User di ERD untuk menyimpan data pengguna.

Atribut:

fullname

username

password

email

Buat tabel users di database sesuai entitas di atas.

2. Register User (POST /register)

Install bcrypt untuk enkripsi password.

Buat service/controller register yang:

Menerima payload:

{
  "fullname": "",
  "username": "",
  "password": "",
  "email": ""
}


Enkripsi password dengan bcrypt.hash.

Simpan user ke DB dengan perintah INSERT (password sudah di-hash).

Endpoint: POST /register → menambah user ke database.

3. Login & JWT (POST /login)

Install jsonwebtoken untuk membuat token.

Di controller login:

Cari user berdasarkan email.

Jika user tidak ditemukan → kirim response error (HTTP status sesuai) dengan pesan email/password salah.

Kalau user ada → cocokkan password:

Gunakan bcrypt.compare(plainPassword, hashedPassword).

Jika tidak cocok → kirim response error (HTTP status sesuai) dengan pesan email/password salah.

Jika email & password cocok:

Buat JWT token dengan jwt.sign(payload, secretKey).

Kembalikan response sukses berisi token.

Payload login:

{
  "email": "",
  "password": ""
}

4. Middleware Auth (JWT)

Buat auth middleware / service untuk memeriksa token di setiap request yang butuh autentikasi.

Ambil token dari header:

req.headers.authorization

Validasi token:

Gunakan jwt.verify(token, secretKey) (secretKey sama dengan saat sign token).

Jika token tidak valid / tidak ada:

Kirim response dengan HTTP status error dan pesan autentikasi gagal.

Jika token valid:

Panggil next() untuk meneruskan ke controller.

Contoh penggunaan di route:

router.get('/courses', authMiddleware.verifyToken, courseController.getList);


Jadi setiap request ke /courses akan dicek token dulu sebelum ke controller.

5. Query Params: Filter, Sort, Search (GET /course)

Tujuannya: endpoint GET data (misal kursus) bisa:

Filter data

Sort (urutkan)

Search (pencarian)

Konsep Umum

Query params diambil dari req.query.

Dipakai untuk:

Filter → WHERE

Sort → ORDER BY

Search → WHERE ... LIKE

Implementasi:

Filtering

Ambil nilai filter dari req.query (misal topic).

Bangun query dengan WHERE topic = ?.

Sorting

Ambil sortBy dari req.query.

Bangun query dengan ORDER BY sortBy.

Search

Ambil search dari req.query.

Gunakan WHERE field LIKE '%search%'.

Endpoint: GET /course

Contoh params:

{
  "topic": "backend",
  "sortBy": "created_at",
  "search": "javascript"
}

6. Send Email Verifikasi (GET /verify-email)

Digunakan setelah user register untuk verifikasi akun.

Langkah:

Install:

nodemailer → kirim email.

uuid → generate token verifikasi unik.

Tambah field token di tabel users (misal verification_token).

Di service register:

Generate token dengan uuid.

Simpan bersama data user (INSERT dengan field token).

Simpan token ke DB bersama user.

Buat function sendMail:

Kirim email ke user dengan token verifikasi (bisa sebagai link, misal: /verify-email?token=...).

Buat endpoint baru GET /verify-email:

Terima token (dari query atau body).

Cari token di database.

Jika tidak ditemukan → kirim response "Invalid Verification Token".

Jika ditemukan → update status user (misal is_verified = true) dan kirim "Email Verified Successfully".

Payload:

{
  "token": ""
}

7. Upload Image (POST /upload)

Tambah fitur unggah gambar menggunakan multer.

Langkah:

Install multer.

Buat folder upload di root project → sebagai destination file.

Buat service konfigurasi multer:

Set storage & destination ke folder upload.

Middleware ini menangani req.file.

Buat route:

POST /upload

Terima payload file (misal field file).

Pakai middleware multer di route itu.

Contoh payload:

Form-data: file: <image>

8. Rekap Endpoint EduCourse App

Dari tabel contoh:

POST /register

Menambah user ke database (dengan password di-hash + generate token verifikasi).

POST /login

Login dengan email & password.

Menghasilkan JWT token.

GET /verify-email

Verifikasi email menggunakan token.

Response error: "Invalid Verification Token" bila token salah.

Response sukses: "Email Verified Successfully".

GET /course

Mengambil data dengan dukungan filter, sort, dan search via query params.

POST /upload

Upload gambar menggunakan multer.

9. Kaitan dengan Repo GitHub

Repo referensi:
🔗 https://github.com/fahmi277/mission-intermediate-BE-2A

Repo itu bisa kamu jadikan:

Base project (struktur folder, koneksi DB, dll).

Lalu kamu tambahkan:

Model/User + field token

Endpoint /register, /login, /verify-email, /course, /upload

Middleware JWT

Service email dengan nodemailer

Service multer untuk upload