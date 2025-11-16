-- =====================================================
-- DATABASE SETUP SCRIPT
-- Run this FIRST before starting the server
-- =====================================================

-- 1. CREATE DATABASE (if not exists)
CREATE DATABASE IF NOT EXISTS educourse_db;
USE educourse_db;

-- 2. DROP EXISTING TABLES (optional - only if you want fresh start)
-- Uncomment lines below if you want to reset everything
-- DROP TABLE IF EXISTS Review;
-- DROP TABLE IF EXISTS Pembayaran;
-- DROP TABLE IF EXISTS `Order`;
-- DROP TABLE IF EXISTS Pretest;
-- DROP TABLE IF EXISTS Material;
-- DROP TABLE IF EXISTS Modul_Kelas;
-- DROP TABLE IF EXISTS Kelas_Saya;
-- DROP TABLE IF EXISTS Produk_Kelas;
-- DROP TABLE IF EXISTS Tutor;
-- DROP TABLE IF EXISTS Kategori_Kelas;
-- DROP TABLE IF EXISTS users;
-- DROP TABLE IF EXISTS User;

-- 3. CREATE NEW TABLES
-- Table User (old - for compatibility)
CREATE TABLE IF NOT EXISTS `User` (
  `user_id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `email` varchar(255),
  `password` varchar(255),
  `role` varchar(255)
);

-- ⭐ NEW TABLE: users (for authentication)
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

-- Table Kategori_Kelas
CREATE TABLE IF NOT EXISTS `Kategori_Kelas` (
  `kategori_id` int PRIMARY KEY AUTO_INCREMENT,
  `nama_kategori` varchar(255),
  `deskripsi` text
);

-- Table Tutor
CREATE TABLE IF NOT EXISTS `Tutor` (
  `tutor_id` int PRIMARY KEY AUTO_INCREMENT,
  `nama` varchar(255),
  `email` varchar(255),
  `keahlian` varchar(255),
  `bio` text
);

-- Table Produk_Kelas
CREATE TABLE IF NOT EXISTS `Produk_Kelas` (
  `kelas_id` int PRIMARY KEY AUTO_INCREMENT,
  `nama_kelas` varchar(255),
  `deskripsi` text,
  `harga` decimal,
  `kategori_id` int,
  `tutor_id` int
);

-- Table Kelas_Saya
CREATE TABLE IF NOT EXISTS `Kelas_Saya` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `kelas_id` int,
  `progress` int,
  `status` varchar(255)
);

-- Table Modul_Kelas
CREATE TABLE IF NOT EXISTS `Modul_Kelas` (
  `modul_id` int PRIMARY KEY AUTO_INCREMENT,
  `kelas_id` int,
  `judul_modul` varchar(255),
  `urutan` int
);

-- Table Material
CREATE TABLE IF NOT EXISTS `Material` (
  `material_id` int PRIMARY KEY AUTO_INCREMENT,
  `modul_id` int,
  `jenis` varchar(255),
  `konten` text
);

-- Table Pretest
CREATE TABLE IF NOT EXISTS `Pretest` (
  `pretest_id` int PRIMARY KEY AUTO_INCREMENT,
  `kelas_id` int,
  `pertanyaan` text,
  `jawaban_benar` text
);

-- Table Order
CREATE TABLE IF NOT EXISTS `Order` (
  `order_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `kelas_id` int,
  `tanggal_order` datetime,
  `total_harga` decimal,
  `status` varchar(255)
);

-- Table Pembayaran
CREATE TABLE IF NOT EXISTS `Pembayaran` (
  `pembayaran_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `order_id` int,
  `tanggal` datetime,
  `jumlah` decimal,
  `status` varchar(255)
);

-- Table Review
CREATE TABLE IF NOT EXISTS `Review` (
  `review_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `kelas_id` int,
  `rating` int,
  `komentar` text,
  `tanggal` datetime
);

-- 4. ADD FOREIGN KEYS
-- Note: If foreign keys already exist, you may get errors. That's OK - skip them.
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

-- 5. VERIFY TABLES
SELECT 'Database setup complete!' AS Status;
SHOW TABLES;

-- 6. CHECK users table structure
DESC users;
