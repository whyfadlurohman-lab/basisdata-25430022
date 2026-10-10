# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera

## 1. Latar belakang dan aktivitas organisasi
Koperasi Mahasiswa Sejahtera (Kopma) menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembelinya bisa anggota atau umum. Mahasiswa mendaftar sebagai anggota dengan menyerahkan NIM, nama, program studi, dan nomor HP, lalu mendapat nomor anggota berformat A-xxxx. Anggota aktif mendapat diskon 5% untuk setiap nota.

Tiga kasir bekerja bergantian per sif untuk mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok dan memesan ke pemasok bila stok di bawah batas minimum. Barang yang datang menambah stok sesuai faktur pemasok. Setiap awal bulan, ketua menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Keluhan pengguna: harga lama tidak dapat dicek pada nota lama (ketua), stok di buku catatan kadang minus (petugas gudang), dan anggota sering lupa membawa kartu sehingga dicari lewat NIM (kasir).
## 2. Aktor dan proses bisnis (tabel PB-xx)
| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
## 3. Dokumen sumber yang dianalisis
Dokumen sumber: nota penjualan Kopma, contoh nomor PJ-2609-0142 (24-09-2026 10:15), dilayani kasir Rina (K03) untuk anggota A-0457 atas nama Budi S.

Isi nota contoh:

| Barang | Qty | Harga | Subtotal |
|---|---|---|---|
| Pulpen Gel 0.5 | 3 | 4.000 | 12.000 |
| Buku Tulis 58 | 2 | 6.500 | 13.000 |
| Air Mineral 600 | 1 | 4.000 | 4.000 |

Jumlah 29.000, diskon anggota 5% sebesar 1.450, total 27.550, bayar tunai 30.000, kembali 2.450.

Pembedahan isian nota:

| Kelompok pada nota | Isian | Elemen data | Disimpan / dihitung |
|---|---|---|---|
| Identitas transaksi | Nomor nota | no_nota_penjualan | Disimpan |
| Identitas transaksi | Tanggal dan jam | tgl_penjualan | Disimpan |
| Relasi ke kasir | Kasir: Rina (K03) | kode_petugas, nama_petugas | Disimpan |
| Relasi ke anggota | Anggota: A-0457 / Budi S. | no_anggota, nama_anggota | Disimpan (boleh kosong untuk pembeli umum) |
| Barang, qty, harga saat transaksi | Nama barang | kode_barang, nama_barang | Disimpan |
| Barang, qty, harga saat transaksi | Qty | qty_detail_penjualan | Disimpan |
| Barang, qty, harga saat transaksi | Harga | harga_satuan_detail_penjualan | Disimpan (AB-04) |
| Nilai turunan | Subtotal per baris | subtotal_detail_penjualan | Dihitung (qty x harga) |
| Nilai turunan | Jumlah | jumlah_penjualan | Dihitung (jumlah semua subtotal) |
| Nilai turunan | Diskon anggota 5% | diskon_penjualan | Dihitung (jumlah x 5%, hanya anggota aktif, AB-02) |
| Nilai turunan | Total | total_penjualan | Dihitung (jumlah - diskon) |
| Data pembayaran | Bayar tunai | bayar_penjualan | Disimpan |
| Data pembayaran | Kembali | kembali_penjualan | Dihitung (bayar - total) |
## 4. Entitas kandidat dan elemen data
| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |
## 5. Aturan bisnis (tabel AB-xx)
| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
## 6. Kebutuhan informasi (tabel KI-xx)
| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
## 7. Matriks CRUD
## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |
## 8. Kamus data awal (dengan penanggung jawab)
| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |
## 9. Kebutuhan non-fungsional data (volume, retensi, privasi)
- **Volume:** perkiraan sekitar 150 nota per hari.
- **Retensi:** data transaksi disimpan minimal lima tahun.
- **Privasi:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua. Pembatasan ini sejalan dengan kewajiban pengendali data dalam UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi.
## 10. Isu kualitas data yang diantisipasi
Dari wawancara dan aturan bisnis, saya memperkirakan beberapa masalah kualitas data berikut akan muncul di Kopma:

1. **Harga nota lama berubah.** Kalau harga hanya disimpan di data barang, setiap kenaikan harga ikut mengubah tampilan nota lama, sehingga laporan omzet bulan sebelumnya menjadi tidak akurat. Ini sesuai keluhan ketua. Solusinya harga disimpan di setiap baris nota (AB-04).
2. **Stok bernilai minus.** Pencatatan manual membuat stok bisa lebih kecil dari nol, seperti keluhan petugas gudang. Solusinya aturan stok tidak boleh negatif (AB-03).
3. **Anggota tercatat ganda atau NIM keliru.** Kasir mencari anggota lewat NIM, jadi NIM yang salah ketik atau terdaftar dua kali membuat diskon bisa terpakai dua kali. Solusinya NIM wajib unik (AB-05).
4. **Penulisan nama tidak seragam.** Nama anggota, nama pemasok, atau program studi bisa ditulis dengan ejaan berbeda untuk orang atau pihak yang sama, sehingga laporan per kelompok terpecah. Solusinya data master dicatat satu kali, lalu dipilih, bukan diketik ulang.
5. **Nomor HP tidak valid atau terbaca pihak yang tidak berhak.** Nomor HP adalah data pribadi, jadi formatnya perlu diperiksa dan aksesnya dibatasi hanya untuk ketua.