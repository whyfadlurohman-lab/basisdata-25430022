-- p06_data_kopma_25430022.sql
-- Data sampel Kopma (Modul 6, langkah D.1 dan D.2).
-- Jalankan SETELAH p05_ddl_kopma_25430022.sql (basis data kosong), dari klien mysql:
--   SOURCE C:/praktikum/basisdata-25430022/p05_ddl_kopma_25430022.sql
--   SOURCE C:/praktikum/basisdata-25430022/p06_data_kopma_25430022.sql

USE kopma_022;

-- ===== D.1 Data induk (INSERT banyak baris sekaligus) =====
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'), ('K02','Sari','kasir'), ('K03','Rina','kasir'),
  ('G01','Joko','gudang'), ('P01','Ketua Kopma','ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('ATK-002','Buku Tulis 58','ATK',6500,80,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24),
  ('MKN-001','Roti Cokelat','makanan',5000,6,10);

-- Anggota: minimal tiga, satu berstatus nonaktif
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457','2543010457','Budi Santoso','Ilmu Komputer','081277001122','aktif','2025-08-20'),
  ('A-0458','2543020458','Laila Kurniasih','Pendidikan Matematika','085266114455','aktif','2025-09-02'),
  ('A-0312','2443010312','Hendra Wijaya','Teknik Sipil',NULL,'nonaktif','2024-03-11'),
  ('A-0460','2543030460','Nur Aisyah','Manajemen','082178993344','aktif','2026-01-15');

-- Pemasok: minimal dua
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sumber ATK','0725-41122','Jl. Jenderal Sudirman No. 12, Metro'),
  ('UD Segar Jaya','0725-47788','Jl. AH Nasution No. 5, Metro');

-- ===== D.2 Nota contoh PJ-2609-0142 =====
-- Kasir Rina (id_petugas 3), anggota Budi Santoso (id_anggota 1)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-09-24 10:15:00', 3, 1, 30000);

-- Harga satuan DISALIN dari harga jual saat itu (AB-04) dengan INSERT ... SELECT
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 1, harga_jual_barang FROM barang WHERE kode_barang = 'MNM-001';

-- Kurangi stok sesuai qty (id_barang: 1 = ATK-001, 2 = ATK-002, 3 = MNM-001)
UPDATE barang SET stok_barang = stok_barang - 3 WHERE id_barang = 1;
UPDATE barang SET stok_barang = stok_barang - 2 WHERE id_barang = 2;
UPDATE barang SET stok_barang = stok_barang - 1 WHERE id_barang = 3;

-- ===== Nota uji kedua (pembeli umum, akan dihapus di langkah D.3) =====
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0143', '2026-09-24 10:40:00', 1, NULL, 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 2, id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'MKN-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE id_barang = 4;

-- ===== Bukti: jumlah baris per tabel =====
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;
