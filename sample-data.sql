-- =====================================================
-- Sample Data untuk EduCourse Database
-- Jalankan file ini setelah menjalankan database-schema.sql
-- =====================================================

USE educourse_db;

-- 1. Insert Kategori Kelas
INSERT INTO Kategori_Kelas (nama_kategori, deskripsi) VALUES 
('Programming', 'Kelas pemrograman dan pengembangan software'),
('Design', 'Kelas desain grafis dan UI/UX'),
('Data Science', 'Kelas analisis data dan machine learning'),
('Marketing', 'Kelas digital marketing dan social media');

-- 2. Insert Tutor
INSERT INTO Tutor (nama, email, keahlian, bio) VALUES 
('John Doe', 'john.doe@example.com', 'Full Stack Developer', 'Pengalaman 10 tahun di bidang web development'),
('Jane Smith', 'jane.smith@example.com', 'UI/UX Designer', 'Professional designer dengan portfolio internasional'),
('Ahmad Rizki', 'ahmad.rizki@example.com', 'Data Scientist', 'Ahli Python dan Machine Learning'),
('Sarah Johnson', 'sarah.j@example.com', 'Digital Marketing Expert', 'Spesialis SEO dan Social Media Marketing');

-- 3. Insert User (untuk testing)
INSERT INTO User (name, email, password, role) VALUES 
('Student One', 'student1@example.com', 'password123', 'student'),
('Student Two', 'student2@example.com', 'password456', 'student'),
('Admin User', 'admin@example.com', 'admin123', 'admin');

-- 4. Insert Produk Kelas (Course)
INSERT INTO Produk_Kelas (nama_kelas, deskripsi, harga, kategori_id, tutor_id) VALUES 
('Node.js Fundamentals', 'Belajar Node.js dari dasar hingga mahir', 250000, 1, 1),
('React.js Complete Course', 'Panduan lengkap membuat aplikasi web dengan React', 300000, 1, 1),
('UI/UX Design Mastery', 'Menjadi UI/UX Designer profesional', 350000, 2, 2),
('Python for Data Science', 'Analisis data menggunakan Python dan Pandas', 400000, 3, 3),
('Digital Marketing 101', 'Strategi marketing digital untuk pemula', 200000, 4, 4);

-- 5. Insert Modul Kelas (untuk course pertama: Node.js)
INSERT INTO Modul_Kelas (kelas_id, judul_modul, urutan) VALUES 
(1, 'Pengenalan Node.js', 1),
(1, 'NPM dan Package Management', 2),
(1, 'Express.js Framework', 3),
(1, 'Database Integration', 4),
(1, 'REST API Development', 5);

-- 6. Insert Material (untuk modul pertama)
INSERT INTO Material (modul_id, jenis, konten) VALUES 
(1, 'video', 'https://example.com/video/intro-nodejs.mp4'),
(1, 'pdf', 'https://example.com/files/nodejs-intro.pdf'),
(1, 'text', 'Node.js adalah runtime JavaScript yang dibangun di atas V8 engine...');

-- 7. Insert Pretest (untuk course Node.js)
INSERT INTO Pretest (kelas_id, pertanyaan, jawaban_benar) VALUES 
(1, 'Apa itu Node.js?', 'Runtime JavaScript untuk server-side'),
(1, 'Package manager default untuk Node.js?', 'NPM (Node Package Manager)');

-- 8. Insert Order (contoh pembelian)
INSERT INTO `Order` (user_id, kelas_id, tanggal_order, total_harga, status) VALUES 
(1, 1, NOW(), 250000, 'completed'),
(2, 2, NOW(), 300000, 'pending');

-- 9. Insert Pembayaran
INSERT INTO Pembayaran (user_id, order_id, tanggal, jumlah, status) VALUES 
(1, 1, NOW(), 250000, 'success');

-- 10. Insert Kelas_Saya (course yang sudah dibeli user)
INSERT INTO Kelas_Saya (user_id, kelas_id, progress, status) VALUES 
(1, 1, 0, 'active');

-- 11. Insert Review
INSERT INTO Review (user_id, kelas_id, rating, komentar, tanggal) VALUES 
(1, 1, 5, 'Course yang sangat bagus! Penjelasan mudah dipahami.', NOW());

SELECT 'Sample data berhasil ditambahkan!' as Message;
