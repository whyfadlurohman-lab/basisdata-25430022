-- p06_uji_kopma_25430022.sql
-- Modul 6 langkah D.3 (ubah dan hapus dengan aman) dan D.4 (skenario uji UJ-01 s.d. UJ-09).
-- Jalankan SETELAH p05_ddl_kopma_25430022.sql dan p06_data_kopma_25430022.sql, dari klien mysql:
--   SOURCE C:/praktikum/basisdata-25430022/p06_uji_kopma_25430022.sql
-- Baris bertanda "harus DITOLAK" MEMANG harus menghasilkan ERROR.

USE kopma_022;

-- ===== D.3 langkah 5: mode aman =====
SET SESSION sql_safe_updates = 1;

-- Tanpa WHERE -> harus DITOLAK (ERROR 1175)
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;

-- Dengan syarat kolom kunci -> DITERIMA (harga ATK naik 10%)
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;
SELECT kode_barang, harga_jual_barang FROM barang;

-- Nota PJ-2609-0142 TIDAK ikut berubah (harga tersimpan di detail, AB-04)
SELECT p.no_nota_penjualan, b.kode_barang, d.harga_satuan_detail_penjualan
FROM detail_penjualan d
JOIN penjualan p ON p.id_penjualan = d.id_penjualan
JOIN barang b ON b.id_barang = d.id_barang
WHERE p.no_nota_penjualan = 'PJ-2609-0142';

-- ===== D.3 langkah 6: hapus nota uji kedua, detail ikut terhapus (ON DELETE CASCADE) =====
SELECT COUNT(*) AS detail_nota_0143_sebelum FROM detail_penjualan WHERE id_penjualan = 2;
DELETE FROM penjualan WHERE id_penjualan = 2;
SELECT COUNT(*) AS detail_nota_0143_sesudah FROM detail_penjualan WHERE id_penjualan = 2;

-- Hapus petugas yang pernah melayani penjualan (Rina, id 3) -> harus DITOLAK (ERROR 1451)
DELETE FROM petugas WHERE id_petugas = 3;

-- ===== D.4 Skenario uji =====
-- UJ-01 (positif): nota baru dengan anggota aktif -> DITERIMA (AB-02)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0150', '2026-09-25 09:05:00', 2, 2, 10000);

-- UJ-02 (positif): nota tanpa anggota (pembeli umum) -> DITERIMA, id_anggota NULL (AB-02)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0151', '2026-09-25 09:20:00', 1, NULL, 5000);
SELECT no_nota_penjualan, id_anggota FROM penjualan WHERE no_nota_penjualan IN ('PJ-2609-0150','PJ-2609-0151');

-- UJ-03 (negatif): stok diubah menjadi -5 -> harus DITOLAK (ERROR 4025, AB-03)
UPDATE barang SET stok_barang = -5 WHERE id_barang = 1;

-- UJ-04 (negatif): nomor nota yang sudah ada -> harus DITOLAK (ERROR 1062, AB-01)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', NOW(), 1, NULL, 5000);

-- UJ-05 (negatif): detail dengan qty 0 -> harus DITOLAK (ERROR 4025, ck_detail_qty)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
VALUES (3, 1, 0, 4400);

-- UJ-06 (negatif): anggota dengan NIM kembar -> harus DITOLAK (ERROR 1062, AB-05)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota, tgl_daftar_anggota)
VALUES ('A-0499', '2543010457', 'NIM Kembar', 'Ilmu Komputer', 'aktif', '2026-09-01');

-- UJ-07 (negatif): penjualan oleh petugas tidak dikenal -> harus DITOLAK (ERROR 1452, fk_penjualan_petugas)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- UJ-08 (negatif): DELETE tanpa WHERE di mode aman -> harus DITOLAK (ERROR 1175, kebijakan lab)
DELETE FROM detail_penjualan;

-- UJ-09 (uji GAGAL, Titik Analisis 3): qty melebihi stok (AB-03)
-- Harapan: ditolak. Kenyataan: DITERIMA, karena CHECK di tabel barang tidak memeriksa tabel detail.
SELECT stok_barang AS stok_pulpen FROM barang WHERE id_barang = 1;
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
VALUES (3, 1, 500, 4400);
SELECT id_penjualan, id_barang, qty_detail_penjualan FROM detail_penjualan WHERE id_penjualan = 3;

SET SESSION sql_safe_updates = 0;
