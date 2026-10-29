-- p06_latihan_kopma_25430022.sql
-- Latihan E Modul 6. Jalankan SETELAH p05_ddl_kopma_25430022.sql dan p06_data_kopma_25430022.sql:
--   SOURCE C:/praktikum/basisdata-25430022/p06_latihan_kopma_25430022.sql

USE kopma_022;
SET SESSION sql_safe_updates = 1;   -- tetap memakai mode aman

-- ===== Latihan E.1: arsip anggota nonaktif yang mendaftar sebelum 2025 =====

-- Data pendukung: satu anggota nonaktif lama yang MASIH punya penjualan
-- (untuk membuktikan anggota seperti ini TIDAK ikut diarsipkan/dihapus)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota, tgl_daftar_anggota)
VALUES ('A-0298', '2443020298', 'Rahmat Hidayat', 'Agribisnis', 'nonaktif', '2024-02-05');
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0160', '2026-09-26 13:10:00', 2, id_anggota, 5000
FROM anggota WHERE no_anggota = 'A-0298';

-- Kondisi awal: siapa saja anggota nonaktif sebelum 2025, dan berapa notanya
SELECT a.no_anggota, a.nama_anggota, a.status_anggota, a.tgl_daftar_anggota,
       (SELECT COUNT(*) FROM penjualan p WHERE p.id_anggota = a.id_anggota) AS jumlah_nota
FROM anggota a
WHERE a.status_anggota = 'nonaktif' AND a.tgl_daftar_anggota < '2025-01-01';

-- 1) Buat tabel arsip dengan struktur yang sama persis (CREATE TABLE ... LIKE)
DROP TABLE IF EXISTS anggota_arsip;
CREATE TABLE anggota_arsip LIKE anggota;

-- 2) Salin ke arsip: nonaktif, daftar sebelum 2025, dan TIDAK punya penjualan
INSERT INTO anggota_arsip
SELECT a.* FROM anggota a
WHERE a.status_anggota = 'nonaktif'
  AND a.tgl_daftar_anggota < '2025-01-01'
  AND NOT EXISTS (SELECT 1 FROM penjualan p WHERE p.id_anggota = a.id_anggota);

-- 3) Hapus dari tabel asal hanya anggota yang sudah masuk arsip
--    "AND id_anggota > 0" diperlukan agar mode aman menerima (syarat memakai kolom kunci)
DELETE FROM anggota
WHERE id_anggota IN (SELECT id_anggota FROM anggota_arsip)
  AND id_anggota > 0;

-- Bukti
SELECT no_anggota, nama_anggota FROM anggota_arsip;                -- Hendra (tanpa nota) diarsipkan
SELECT no_anggota, nama_anggota, status_anggota FROM anggota;      -- Rahmat (punya nota) tetap ada

-- ===== Latihan E.2: harga makanan naik 5%, dibulatkan ke ratusan terdekat =====
SELECT kode_barang, nama_barang, harga_jual_barang AS harga_lama FROM barang WHERE kategori_barang = 'makanan';

UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;

SELECT kode_barang, nama_barang, harga_jual_barang AS harga_baru FROM barang WHERE kategori_barang = 'makanan';

SET SESSION sql_safe_updates = 0;
