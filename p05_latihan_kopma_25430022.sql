-- p05_latihan_kopma_25430022.sql
-- Latihan E Modul 5. Jalankan SETELAH p05_ddl_kopma_25430022.sql dan p05_uji_constraint_kopma_25430022.sql
-- Dari dalam klien mysql:  SOURCE C:/praktikum/basisdata-25430022/p05_latihan_kopma_25430022.sql

USE kopma_022;

-- ===== Latihan E.1: CHECK stok_min_barang tidak negatif =====
ALTER TABLE barang
  ADD CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0);

-- Bukti: perintah ini harus DITOLAK (ERROR 4025)
UPDATE barang SET stok_min_barang = -3 WHERE id_barang = 1;

-- ===== Latihan E.2: ON DELETE SET NULL pada fk_penjualan_anggota =====
-- Data contoh: satu anggota dan satu nota miliknya
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota, tgl_daftar_anggota)
VALUES ('A-0022', '2543000022', 'Anggota Uji', 'Informatika', 'aktif', '2026-09-01');
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2610-0022', NOW(), 1, LAST_INSERT_ID(), 10000);

-- (a) SEBELUM diubah: menghapus anggota yang punya nota DITOLAK (ERROR 1451)
DELETE FROM anggota WHERE no_anggota = 'A-0022';

-- (b) Ubah aksi kunci tamu: hapus constraint lama, buat lagi dengan ON DELETE SET NULL
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan
  ADD CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
  REFERENCES anggota (id_anggota) ON DELETE SET NULL;

-- (c) SESUDAH diubah: anggota terhapus, nota tetap ada tetapi id_anggota menjadi NULL
DELETE FROM anggota WHERE no_anggota = 'A-0022';
SELECT no_nota_penjualan, id_anggota FROM penjualan WHERE no_nota_penjualan = 'PJ-2610-0022';

SHOW CREATE TABLE penjualan;
