# Dokumentasi DDL Proyek Perpustakaan Cendekia WFR - 25430022

**Berkas:** `p05_ddl_25430022.sql` (DDL), `p05_uji_constraint_25430022.sql` (bukti constraint), `p05_erd_fisik_25430022.drawio` / `.png` (ERD fisik)
**Basis data:** `perpus_022` · **Akun:** `dev_022` · **Parameter P:** 5

## 1. Pemetaan Kamus Data ke Tipe Data MariaDB

| Tabel | Kolom | Tipe | Alasan |
|---|---|---|---|
| anggota | id_anggota | INT AUTO_INCREMENT | Kunci pengganti; jumlah anggota bisa melebihi batas SMALLINT dalam 5 tahun retensi |
| anggota | no_anggota | CHAR(6) | Format tetap A-0123 (selalu 6 karakter) |
| anggota | nim_anggota | CHAR(10) | Selalu 10 digit; kode, bukan angka untuk dihitung, jadi tidak memakai INT |
| anggota | nama_anggota | VARCHAR(100) | Panjang nama bervariasi |
| anggota | prodi_anggota | VARCHAR(60) | Nama prodi bervariasi; tidak ENUM agar prodi baru tidak perlu ALTER TABLE |
| anggota | no_hp_anggota | VARCHAR(15) NULL | Disimpan sebagai teks agar angka 0 di depan tidak hilang; boleh kosong; data pribadi |
| anggota | status_anggota | ENUM('aktif','nonaktif') | Nilai terbatas dan diketahui (AB-02) |
| anggota | tgl_daftar_anggota | DATE | Cukup tanggal |
| petugas | id_petugas | SMALLINT AUTO_INCREMENT | Jumlah petugas kecil (sesuai kamus data p02) |
| petugas | kode_petugas | CHAR(5) | Kode singkat tetap, contoh PTG01 |
| petugas | peran_petugas | ENUM('kepala','sirkulasi','katalog') | Sesuai tiga aktor PB-01 sampai PB-04 |
| buku | kode_buku | VARCHAR(10) | Format BK-IF-01, panjang dapat berbeda per kategori |
| buku | judul_buku | VARCHAR(200) | Judul buku bisa panjang |
| buku | kategori_buku | VARCHAR(50) | Kategori bisa bertambah; tidak ENUM |
| buku | harga_buku | DECIMAL(12,2) | Uang harus tepat; FLOAT menimbulkan galat pembulatan |
| eksemplar | no_eksemplar | VARCHAR(10) | Label barcode, contoh EKS-0101 |
| eksemplar | kondisi_eksemplar | ENUM('baik','rusak','hilang') | Nilai terbatas |
| eksemplar | status_eksemplar | ENUM('tersedia','dipinjam') | AB-08; dasar menghitung jumlah tersedia (AB-03) |
| peminjaman | no_slip_peminjaman | CHAR(12) | Format tetap SL-2610-0012 (12 karakter) |
| peminjaman | tgl_peminjaman | DATETIME | Perlu tanggal dan jam (kamus data; KI-01 harian) |
| peminjaman | tgl_jatuh_tempo_peminjaman | DATE | Batas kembali cukup tanggal; disimpan (keputusan p04) |
| detail_peminjaman | tgl_kembali_detail_peminjaman | DATE NULL | NULL berarti buku belum dikembalikan (KI-04) |
| detail_peminjaman | denda_detail_peminjaman | DECIMAL(12,2) | Uang; disimpan sebagai potret historis (keputusan p04) |

Semua kolom kunci tamu bertipe **sama persis** dengan kolom induknya (`id_petugas` SMALLINT, kolom `id_*` lain INT), agar tidak terjadi ERROR 1005 errno 150.

## 2. Pemetaan Constraint ke Aturan Bisnis

| Constraint | Tabel | Aturan bisnis | Bukti (p05_uji_constraint) |
|---|---|---|---|
| uq_peminjaman_slip | peminjaman | AB-01 nomor slip unik | Uji 3, ERROR 1062 |
| fk_peminjaman_anggota (NOT NULL) | peminjaman | AB-02 peminjam wajib anggota; AB-07 data master tunggal | Uji 1, ERROR 1452 |
| uq_anggota_nim | anggota | AB-04 NIM unik | Uji 2, ERROR 1062 |
| ck_detail_denda | detail_peminjaman | AB-06 denda tidak negatif | - |
| ck_detail_denda_p | detail_peminjaman | AB-06 berbasis P: denda Rp5.000 × hari, jadi kelipatan 5.000 | Uji 5, ERROR 4025 |
| ck_detail_denda_kembali | detail_peminjaman | AB-06 denda hanya saat pengembalian (PB-03) | Uji 6, ERROR 4025 |
| ck_peminjaman_tempo | peminjaman | Jatuh tempo tidak boleh sebelum tanggal pinjam | Uji 4, ERROR 4025 |
| status_eksemplar ENUM | eksemplar | AB-08 status hanya tersedia/dipinjam | - |
| uq_petugas_kode, uq_anggota_no, fk_* | semua | AB-07 nama merujuk ke data master tunggal | - |
| fk_detail_peminjaman ON DELETE CASCADE | detail_peminjaman | Slip yang dibatalkan ikut menghapus rinciannya | - |

## 3. Aturan yang Tidak Dapat Dijaga Constraint (ditandai untuk Modul 14)

| Aturan | Alasan |
|---|---|
| AB-05 maksimal P + 2 = 7 eksemplar per slip | Menyangkut **jumlah baris** detail per slip; CHECK hanya memeriksa satu baris |
| AB-01 minimal satu eksemplar per slip | Menyangkut keberadaan baris di tabel lain |
| AB-02 anggota harus berstatus **aktif** saat meminjam | Memerlukan pembacaan tabel anggota; CHECK tidak boleh merujuk tabel lain |
| AB-08 status eksemplar berubah otomatis | Perlu dikerjakan bersama transaksi peminjaman/pengembalian |
| AB-03 jumlah tersedia tidak negatif | Terpenuhi oleh desain: tidak ada kolom stok, jumlah dihitung dari status_eksemplar |

## 4. Perbandingan phpMyAdmin Designer dengan ERD Fisik

> Isi kolom "Designer" sesuai yang Anda lihat sendiri di layar.

| Unsur | ERD fisik (p05_erd_fisik) | Designer phpMyAdmin | Sama? |
|---|---|---|---|
| Jumlah tabel | 6 | 6 | ✔ |
| Nama dan tipe kolom | tercantum | tercantum | ✔ |
| Kunci primer dan kunci tamu | label PK, FK, PK,FK | ikon kunci dan garis relasi | ✔ (beda tampilan) |
| Kardinalitas | 1, 0..N, 1..N | tidak ada | ✘ |
| CHECK (denda kelipatan 5.000, dll.) | tercantum | tidak tampil | ✘ |
| UNIQUE, AUTO_INCREMENT, DEFAULT | tercantum | tidak tampil | ✘ |
| Tanda data pribadi | ada pada no_hp_anggota | tidak ada | ✘ |
| Aksi ON DELETE CASCADE | tercantum | tidak tampil | ✘ |
