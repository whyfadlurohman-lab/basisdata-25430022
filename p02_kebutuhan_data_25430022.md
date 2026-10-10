# Dokumen Kebutuhan Data - Perpustakaan Cendekia WFR

## 9. Hitung P
* **Perhitungan Parameter P:** Berdasarkan dua digit terakhir NIM (22), perhitungan parameter $P$ dilakukan dengan rumus $(22 \pmod 9) + 1 = 4 + 1 = 5$.
* **Perkiraan Volume:** Berdasarkan rumus parameter $P$ di buku praktikum, estimasi volume transaksi harian adalah sekitar $40 + 5 \times 5 = 65$ transaksi per hari. Batas maksimal item buku per transaksi adalah $P + 2 = 7$ item.
* **Retensi Data:** Seluruh catatan transaksi peminjaman, pengembalian, dan riwayat denda perpustakaan akan disimpan sekurang-kurangnya selama 5 tahun untuk keperluan audit dan pelaporan operasional.
* **Privasi Data:** Atribut data pribadi anggota (seperti nomor telepon/HP anggota) dikategorikan sebagai data privat dan hanya dapat diakses oleh petugas atau kepala perpustakaan yang berwenang sesuai dengan peraturan pelindungan data yang berlaku.
## 1. Latar belakang dan aktivitas organisasi
Perpustakaan Cendekia DI merupakan unit layanan literasi kampus yang melayani sirkulasi buku, pengelolaan keanggotaan mahasiswa, serta pencatatan denda keterlambatan secara tertib[cite: 19].
Aktivitas harian organisasi ini meliputi pendaftaran anggota baru, pencatatan peminjaman dan pengembalian koleksi buku, pengelolaan stok eksemplar buku, serta penyusunan laporan bulanan bagi pengelola[cite: 19, 47].
## 2. Aktor dan proses bisnis
Tabel proses bisnis (PB-xx):
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota baru | Petugas perpustakaan | Mahasiswa mengajukan permohonan keanggotaan[cite: 47] |
| PB-02 | Mencatat peminjaman buku | Petugas perpustakaan | Anggota meminjam buku koleksi[cite: 12] |
| PB-03 | Mencatat pengembalian dan denda | Petugas perpustakaan | Anggota mengembalikan buku pinjaman[cite: 12] |
| PB-04 | Mengelola data pengadaan buku | Petugas gudang/pengadaan | Buku baru atau eksemplar tambahan tiba dari pemasok[cite: 47] |
## 3. Dokumen sumber yang dianalisis
* **Contoh Dokumen Fiktif (Slip Peminjaman Buku):**
  - No. Slip: SL-2610-0012
  - Tanggal: 10-10-2026 09:30
  - Anggota: A-0123 / Rian Pratama
  - Daftar Buku: Algoritma Pemrograman (1 eksemplar), Basis Data Lanjut (1 eksemplar)
  - Status: Dipinjam (Batas kembali: 17-10-2026)

Tabel pembedahan dokumen sumber:
| Isian pada Dokumen | Elemen Data Terkait | Status (Disimpan / Dihitung) |
|---|---|---|
| No. Slip / No. Transaksi | no_slip_peminjaman | Disimpan[cite: 45] |
| Tanggal Peminjaman | tgl_peminjaman | Disimpan[cite: 45] |
| Identitas Anggota | id_anggota / no_anggota | Disimpan[cite: 45] |
| Daftar Buku & Qty | id_buku, qty_peminjaman | Disimpan[cite: 45] |
| Total Eksemplar Dipinjam | total_eksemplar | Dihitung (Nilai Turunan)[cite: 45] |
## 4. Entitas kandidat dan elemen data
Tabel entitas kandidat:
| Entitas Kandidat | Elemen Data Utama | Sumber |
|---|---|---|
| Anggota | id_anggota, no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota | Formulir pendaftaran[cite: 48] |
| Buku | id_buku, kode_buku, judul_buku, kategori_buku, harga_buku | Katalog perpustakaan[cite: 48] |
| Eksemplar | id_eksemplar, no_eksemplar, id_buku, kondisi_eksemplar, status_eksemplar | Inventaris fisik[cite: 48] |
| Peminjaman | id_peminjaman, no_slip_peminjaman, tgl_peminjaman, tgl_jatuh_tempo, id_petugas, id_anggota | Slip peminjaman[cite: 48] |
| Detail Peminjaman | id_peminjaman, id_eksemplar | Slip peminjaman[cite: 48] |
| Petugas | id_petugas, kode_petugas, nama_petugas, peran_petugas | Catatan kepegawaian[cite: 48] |
## 5. Aturan bisnis
Tabel aturan bisnis (AB-xx):
| Kode | Aturan Bisnis | Asal / Sumber |
|---|---|---|
| AB-01 | Setiap transaksi peminjaman wajib memiliki nomor slip unik dan minimal satu eksemplar buku[cite: 49]. | Keluhan proses sirkulasi harian[cite: 49] |
| AB-02 | Anggota yang meminjam buku harus berstatus aktif dalam sistem[cite: 49]. | Kebijakan layanan perpustakaan[cite: 49] |
| AB-03 | Jumlah eksemplar buku tersedia tidak boleh bernilai negatif[cite: 49]. | Keluhan stok fisik selisih[cite: 49] |
| AB-04 | Identitas NIM anggota bersifat unik untuk mencegah duplikasi data mahasiswa[cite: 49]. | Pengamatan kesalahan input NIM ganda[cite: 49] |
| AB-05 | Batas maksimal peminjaman buku per transaksi tidak boleh melebihi parameter $P + 2$ (yaitu 9 buku)[cite: 52]. | Ketentuan parameter $P$ proyek[cite: 52] |
| AB-06 | Pengembalian buku yang melewati tanggal jatuh tempo dikenakan denda harian per eksemplar[cite: 49]. | Aturan tata tertib perpustakaan[cite: 49] |
| AB-07 | Nama petugas dan anggota harus merujuk pada data master tunggal yang konsisten[cite: 49]. | Catatan inkonsistensi ejaan lama[cite: 49] |
| AB-08 | Status eksemplar buku diperbarui otomatis menjadi dipinjam atau tersedia[cite: 49]. | Alur kerja operasional[cite: 49] |
## 6. Kebutuhan informasi
Tabel kebutuhan informasi (KI-xx):
| Kode | Kebutuhan Informasi | Data yang Diperlukan |
|---|---|---|
| KI-01 | Rekapitulasi jumlah peminjaman dan pengembalian harian serta bulanan[cite: 49] | Tabel Peminjaman[cite: 49] |
| KI-02 | Daftar lima judul buku yang paling sering dipinjam per bulan[cite: 49] | Detail Peminjaman, Eksemplar, Buku[cite: 49] |
| KI-03 | Laporan daftar anggota perpustakaan yang paling aktif meminjam[cite: 49] | Anggota, Peminjaman[cite: 49] |
| KI-04 | Daftar buku yang sedang melewati masa jatuh tempo (terlambat dikembalikan)[cite: 49] | Peminjaman, Detail Peminjaman, Anggota[cite: 49] |
| KI-05 | Riwayat peminjaman buku berdasarkan pencarian NIM atau nomor anggota[cite: 49] | Anggota, Peminjaman[cite: 49] |
## 7. Matriks CRUD
| Proses Bisnis | Anggota | Buku | Eksemplar | Peminjaman | Detail Peminjaman | Petugas |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| PB-01 Mendaftarkan anggota baru | C | - | - | - | - | - |
| PB-02 Mencatat peminjaman buku | R | R | U | C | C | R |
| PB-03 Mencatat pengembalian dan denda | R | - | U | U | R | R |
| PB-04 Mengelola data pengadaan buku | - | C | C | - | - | R |
## 8. Kamus data awal
| Elemen Data | Arti / Deskripsi | Contoh Nilai | Aturan / Format | Penanggung Jawab |
|---|---|---|---|---|
| id_anggota | Kunci primer entitas anggota | 1 | Integer, Auto Increment[cite: 50] | Kepala Perpustakaan[cite: 50] |
| no_anggota | Nomor kartu anggota | A-0123 | Unik, Format A-4 digit[cite: 50] | Kepala Perpustakaan[cite: 50] |
| nim_anggota | Nomor Induk Mahasiswa | 2301010115 | Unik, 10 digit angka[cite: 50] | Kepala Perpustakaan[cite: 50] |
| nama_anggota | Nama lengkap anggota | Rian Pratama | Huruf, Not Null[cite: 50] | Kepala Perpustakaan[cite: 50] |
| prodi_anggota | Program studi mahasiswa | Ilmu Komputer | Teks baku[cite: 50] | Kepala Perpustakaan[cite: 50] |
| no_hp_anggota | Nomor kontak seluler anggota | 081234567890 | Format nomor HP (Privasi)[cite: 50] | Kepala Perpustakaan[cite: 50] |
| status_anggota | Status keaktifan anggota | aktif | ENUM ('aktif', 'nonaktif')[cite: 50] | Kepala Perpustakaan[cite: 50] |
| tgl_daftar_anggota| Tanggal pendaftaran keanggotaan | 2026-09-01 | DATE[cite: 50] | Kepala Perpustakaan[cite: 50] |
| id_buku | Kunci primer master buku | 1 | Integer, Auto Increment[cite: 50] | Petugas Pengadaan[cite: 50] |
| kode_buku | Kode unik klasifikasi buku | BK-IF-01 | Unik, String[cite: 50] | Petugas Pengadaan[cite: 50] |
| judul_buku | Judul literatur buku | Basis Data Lanjut | Not Null[cite: 50] | Petugas Pengadaan[cite: 50] |
| kategori_buku | Kategori pengelompokan buku | Teknologi | ENUM / Teks[cite: 50] | Petugas Pengadaan[cite: 50] |
| id_eksemplar | Kunci primer unit fisik buku | 1 | Integer, Auto Increment[cite: 50] | Petugas Pengadaan[cite: 50] |
| no_eksemplar | Label barcode unit fisik | EKS-0101 | Unik[cite: 50] | Petugas Pengadaan[cite: 50] |
| id_peminjaman | Kunci primer kepala transaksi | 1 | Integer, Auto Increment[cite: 50] | Petugas Layanan[cite: 50] |
| no_slip_peminjaman| Nomor slip bukti peminjaman | SL-2610-0012 | Unik, Format slip[cite: 50] | Petugas Layanan[cite: 50] |
| tgl_peminjaman | Waktu saat peminjaman dicatat | 2026-10-10 09:30:00| DATETIME[cite: 50] | Petugas Layanan[cite: 50] |
| tgl_jatuh_tempo | Batas waktu pengembalian buku | 2026-10-17 | DATE[cite: 50] | Petugas Layanan[cite: 50] |
| id_petugas | Kunci tamu identitas petugas | 2 | Smallint[cite: 50] | Kepala Perpustakaan[cite: 50] |
| denda_peminjaman | Nilai kumulatif denda telat | 5000 | DECIMAL(12,2), $\ge 0$[cite: 50] | Petugas Layanan[cite: 50] |
## 10. Isu kualitas data yang diantisipasi
* **Pencatatan Manual / Human Error:** Kesalahan pengetikan nama atau duplikasi input data mahasiswa diantisipasi dengan menerapkan validasi keunikan NIM pada level basis data (sesuai AB-04)[cite: 1, 49].
* **Validitas Status Stok Fisik:** Risiko kesalahan status eksemplar buku dihindari dengan memastikan perubahan status fisik terkait langsung dengan proses transaksi (sesuai AB-03 dan AB-08)[cite: 1, 49].
* **Konsistensi Penulisan Data:** Perbedaan variasi ejaan pada penamaan entitas atau program studi diatasi dengan pemberlakuan format data master terpusat yang seragam[cite: 1, 49].