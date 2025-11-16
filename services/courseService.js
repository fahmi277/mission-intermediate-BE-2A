import { db } from '../config/db.js';

export const CourseService = {
  getAll: async (options = {}) => {
    // options: { kategori_id, sortBy, search }
    let base = 'SELECT * FROM Produk_Kelas';
    const clauses = [];
    const params = [];

    if (options.kategori_id) {
      clauses.push('kategori_id = ?');
      params.push(options.kategori_id);
    }

    if (options.search) {
      clauses.push('(nama_kelas LIKE ? OR deskripsi LIKE ?)');
      params.push(`%${options.search}%`, `%${options.search}%`);
    }

    if (clauses.length > 0) base += ' WHERE ' + clauses.join(' AND ');

    const allowedSort = ['kelas_id', 'nama_kelas', 'harga'];
    if (options.sortBy && allowedSort.includes(options.sortBy)) {
      base += ` ORDER BY ${options.sortBy}`;
    }

    const [rows] = await db.query(base, params);
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
