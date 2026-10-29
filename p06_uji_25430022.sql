-- p06_uji_25430022.sql
-- Skenario uji proyek Perpustakaan Cendekia WFR (Milestone Proyek 6)
-- Jalankan SETELAH p05_ddl_25430022.sql dan p06_data_25430022.sql, sebagai dev_022:
--   SOURCE C:/praktikum/basisdata-25430022/p06_uji_25430022.sql
-- Uji negatif MEMANG harus menghasilkan ERROR. UJ-13 dan UJ-14 sengaja GAGAL (utang desain Modul 14).

USE perpus_022;
SET SESSION sql_safe_updates = 1;

-- ===== Uji positif =====
-- UJ-01: peminjaman baru oleh anggota aktif (Rian Pratama) -> DITERIMA (AB-01, AB-02)
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
SELECT 'SL-2610-0101', '2026-10-27 10:00:00', '2026-11-03', pt.id_petugas, a.id_anggota
FROM petugas pt JOIN anggota a ON a.no_anggota = 'A-0101'
WHERE pt.kode_petugas = 'PTG02';
-- dua eksemplar yang sedang tersedia ikut dipinjam
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar)
SELECT p.id_peminjaman, e.id_eksemplar
FROM peminjaman p JOIN eksemplar e ON e.no_eksemplar IN ('EKS-1402','EKS-1502')
WHERE p.no_slip_peminjaman = 'SL-2610-0101';
SELECT p.no_slip_peminjaman, e.no_eksemplar, d.tgl_kembali_detail_peminjaman, d.denda_detail_peminjaman
FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar e ON e.id_eksemplar = d.id_eksemplar
WHERE p.no_slip_peminjaman = 'SL-2610-0101';

-- UJ-02: pengembalian TEPAT WAKTU, denda 0 -> DITERIMA (AB-06)
UPDATE detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar e ON e.id_eksemplar = d.id_eksemplar
SET d.tgl_kembali_detail_peminjaman = '2026-11-02', d.denda_detail_peminjaman = 0
WHERE p.no_slip_peminjaman = 'SL-2610-0101' AND e.no_eksemplar = 'EKS-1402'
  AND d.id_peminjaman > 0;

-- UJ-03: pengembalian TERLAMBAT 3 hari, denda 3 x Rp5.000 = Rp15.000 -> DITERIMA (ck_detail_denda_p)
UPDATE detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar e ON e.id_eksemplar = d.id_eksemplar
SET d.tgl_kembali_detail_peminjaman = '2026-11-06', d.denda_detail_peminjaman = 15000
WHERE p.no_slip_peminjaman = 'SL-2610-0101' AND e.no_eksemplar = 'EKS-1502'
  AND d.id_peminjaman > 0;
SELECT p.no_slip_peminjaman, e.no_eksemplar, d.tgl_kembali_detail_peminjaman, d.denda_detail_peminjaman
FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar e ON e.id_eksemplar = d.id_eksemplar
WHERE p.no_slip_peminjaman = 'SL-2610-0101';

-- ===== Uji negatif =====
-- UJ-04: nomor slip yang sudah ada -> DITOLAK, ERROR 1062 (AB-01, uq_peminjaman_slip)
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0001', '2026-10-27 11:00:00', '2026-11-03', 2, 1);

-- UJ-05: anggota baru dengan NIM yang sudah dipakai -> DITOLAK, ERROR 1062 (AB-04, uq_anggota_nim)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota)
VALUES ('A-0199', '2543010101', 'Duplikat NIM', 'Ilmu Komputer', '2026-10-27');

-- UJ-06: peminjaman oleh anggota yang tidak terdaftar (id 999) -> DITOLAK, ERROR 1452 (AB-07, fk_peminjaman_anggota)
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0102', '2026-10-27 11:10:00', '2026-11-03', 2, 999);

-- UJ-07: denda Rp7.500 (bukan kelipatan Rp5.000) -> DITOLAK, ERROR 4025 (AB-06, ck_detail_denda_p)
UPDATE detail_peminjaman SET tgl_kembali_detail_peminjaman = '2026-10-10', denda_detail_peminjaman = 7500
WHERE id_peminjaman = 1 AND id_eksemplar > 0;

-- UJ-08: denda diisi padahal buku belum kembali -> DITOLAK, ERROR 4025 (AB-06, ck_detail_denda_kembali)
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_kembali_detail_peminjaman, denda_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, NULL, 5000
FROM peminjaman p JOIN eksemplar e ON e.no_eksemplar = 'EKS-0201'
WHERE p.no_slip_peminjaman = 'SL-2610-0101';

-- UJ-09: jatuh tempo sebelum tanggal pinjam -> DITOLAK, ERROR 4025 (ck_peminjaman_tempo)
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
VALUES ('SL-2610-0103', '2026-10-27 11:20:00', '2026-10-20', 2, 1);

-- UJ-10: status eksemplar di luar daftar ENUM -> DITOLAK, ERROR 1265 (AB-08, mode ketat)
UPDATE eksemplar SET status_eksemplar = 'diperbaiki' WHERE id_eksemplar = 1;

-- UJ-11: hapus buku yang masih punya eksemplar -> DITOLAK, ERROR 1451 (fk_eksemplar_buku)
DELETE FROM buku WHERE id_buku = 1;

-- UJ-12: UPDATE tanpa WHERE di mode aman -> DITOLAK, ERROR 1175 (kebijakan lab)
UPDATE anggota SET status_anggota = 'nonaktif';

-- ===== Uji yang diperkirakan GAGAL (aturan belum dapat dijaga server) =====
-- UJ-13: satu slip berisi 8 eksemplar, melebihi batas P + 2 = 7 (AB-05)
-- Harapan: ditolak. Kenyataan: DITERIMA, karena CHECK hanya memeriksa satu baris.
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
SELECT 'SL-2610-0104', '2026-10-27 13:00:00', '2026-11-03', pt.id_petugas, a.id_anggota
FROM petugas pt JOIN anggota a ON a.no_anggota = 'A-0102'
WHERE pt.kode_petugas = 'PTG03';
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar)
SELECT p.id_peminjaman, e.id_eksemplar
FROM peminjaman p
JOIN (SELECT id_eksemplar FROM eksemplar
      WHERE status_eksemplar = 'tersedia' AND kondisi_eksemplar = 'baik'
      ORDER BY id_eksemplar LIMIT 8) e
WHERE p.no_slip_peminjaman = 'SL-2610-0104';
SELECT p.no_slip_peminjaman, COUNT(*) AS jumlah_eksemplar
FROM detail_peminjaman d JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
WHERE p.no_slip_peminjaman = 'SL-2610-0104' GROUP BY p.no_slip_peminjaman;

-- UJ-14: peminjaman oleh anggota berstatus NONAKTIF (Tiara Kusuma, A-0112) (AB-02)
-- Harapan: ditolak. Kenyataan: DITERIMA, karena CHECK tidak dapat membaca status di tabel anggota.
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
SELECT 'SL-2610-0105', '2026-10-27 13:30:00', '2026-11-03', pt.id_petugas, a.id_anggota
FROM petugas pt JOIN anggota a ON a.no_anggota = 'A-0112'
WHERE pt.kode_petugas = 'PTG04';
SELECT p.no_slip_peminjaman, a.nama_anggota, a.status_anggota
FROM peminjaman p JOIN anggota a ON a.id_anggota = p.id_anggota
WHERE p.no_slip_peminjaman = 'SL-2610-0105';

SET SESSION sql_safe_updates = 0;
