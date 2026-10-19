-- p05_uji_constraint_kopma_25430022.sql
-- Langkah D.3 dan D.4: membuktikan constraint bekerja.
-- Jalankan SETELAH p05_ddl_kopma_25430022.sql, dari dalam klien mysql:
--   SOURCE p05_uji_constraint_kopma_25430022.sql
-- Tiga uji di bawah MEMANG harus menghasilkan ERROR.

USE kopma_022;

-- Data induk secukupnya: dua petugas, dua barang (harus BERHASIL)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Rina Kasir', 'kasir'),
  ('G01', 'Dodi Gudang', 'gudang');
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang) VALUES
  ('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 50),
  ('MKN-001', 'Roti Cokelat', 'makanan', 5000, 20);

-- Uji 1: petugas 99 tidak ada -> harus DITOLAK (ERROR 1452, FK)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- Uji 2: stok negatif -> harus DITOLAK (ERROR 4025, CHECK, AB-03)
UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- Uji 3: kode barang kembar -> harus DITOLAK (ERROR 1062, UNIQUE)
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES ('ATK-001', 'Duplikat', 'ATK', 1000);

-- D.4 langkah 6: ubah struktur tanpa membuat ulang tabel, lalu batalkan
ALTER TABLE barang ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;
DESCRIBE barang;
ALTER TABLE barang DROP COLUMN tgl_kedaluwarsa;

-- Bukti struktur
SHOW CREATE TABLE penjualan;
