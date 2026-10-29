-- p06_data_25430022.sql
-- Data sampel proyek Perpustakaan Cendekia WFR (Milestone Proyek 6)
-- Parameter P = 5  ->  tabel transaksi utama (peminjaman) = 10 x P = 50 baris, tersebar pada 8 tanggal
-- Jalankan SETELAH p05_ddl_25430022.sql (basis data kosong), dari klien mysql sebagai dev_022:
--   SOURCE C:/praktikum/basisdata-25430022/p05_ddl_25430022.sql
--   SOURCE C:/praktikum/basisdata-25430022/p06_data_25430022.sql
-- Kunci tamu diisi lewat kode alami (INSERT ... SELECT ... JOIN), bukan menebak nilai id.

USE perpus_022;

-- ===== Tabel master =====
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('PTG01','Fadlan Ramadhan','kepala'),
  ('PTG02','Wulan Sari Dewi','sirkulasi'),
  ('PTG03','Yoga Prasetyo','sirkulasi'),
  ('PTG04','Melati Anggraini','sirkulasi'),
  ('PTG05','Arif Kurniawan','katalog');

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0101','2543010101','Rian Pratama','Ilmu Komputer','08342563510','aktif','2025-08-18'),
  ('A-0102','2543020102','Salsabila Putri','Sistem Informasi','08192287126','aktif','2025-08-27'),
  ('A-0103','2543030103','Dimas Aditya','Pendidikan Matematika','08834730105','aktif','2025-09-05'),
  ('A-0104','2543040104','Nadia Rahmawati','Manajemen','08297432278','aktif','2025-09-14'),
  ('A-0105','2543010105','Fikri Maulana','Akuntansi',NULL,'aktif','2025-09-23'),
  ('A-0106','2543020106','Intan Permatasari','Pendidikan Bahasa Inggris','08620691442','aktif','2025-10-02'),
  ('A-0107','2543030107','Galih Saputra','Teknik Sipil','08446140254','aktif','2025-10-11'),
  ('A-0108','2543040108','Annisa Fitriani','Agribisnis','08152876099','aktif','2025-10-20'),
  ('A-0109','2543010109','Bagas Wicaksono','Ilmu Komputer','08384087952','aktif','2025-10-29'),
  ('A-0110','2543020110','Rizka Amelia','Sistem Informasi',NULL,'aktif','2025-11-07'),
  ('A-0111','2543030111','Hafidz Alfarizi','Pendidikan Matematika','08716501551','aktif','2025-11-16'),
  ('A-0112','2543040112','Tiara Kusuma','Manajemen','08189128842','nonaktif','2024-09-02');

INSERT INTO buku (kode_buku, judul_buku, kategori_buku, harga_buku) VALUES
  ('BK-IF-01','Algoritma dan Pemrograman Dasar','Teknologi',85000),
  ('BK-IF-02','Basis Data Relasional','Teknologi',92000),
  ('BK-IF-03','Jaringan Komputer Terapan','Teknologi',78000),
  ('BK-IF-04','Pemrograman Web dengan PHP','Teknologi',88000),
  ('BK-SI-01','Analisis dan Perancangan Sistem','Teknologi',95000),
  ('BK-MT-01','Kalkulus Jilid 1','Matematika',110000),
  ('BK-MT-02','Statistika Dasar','Matematika',72000),
  ('BK-MT-03','Aljabar Linear Elementer','Matematika',98000),
  ('BK-EK-01','Pengantar Ilmu Ekonomi','Ekonomi',70000),
  ('BK-EK-02','Akuntansi Keuangan Menengah','Ekonomi',125000),
  ('BK-BI-01','English Grammar in Use','Bahasa',135000),
  ('BK-BI-02','Menulis Karya Ilmiah','Bahasa',55000),
  ('BK-AG-01','Studi Islam Kontemporer','Agama',65000),
  ('BK-SS-01','Laskar Pelangi','Sastra',79000),
  ('BK-TS-01','Mekanika Tanah','Teknologi',105000);

-- Eksemplar diisi lewat kode_buku (INSERT ... SELECT), status awal 'tersedia'
CREATE TEMPORARY TABLE stg_eksemplar (no_eksemplar VARCHAR(10), kode_buku VARCHAR(10), kondisi_eksemplar VARCHAR(10));
INSERT INTO stg_eksemplar VALUES
  ('EKS-0101','BK-IF-01','baik'),
  ('EKS-0102','BK-IF-01','baik'),
  ('EKS-0103','BK-IF-01','baik'),
  ('EKS-0201','BK-IF-02','baik'),
  ('EKS-0202','BK-IF-02','baik'),
  ('EKS-0203','BK-IF-02','baik'),
  ('EKS-0301','BK-IF-03','baik'),
  ('EKS-0302','BK-IF-03','baik'),
  ('EKS-0401','BK-IF-04','baik'),
  ('EKS-0402','BK-IF-04','baik'),
  ('EKS-0403','BK-IF-04','baik'),
  ('EKS-0501','BK-SI-01','baik'),
  ('EKS-0502','BK-SI-01','baik'),
  ('EKS-0601','BK-MT-01','baik'),
  ('EKS-0602','BK-MT-01','baik'),
  ('EKS-0603','BK-MT-01','rusak'),
  ('EKS-0701','BK-MT-02','baik'),
  ('EKS-0702','BK-MT-02','baik'),
  ('EKS-0801','BK-MT-03','baik'),
  ('EKS-0802','BK-MT-03','baik'),
  ('EKS-0901','BK-EK-01','baik'),
  ('EKS-0902','BK-EK-01','baik'),
  ('EKS-1001','BK-EK-02','baik'),
  ('EKS-1002','BK-EK-02','baik'),
  ('EKS-1101','BK-BI-01','baik'),
  ('EKS-1102','BK-BI-01','baik'),
  ('EKS-1103','BK-BI-01','rusak'),
  ('EKS-1201','BK-BI-02','baik'),
  ('EKS-1202','BK-BI-02','baik'),
  ('EKS-1301','BK-AG-01','baik'),
  ('EKS-1302','BK-AG-01','baik'),
  ('EKS-1401','BK-SS-01','baik'),
  ('EKS-1402','BK-SS-01','baik'),
  ('EKS-1501','BK-TS-01','baik'),
  ('EKS-1502','BK-TS-01','baik');
INSERT INTO eksemplar (no_eksemplar, id_buku, kondisi_eksemplar, status_eksemplar)
SELECT s.no_eksemplar, b.id_buku, s.kondisi_eksemplar, 'tersedia'
FROM stg_eksemplar s JOIN buku b ON b.kode_buku = s.kode_buku
ORDER BY s.no_eksemplar;
DROP TEMPORARY TABLE stg_eksemplar;

-- ===== Tabel transaksi: 50 slip peminjaman (10 x P), 8 tanggal berbeda =====
CREATE TEMPORARY TABLE stg_peminjaman (no_slip CHAR(12), tgl DATETIME, tempo DATE, kode_petugas CHAR(5), no_anggota CHAR(6));
INSERT INTO stg_peminjaman VALUES
  ('SL-2610-0001','2026-10-01 08:00:00','2026-10-08','PTG03','A-0105'),
  ('SL-2610-0002','2026-10-01 15:10:00','2026-10-08','PTG04','A-0106'),
  ('SL-2610-0003','2026-10-01 14:20:00','2026-10-08','PTG04','A-0111'),
  ('SL-2610-0004','2026-10-01 13:30:00','2026-10-08','PTG02','A-0107'),
  ('SL-2610-0005','2026-10-01 12:40:00','2026-10-08','PTG03','A-0109'),
  ('SL-2610-0006','2026-10-01 11:50:00','2026-10-08','PTG04','A-0107'),
  ('SL-2610-0007','2026-10-05 08:00:00','2026-10-12','PTG03','A-0109'),
  ('SL-2610-0008','2026-10-05 15:10:00','2026-10-12','PTG02','A-0107'),
  ('SL-2610-0009','2026-10-05 14:20:00','2026-10-12','PTG03','A-0107'),
  ('SL-2610-0010','2026-10-05 13:30:00','2026-10-12','PTG02','A-0101'),
  ('SL-2610-0011','2026-10-05 12:40:00','2026-10-12','PTG03','A-0110'),
  ('SL-2610-0012','2026-10-05 11:50:00','2026-10-12','PTG04','A-0103'),
  ('SL-2610-0013','2026-10-05 10:00:00','2026-10-12','PTG04','A-0111'),
  ('SL-2610-0014','2026-10-08 08:00:00','2026-10-15','PTG02','A-0102'),
  ('SL-2610-0015','2026-10-08 15:10:00','2026-10-15','PTG02','A-0102'),
  ('SL-2610-0016','2026-10-08 14:20:00','2026-10-15','PTG02','A-0111'),
  ('SL-2610-0017','2026-10-08 13:30:00','2026-10-15','PTG03','A-0104'),
  ('SL-2610-0018','2026-10-08 12:40:00','2026-10-15','PTG02','A-0101'),
  ('SL-2610-0019','2026-10-08 11:50:00','2026-10-15','PTG04','A-0108'),
  ('SL-2610-0020','2026-10-12 08:00:00','2026-10-19','PTG02','A-0104'),
  ('SL-2610-0021','2026-10-12 15:10:00','2026-10-19','PTG04','A-0103'),
  ('SL-2610-0022','2026-10-12 14:20:00','2026-10-19','PTG02','A-0105'),
  ('SL-2610-0023','2026-10-12 13:30:00','2026-10-19','PTG03','A-0103'),
  ('SL-2610-0024','2026-10-12 12:40:00','2026-10-19','PTG02','A-0111'),
  ('SL-2610-0025','2026-10-12 11:50:00','2026-10-19','PTG03','A-0109'),
  ('SL-2610-0026','2026-10-12 10:00:00','2026-10-19','PTG03','A-0109'),
  ('SL-2610-0027','2026-10-15 08:00:00','2026-10-22','PTG04','A-0107'),
  ('SL-2610-0028','2026-10-15 15:10:00','2026-10-22','PTG02','A-0102'),
  ('SL-2610-0029','2026-10-15 14:20:00','2026-10-22','PTG02','A-0110'),
  ('SL-2610-0030','2026-10-15 13:30:00','2026-10-22','PTG04','A-0102'),
  ('SL-2610-0031','2026-10-15 12:40:00','2026-10-22','PTG03','A-0106'),
  ('SL-2610-0032','2026-10-15 11:50:00','2026-10-22','PTG03','A-0111'),
  ('SL-2610-0033','2026-10-19 08:00:00','2026-10-26','PTG02','A-0105'),
  ('SL-2610-0034','2026-10-19 15:10:00','2026-10-26','PTG03','A-0103'),
  ('SL-2610-0035','2026-10-19 14:20:00','2026-10-26','PTG03','A-0101'),
  ('SL-2610-0036','2026-10-19 13:30:00','2026-10-26','PTG02','A-0103'),
  ('SL-2610-0037','2026-10-19 12:40:00','2026-10-26','PTG02','A-0107'),
  ('SL-2610-0038','2026-10-19 11:50:00','2026-10-26','PTG02','A-0106'),
  ('SL-2610-0039','2026-10-22 08:00:00','2026-10-29','PTG03','A-0103'),
  ('SL-2610-0040','2026-10-22 15:10:00','2026-10-29','PTG02','A-0111'),
  ('SL-2610-0041','2026-10-22 14:20:00','2026-10-29','PTG04','A-0105'),
  ('SL-2610-0042','2026-10-22 13:30:00','2026-10-29','PTG04','A-0106'),
  ('SL-2610-0043','2026-10-22 12:40:00','2026-10-29','PTG03','A-0111'),
  ('SL-2610-0044','2026-10-22 11:50:00','2026-10-29','PTG04','A-0111'),
  ('SL-2610-0045','2026-10-26 08:00:00','2026-11-02','PTG02','A-0110'),
  ('SL-2610-0046','2026-10-26 15:10:00','2026-11-02','PTG04','A-0110'),
  ('SL-2610-0047','2026-10-26 14:20:00','2026-11-02','PTG02','A-0103'),
  ('SL-2610-0048','2026-10-26 13:30:00','2026-11-02','PTG03','A-0104'),
  ('SL-2610-0049','2026-10-26 12:40:00','2026-11-02','PTG02','A-0105'),
  ('SL-2610-0050','2026-10-26 11:50:00','2026-11-02','PTG03','A-0103');
INSERT INTO peminjaman (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, id_petugas, id_anggota)
SELECT s.no_slip, s.tgl, s.tempo, pt.id_petugas, a.id_anggota
FROM stg_peminjaman s
JOIN petugas pt ON pt.kode_petugas = s.kode_petugas
JOIN anggota a  ON a.no_anggota  = s.no_anggota
ORDER BY s.no_slip;
DROP TEMPORARY TABLE stg_peminjaman;

-- Detail: denda = Rp5.000 x hari terlambat (AB-06), hanya bila sudah kembali; NULL = belum kembali
CREATE TEMPORARY TABLE stg_detail (no_slip CHAR(12), no_eksemplar VARCHAR(10), tgl_kembali DATE NULL, denda DECIMAL(12,2));
INSERT INTO stg_detail VALUES
  ('SL-2610-0001','EKS-0501','2026-10-09',5000),
  ('SL-2610-0002','EKS-0502','2026-10-11',15000),
  ('SL-2610-0003','EKS-1302','2026-10-05',0),
  ('SL-2610-0004','EKS-1501','2026-10-06',0),
  ('SL-2610-0005','EKS-0701','2026-10-05',0),
  ('SL-2610-0005','EKS-0602','2026-10-06',0),
  ('SL-2610-0006','EKS-1002','2026-10-08',0),
  ('SL-2610-0007','EKS-0902','2026-10-11',0),
  ('SL-2610-0007','EKS-0801','2026-10-11',0),
  ('SL-2610-0008','EKS-0301','2026-10-08',0),
  ('SL-2610-0008','EKS-1101','2026-10-09',0),
  ('SL-2610-0008','EKS-0302','2026-10-12',0),
  ('SL-2610-0009','EKS-0802','2026-10-11',0),
  ('SL-2610-0010','EKS-0401','2026-10-11',0),
  ('SL-2610-0010','EKS-0201','2026-10-09',0),
  ('SL-2610-0011','EKS-0202','2026-10-12',0),
  ('SL-2610-0012','EKS-1402','2026-10-08',0),
  ('SL-2610-0013','EKS-0203','2026-10-15',15000),
  ('SL-2610-0014','EKS-1102','2026-10-13',0),
  ('SL-2610-0015','EKS-1301','2026-10-11',0),
  ('SL-2610-0015','EKS-0702','2026-10-18',15000),
  ('SL-2610-0016','EKS-0901','2026-10-11',0),
  ('SL-2610-0016','EKS-0701','2026-10-11',0),
  ('SL-2610-0016','EKS-1401','2026-10-15',0),
  ('SL-2610-0017','EKS-1501','2026-10-17',10000),
  ('SL-2610-0018','EKS-1202','2026-10-12',0),
  ('SL-2610-0019','EKS-0602','2026-10-12',0),
  ('SL-2610-0020','EKS-0103','2026-10-21',10000),
  ('SL-2610-0021','EKS-0101','2026-10-19',0),
  ('SL-2610-0022','EKS-0102','2026-10-18',0),
  ('SL-2610-0022','EKS-0601','2026-10-21',10000),
  ('SL-2610-0022','EKS-0501','2026-10-18',0),
  ('SL-2610-0023','EKS-0201','2026-10-19',0),
  ('SL-2610-0024','EKS-1502','2026-10-17',0),
  ('SL-2610-0025','EKS-0901','2026-10-17',0),
  ('SL-2610-0026','EKS-0502','2026-10-18',0),
  ('SL-2610-0026','EKS-0902','2026-10-15',0),
  ('SL-2610-0027','EKS-0602',NULL,0),
  ('SL-2610-0027','EKS-0403',NULL,0),
  ('SL-2610-0028','EKS-1101',NULL,0),
  ('SL-2610-0028','EKS-0802','2026-10-19',0),
  ('SL-2610-0028','EKS-0202','2026-10-20',0),
  ('SL-2610-0029','EKS-1302','2026-10-22',0),
  ('SL-2610-0029','EKS-1402','2026-10-18',0),
  ('SL-2610-0030','EKS-0401','2026-10-20',0),
  ('SL-2610-0031','EKS-1201','2026-10-18',0),
  ('SL-2610-0031','EKS-1301','2026-10-25',15000),
  ('SL-2610-0032','EKS-0701','2026-10-20',0),
  ('SL-2610-0033','EKS-0302','2026-10-28',10000),
  ('SL-2610-0033','EKS-1502','2026-10-24',0),
  ('SL-2610-0033','EKS-1201','2026-10-24',0),
  ('SL-2610-0034','EKS-0801',NULL,0),
  ('SL-2610-0035','EKS-0702',NULL,0),
  ('SL-2610-0035','EKS-0203','2026-10-25',0),
  ('SL-2610-0035','EKS-0301','2026-10-23',0),
  ('SL-2610-0036','EKS-0902','2026-10-22',0),
  ('SL-2610-0036','EKS-0501','2026-10-23',0),
  ('SL-2610-0037','EKS-1402','2026-10-22',0),
  ('SL-2610-0037','EKS-1202','2026-10-25',0),
  ('SL-2610-0037','EKS-1102',NULL,0),
  ('SL-2610-0038','EKS-0102','2026-10-27',5000),
  ('SL-2610-0039','EKS-0103',NULL,0),
  ('SL-2610-0039','EKS-0202','2026-10-26',0),
  ('SL-2610-0040','EKS-0401',NULL,0),
  ('SL-2610-0041','EKS-1501',NULL,0),
  ('SL-2610-0042','EKS-1001','2026-10-27',0),
  ('SL-2610-0043','EKS-0802','2026-10-25',0),
  ('SL-2610-0043','EKS-0601','2026-10-25',0),
  ('SL-2610-0044','EKS-0701',NULL,0),
  ('SL-2610-0045','EKS-0601',NULL,0),
  ('SL-2610-0045','EKS-1002','2026-10-28',0),
  ('SL-2610-0046','EKS-1302',NULL,0),
  ('SL-2610-0047','EKS-0902',NULL,0),
  ('SL-2610-0047','EKS-1201',NULL,0),
  ('SL-2610-0048','EKS-0501',NULL,0),
  ('SL-2610-0049','EKS-0901',NULL,0),
  ('SL-2610-0050','EKS-1301',NULL,0),
  ('SL-2610-0050','EKS-1401',NULL,0),
  ('SL-2610-0050','EKS-0203',NULL,0);
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_kembali_detail_peminjaman, denda_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, s.tgl_kembali, s.denda
FROM stg_detail s
JOIN peminjaman p ON p.no_slip_peminjaman = s.no_slip
JOIN eksemplar e  ON e.no_eksemplar = s.no_eksemplar
ORDER BY s.no_slip, s.no_eksemplar;
DROP TEMPORARY TABLE stg_detail;

-- AB-08: eksemplar yang masih dipinjam (tgl_kembali NULL) berstatus 'dipinjam'
UPDATE eksemplar e
JOIN detail_peminjaman d ON d.id_eksemplar = e.id_eksemplar
SET e.status_eksemplar = 'dipinjam'
WHERE d.tgl_kembali_detail_peminjaman IS NULL;

-- ===== Bukti =====
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'eksemplar', COUNT(*) FROM eksemplar
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman;

SELECT DATE(tgl_peminjaman) AS tanggal, COUNT(*) AS jumlah_slip
FROM peminjaman GROUP BY DATE(tgl_peminjaman) ORDER BY tanggal;
