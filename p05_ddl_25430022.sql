-- p05_ddl_25430022.sql
-- DDL proyek Perpustakaan Cendekia WFR (Milestone Proyek 5)
-- Sumber: skema 3NF p04_normalisasi_25430022.md, kamus data dan AB-xx p02_kebutuhan_data_25430022.md
-- Parameter P = (22 mod 9) + 1 = 5
-- Dapat dijalankan ulang dari basis data kosong.
-- Cara menjalankan: mysql -u dev_022 -p   lalu   SOURCE C:/praktikum/basisdata-25430022/p05_ddl_25430022.sql

USE perpus_022;

-- ===== Hapus tabel dengan urutan ANAK -> INDUK =====
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ===== Tabel master =====
CREATE TABLE petugas (
  id_petugas    SMALLINT                               NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(5)                                NOT NULL,   -- contoh: PTG01
  nama_petugas  VARCHAR(100)                           NOT NULL,
  peran_petugas ENUM('kepala','sirkulasi','katalog')   NOT NULL,   -- aktor PB-01..PB-04
  PRIMARY KEY (id_petugas),
  UNIQUE KEY uq_petugas_kode (kode_petugas)                          -- AB-07: data master tunggal
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota         INT                      NOT NULL AUTO_INCREMENT,
  no_anggota         CHAR(6)                  NOT NULL,              -- format A-0123
  nim_anggota        CHAR(10)                 NOT NULL,
  nama_anggota       VARCHAR(100)             NOT NULL,
  prodi_anggota      VARCHAR(60)              NOT NULL,
  no_hp_anggota      VARCHAR(15)              NULL,                  -- data pribadi (p02 bagian 9)
  status_anggota     ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',  -- AB-02
  tgl_daftar_anggota DATE                     NOT NULL,
  PRIMARY KEY (id_anggota),
  UNIQUE KEY uq_anggota_no (no_anggota),                             -- AB-07
  UNIQUE KEY uq_anggota_nim (nim_anggota)                            -- AB-04: NIM unik
) ENGINE=InnoDB;

CREATE TABLE buku (
  id_buku       INT           NOT NULL AUTO_INCREMENT,
  kode_buku     VARCHAR(10)   NOT NULL,                              -- contoh: BK-IF-01
  judul_buku    VARCHAR(200)  NOT NULL,
  kategori_buku VARCHAR(50)   NOT NULL,
  harga_buku    DECIMAL(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (id_buku),
  UNIQUE KEY uq_buku_kode (kode_buku),
  CONSTRAINT ck_buku_harga CHECK (harga_buku >= 0)
) ENGINE=InnoDB;

CREATE TABLE eksemplar (
  id_eksemplar      INT                              NOT NULL AUTO_INCREMENT,
  no_eksemplar      VARCHAR(10)                      NOT NULL,       -- label barcode, contoh: EKS-0101
  id_buku           INT                              NOT NULL,
  kondisi_eksemplar ENUM('baik','rusak','hilang')    NOT NULL DEFAULT 'baik',
  status_eksemplar  ENUM('tersedia','dipinjam')      NOT NULL DEFAULT 'tersedia',  -- AB-08
  PRIMARY KEY (id_eksemplar),
  UNIQUE KEY uq_eksemplar_no (no_eksemplar),
  CONSTRAINT fk_eksemplar_buku FOREIGN KEY (id_buku) REFERENCES buku (id_buku)
  -- AB-03 (jumlah tersedia tidak negatif) dijaga tanpa kolom stok:
  -- jumlah tersedia = COUNT eksemplar berstatus 'tersedia', tidak mungkin negatif (keputusan p04).
) ENGINE=InnoDB;

-- ===== Tabel transaksi =====
CREATE TABLE peminjaman (
  id_peminjaman              INT      NOT NULL AUTO_INCREMENT,
  no_slip_peminjaman         CHAR(12) NOT NULL,                      -- format SL-2610-0012
  tgl_peminjaman             DATETIME NOT NULL,
  tgl_jatuh_tempo_peminjaman DATE     NOT NULL,                      -- disimpan (keputusan p04)
  id_petugas                 SMALLINT NOT NULL,
  id_anggota                 INT      NOT NULL,                      -- AB-02: peminjam wajib anggota
  PRIMARY KEY (id_peminjaman),
  UNIQUE KEY uq_peminjaman_slip (no_slip_peminjaman),                -- AB-01: nomor slip unik
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota),
  CONSTRAINT ck_peminjaman_tempo CHECK (tgl_jatuh_tempo_peminjaman >= DATE(tgl_peminjaman))
  -- AB-02 bagian "anggota berstatus aktif" melibatkan tabel lain -> tidak bisa CHECK, diselesaikan di Modul 14.
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  id_peminjaman                 INT           NOT NULL,
  id_eksemplar                  INT           NOT NULL,
  tgl_kembali_detail_peminjaman DATE          NULL,                  -- NULL = belum dikembalikan
  denda_detail_peminjaman       DECIMAL(12,2) NOT NULL DEFAULT 0,    -- disimpan (keputusan p04)
  PRIMARY KEY (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE CASCADE,
  CONSTRAINT fk_detail_eksemplar FOREIGN KEY (id_eksemplar) REFERENCES eksemplar (id_eksemplar),
  -- AB-06: denda tidak negatif
  CONSTRAINT ck_detail_denda CHECK (denda_detail_peminjaman >= 0),
  -- AB-06 berbasis P: denda = P ribu (Rp5.000) x hari terlambat, jadi selalu kelipatan 5.000
  CONSTRAINT ck_detail_denda_p CHECK (MOD(denda_detail_peminjaman, 5000) = 0),
  -- AB-06: denda hanya ada setelah buku dikembalikan (PB-03)
  CONSTRAINT ck_detail_denda_kembali CHECK (tgl_kembali_detail_peminjaman IS NOT NULL OR denda_detail_peminjaman = 0)
  -- AB-05 (maksimal P + 2 = 7 eksemplar per slip) menyangkut JUMLAH BARIS per transaksi,
  -- sehingga tidak dapat dijaga CHECK (CHECK hanya memeriksa satu baris). Ditandai untuk Modul 14.
  -- AB-01 bagian "minimal satu eksemplar per slip" juga melibatkan banyak baris -> Modul 14.
) ENGINE=InnoDB;

SHOW TABLES;
