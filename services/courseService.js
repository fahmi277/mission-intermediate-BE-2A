import { db } from '../config/db.js';

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
    await db.query(
      'INSERT INTO Produk_Kelas (nama_kelas, deskripsi, harga, kategori_id, tutor_id) VALUES (?, ?, ?, ?, ?)',
      [nama_kelas, deskripsi, harga, kategori_id, tutor_id]
    );
  },
  
  update: async (id, data) => {
    const { nama_kelas, deskripsi, harga, kategori_id, tutor_id } = data;
    await db.query(
      'UPDATE Produk_Kelas SET nama_kelas=?, deskripsi=?, harga=?, kategori_id=?, tutor_id=? WHERE kelas_id=?',
      [nama_kelas, deskripsi, harga, kategori_id, tutor_id, id]
    );
  },
  
  remove: async (id) => {
    await db.query('DELETE FROM Produk_Kelas WHERE kelas_id=?', [id]);
  }
};
