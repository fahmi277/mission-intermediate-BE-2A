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
