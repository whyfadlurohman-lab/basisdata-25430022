# Normalisasi Proyek Perpustakaan Cendekia WFR - 25430022

**Nama:** Wahyu Fadlu Rohman  **NIM:** 25430022  **Tema:** Perpustakaan (perpus)  **Parameter P:** 5

## 1. Dokumen Sumber
Dokumen yang dijadikan titik awal UNF adalah **Slip Peminjaman Buku** (p02 bagian 3), karena satu slip memuat data kepala transaksi (slip, anggota, petugas) sekaligus daftar eksemplar yang berulang.

Contoh isi slip yang dicatat apa adanya dalam satu tabel (cara lama, sebelum dinormalisasi):

| no_slip | tgl_pinjam | jatuh_tempo | petugas | no_anggota | nama_anggota | no_eksemplar | judul_buku | tgl_kembali | denda |
|---|---|---|---|---|---|---|---|---|---|
| SL-2610-0012 | 10-10-2026 | 17-10-2026 | Sari | A-0123 | Rian Pratama | EKS-0101 | Algoritma Pemrograman | 17-10-2026 | 0 |
| SL-2610-0012 | 10-10-2026 | 17-10-2026 | Sari | A-0123 | Rian Pratama | EKS-0205 | Basis Data Lanjut | 19-10-2026 | 10000 |
| SL-2610-0019 | 12-10-2026 | 19-10-2026 | Sari | A-0123 | **Rian P.** | EKS-0310 | **Struktur Data** | - | - |
| SL-2610-0021 | 13-10-2026 | 20-10-2026 | Dodi | A-0150 | Nisa Aulia | EKS-0102 | **Algoritma Pemrog.** | - | - |

## 2. Anomali yang Ditemukan
- **Anomali ubah:** nama anggota A-0123 tertulis "Rian Pratama" dan "Rian P."; judul buku yang sama tertulis "Algoritma Pemrograman" dan "Algoritma Pemrog.". Satu fakta tersimpan di banyak baris sehingga bisa tidak konsisten (melanggar AB-07).
- **Anomali sisip:** eksemplar baru hasil pengadaan (PB-04) dan anggota baru (PB-01) tidak dapat dicatat sebelum ada slip peminjaman yang memuatnya.
- **Anomali hapus:** jika slip SL-2610-0019 dihapus, informasi bahwa eksemplar EKS-0310 adalah buku "Struktur Data" ikut hilang, karena hanya tercatat di slip tersebut.

## 3. UNF
Satu slip menyimpan grup berulang eksemplar yang dipinjam:

```
SLIP_UNF (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman,
          kode_petugas, nama_petugas, peran_petugas,
          no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota,
          { no_eksemplar, kondisi_eksemplar, status_eksemplar,
            kode_buku, judul_buku, kategori_buku, harga_buku,
            tgl_kembali_detail_peminjaman, hari_terlambat, denda_detail_peminjaman },
          total_eksemplar, total_denda)
```

## 4. 1NF
Grup berulang dihilangkan: **satu baris untuk setiap eksemplar di setiap slip**. Karena yang dipinjam adalah unit fisik (satu baris = satu eksemplar), tidak diperlukan kolom qty.

Kunci primer komposit: **(no_slip_peminjaman, no_eksemplar)**

```
SLIP_1NF (no_slip_peminjaman, no_eksemplar,
          tgl_peminjaman, tgl_jatuh_tempo_peminjaman,
          kode_petugas, nama_petugas, peran_petugas,
          no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota,
          kondisi_eksemplar, status_eksemplar,
          kode_buku, judul_buku, kategori_buku, harga_buku,
          tgl_kembali_detail_peminjaman, hari_terlambat, denda_detail_peminjaman,
          total_eksemplar, total_denda)
```

## 5. Dependensi Fungsional
Diturunkan dari aturan bisnis p02, bukan dari contoh data.

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_slip_peminjaman → tgl_peminjaman, tgl_jatuh_tempo_peminjaman, kode_petugas, no_anggota | AB-01 (nomor slip unik) |
| FD2 | kode_petugas → nama_petugas, peran_petugas | AB-07 (data master petugas tunggal) |
| FD3 | no_anggota → nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota | AB-07 (data master anggota tunggal), AB-02 |
| FD4 | nim_anggota → no_anggota | AB-04 (NIM unik) |
| FD5 | no_eksemplar → kode_buku, kondisi_eksemplar, status_eksemplar | AB-08, PB-04 (satu label = satu unit fisik) |
| FD6 | kode_buku → judul_buku, kategori_buku, harga_buku | PB-04 (katalog), AB-07 |
| FD7 | (no_slip_peminjaman, no_eksemplar) → tgl_kembali_detail_peminjaman, denda_detail_peminjaman | AB-06 (denda per eksemplar) |
| FD8 | tgl_jatuh_tempo_peminjaman, tgl_kembali_detail_peminjaman → hari_terlambat | turunan (AB-06) |
| FD9 | no_slip_peminjaman → total_eksemplar, total_denda | turunan (hitung baris detail) |

Catatan FD:
- **FD4** membuat nim_anggota menjadi kunci kandidat kedua di samping no_anggota.
- **FD7:** denda diletakkan pada kunci komposit, bukan pada no_slip saja, karena AB-06 menghitung denda **per eksemplar**. Dua eksemplar di slip yang sama bisa dikembalikan pada tanggal berbeda sehingga dendanya berbeda (contoh: EKS-0101 denda 0, EKS-0205 denda Rp10.000).
- Tidak ditulis `kode_buku → harga` sebagai dasar denda. Tarif denda berasal dari AB-06 (P = 5, yaitu Rp5.000 per hari per eksemplar), bukan dari harga buku.

## 6. 2NF
Atribut yang hanya bergantung pada **sebagian** kunci komposit dipisahkan:
- FD1 (cukup no_slip_peminjaman) → relasi **PEMINJAMAN**
- FD5 (cukup no_eksemplar) → relasi **EKSEMPLAR**
- Sisanya (FD7, bergantung pada kunci penuh) → **DETAIL_PEMINJAMAN**

```
PEMINJAMAN (no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo_peminjaman,
            kode_petugas, nama_petugas, peran_petugas,
            no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota)

EKSEMPLAR (no_eksemplar, kondisi_eksemplar, status_eksemplar,
           kode_buku, judul_buku, kategori_buku, harga_buku)

DETAIL_PEMINJAMAN (no_slip_peminjaman, no_eksemplar,
                   tgl_kembali_detail_peminjaman, denda_detail_peminjaman)
```

## 7. 3NF
Masih ada ketergantungan transitif (rantai A → B → C) di dalam satu relasi:
- PEMINJAMAN: no_slip_peminjaman → kode_petugas → nama_petugas, sehingga **PETUGAS** dipisah
- PEMINJAMAN: no_slip_peminjaman → no_anggota → nama_anggota, sehingga **ANGGOTA** dipisah
- EKSEMPLAR: no_eksemplar → kode_buku → judul_buku, sehingga **BUKU** dipisah

Hasil akhir 3NF (**tebal** = kunci primer, `*` = kunci tamu):

- ANGGOTA (**no_anggota**, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
- PETUGAS (**kode_petugas**, nama_petugas, peran_petugas)
- BUKU (**kode_buku**, judul_buku, kategori_buku, harga_buku)
- EKSEMPLAR (**no_eksemplar**, kode_buku*, kondisi_eksemplar, status_eksemplar)
- PEMINJAMAN (**no_slip_peminjaman**, tgl_peminjaman, tgl_jatuh_tempo_peminjaman, kode_petugas*, no_anggota*)
- DETAIL_PEMINJAMAN (**no_slip_peminjaman\*, no_eksemplar\***, tgl_kembali_detail_peminjaman, denda_detail_peminjaman)

Hasil ini menghilangkan ketiga anomali di bagian 2:
- nama anggota dan judul buku tersimpan satu kali (anomali ubah hilang);
- eksemplar dan anggota baru dapat dicatat tanpa slip (anomali sisip hilang);
- menghapus slip tidak menghapus data eksemplar atau buku (anomali hapus hilang).

## 8. Pemeriksaan BCNF
Syarat BCNF: setiap penentu adalah kunci kandidat.

| Tabel | Penentu | Kunci kandidat? | BCNF |
|---|---|---|---|
| anggota | no_anggota, nim_anggota | Ya, keduanya unik (AB-04, kamus data) | ✔ |
| petugas | kode_petugas | Ya | ✔ |
| buku | kode_buku | Ya | ✔ |
| eksemplar | no_eksemplar | Ya | ✔ |
| peminjaman | no_slip_peminjaman | Ya (AB-01) | ✔ |
| detail_peminjaman | (no_slip_peminjaman, no_eksemplar) | Ya | ✔ |

Semua tabel memenuhi BCNF. Penentu nim_anggota pada tabel anggota tidak melanggar BCNF karena nim_anggota adalah kunci kandidat (AB-04).

## 9. Keputusan Nilai Turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| total_eksemplar | **Dihitung** | Sama dengan jumlah baris detail per slip (COUNT). Kalau disimpan, bisa tidak cocok dengan isi detail. Batas maksimal 7 eksemplar (AB-05) diperiksa dari hitungan ini. |
| jumlah eksemplar tersedia per buku | **Dihitung** | Dihitung dari eksemplar dengan status_eksemplar = 'tersedia'. Tidak ada kolom stok, sehingga hasilnya tidak mungkin negatif (AB-03 terpenuhi otomatis). |
| hari_terlambat | **Dihitung** | Selisih tgl_kembali_detail_peminjaman dan tgl_jatuh_tempo_peminjaman. Untuk buku yang belum kembali (KI-04), dihitung terhadap tanggal hari ini saat kueri. |
| total_denda per slip | **Dihitung** | Penjumlahan denda_detail_peminjaman pada slip tersebut. |
| denda_detail_peminjaman | **Disimpan** | Diisi satu kali saat pengembalian (PB-03) dengan tarif yang berlaku saat itu (AB-06: Rp5.000 per hari per eksemplar). Denda yang sudah ditetapkan adalah **potret historis** dan tidak boleh berubah walaupun tarif kelak diubah. Ini sama dengan alasan harga satuan pada nota Kopma (AB-04 Kopma). |
| tgl_jatuh_tempo_peminjaman | **Disimpan** | Saat ini sama dengan tgl_peminjaman + 7 hari. Tetapi lama pinjam adalah kebijakan yang bisa berubah, dan batas yang sudah tertulis di slip anggota tidak boleh ikut berubah. |

Catatan: denda_detail_peminjaman tidak melanggar 3NF. Nilainya tidak ditentukan oleh kolom lain di tabel yang sama, karena juga bergantung pada tarif yang berlaku saat pengembalian. Nilai itu adalah fakta yang ditetapkan pada saat pengembalian untuk pasangan (slip, eksemplar).

## 10. Skema Relasional Akhir (dengan kunci pengganti)
Mengikuti pola skema kanonik buku: kunci pengganti `id_*` menjadi kunci primer, sedangkan kode alami menjadi kunci unik.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| anggota | id_anggota | no_anggota, nim_anggota | - |
| petugas | id_petugas | kode_petugas | - |
| buku | id_buku | kode_buku | - |
| eksemplar | id_eksemplar | no_eksemplar | id_buku |
| peminjaman | id_peminjaman | no_slip_peminjaman | id_anggota, id_petugas |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | - | id_peminjaman, id_eksemplar |

Kunci pengganti tidak menggantikan pemeriksaan normalisasi. Dependensi tetap diperiksa dengan kunci alami (bagian 5 dan 8).

## 11. Perubahan terhadap ERD dan p02
Hasil normalisasi menghasilkan 6 tabel yang sama dengan 6 entitas ERD Modul 3, jadi tidak ada entitas yang ditambah atau dihapus. Perubahan yang dicatat:

1. **denda_detail_peminjaman:** di ERD Modul 3 ditandai sebagai atribut turunan. Sekarang diputuskan **disimpan** (bagian 9), jadi tanda "turunan" pada ERD dihapus.
2. **hari_terlambat:** ditegaskan sebagai nilai turunan yang tidak disimpan. Cara hitungnya dicatat di legenda ERD sesuai masukan tinjauan klien Modul 3.
3. **tgl_kembali_detail_peminjaman** ditambahkan ke kamus data p02 bagian 8.
4. **Matriks CRUD p02:** PB-03 terhadap Detail Peminjaman diubah dari R menjadi **U**, karena pengembalian mengisi tgl_kembali dan denda.
5. **qty_peminjaman dan total_eksemplar** di p02 tidak menjadi kolom, karena digantikan oleh jumlah baris detail_peminjaman.
6. **Penamaan kolom:** `tgl_jatuh_tempo` di p02 diganti menjadi `tgl_jatuh_tempo_peminjaman` agar sesuai standar penamaan buku (akhiran nama tabel) dan sama dengan ERD.