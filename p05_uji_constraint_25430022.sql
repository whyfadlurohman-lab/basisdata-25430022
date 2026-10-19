-- p05_uji_constraint_25430022.sql
-- Bukti constraint proyek bekerja. Jalankan SETELAH p05_ddl_25430022.sql, dari klien mysql:
--   SOURCE C:/praktikum/basisdata-25430022/p05_uji_constraint_25430022.sql
-- Baris bertanda "harus DITOLAK" MEMANG harus menghasilkan ERROR.

USE perpus_022;

-- Data induk secukupnya (harus BERHASIL)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('PTG01', 'Sari Sirkulasi', 'sirkulasi'),
  ('PTG02', 'Dodi Katalog', 'katalog');
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota) VALUES
  ('A-0123', '2543000123', 'Rian Pratama', 'Ilmu Komputer', '2026-09-01');
INSERT INTO buku (kode_buku, judul_buku, kategori_buku, harga_buku) VALUES
  ('BK-IF-01', 'Algoritma Pemrograman', 'Teknologi', 85000);
INSERT INTO eksemplar (no_eksemplar, id_buku) VALUES ('EKS-0101', 1), ('EKS-0102', 1);
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0012', '2026-10-10 09:30:00', '2026-10-17', 1, 1);

-- Uji 1 (FK): anggota 99 tidak ada -> harus DITOLAK (ERROR 1452), AB-07
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0013', NOW(), CURDATE() + INTERVAL 7 DAY, 1, 99);

-- Uji 2 (UNIQUE): NIM kembar -> harus DITOLAK (ERROR 1062), AB-04
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota)
VALUES ('A-0124', '2543000123', 'Duplikat NIM', 'Ilmu Komputer', '2026-09-02');

-- Uji 3 (UNIQUE): nomor slip kembar -> harus DITOLAK (ERROR 1062), AB-01
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0012', NOW(), CURDATE() + INTERVAL 7 DAY, 1, 1);

-- Uji 4 (CHECK): jatuh tempo sebelum tanggal pinjam -> harus DITOLAK (ERROR 4025)
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0014', '2026-10-10 09:30:00', '2026-10-01', 1, 1);

-- Uji 5 (CHECK berbasis P): denda bukan kelipatan Rp5.000 -> harus DITOLAK (ERROR 4025), AB-06
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_kembali_detail_peminjaman, denda_detail_peminjaman)
VALUES (1, 1, '2026-10-19', 7500);

-- Uji 6 (CHECK): denda diisi padahal buku belum kembali -> harus DITOLAK (ERROR 4025), AB-06
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_kembali_detail_peminjaman, denda_detail_peminjaman)
VALUES (1, 1, NULL, 5000);

-- Kontrol positif: terlambat 2 hari, denda 2 x Rp5.000 -> harus BERHASIL
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_kembali_detail_peminjaman, denda_detail_peminjaman)
VALUES (1, 1, '2026-10-19', 10000);
SELECT * FROM detail_peminjaman;

SHOW CREATE TABLE detail_peminjaman;
