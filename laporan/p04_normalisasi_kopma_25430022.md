# Normalisasi Kopma - <NIM>

## 1. Anomali pada Spreadsheet Lama
- **Anomali ubah:** "Budi S." vs "Budi Santoso"; pemasok ditulis "CV Sumber ATK" vs "CV. Sumber A.T.K"
- **Anomali sisip:** barang baru tidak bisa dicatat sebelum ada penjualannya
- **Anomali hapus:** menghapus nota PJ-0143 ikut menghapus info pemasok UD Segar

## 2. UNF
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota,
{ kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan },
jumlah_penjualan, diskon_penjualan, total_penjualan)

## 3. 1NF
Grup berulang dihilangkan: satu baris per barang per nota. PK = (no_nota_penjualan, kode_barang)

NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota,
nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)

## 4. Dependensi Fungsional
| Kode | Dependensi | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota | AB-01 |
| FD2 | kode_petugas → nama_petugas | - |
| FD3 | no_anggota → nama_anggota | AB-05 |
| FD4 | kode_barang → nama_barang | - |
| FD5 | (no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan → subtotal_detail_penjualan | turunan |

## 5. 2NF
FD1 dan FD4 hanya bergantung pada sebagian kunci komposit, jadi dipisah:
- PENJUALAN (**no_nota_penjualan**, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota)
- BARANG (**kode_barang**, nama_barang)
- DETAIL_PENJUALAN (**no_nota_penjualan, kode_barang**, qty_detail_penjualan, harga_satuan_detail_penjualan)

## 6. 3NF
Ada rantai transitif no_nota_penjualan → kode_petugas → nama_petugas dan
no_nota_penjualan → no_anggota → nama_anggota, jadi petugas dan anggota dipisah:
- PENJUALAN (**no_nota_penjualan**, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
- DETAIL_PENJUALAN (**no_nota_penjualan*, kode_barang***, qty_detail_penjualan, harga_satuan_detail_penjualan)
- BARANG (**kode_barang**, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
- PETUGAS (**kode_petugas**, nama_petugas, peran_petugas)
- ANGGOTA (**no_anggota**, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)

Tebal = kunci primer, * = kunci tamu

## 7. Keputusan Nilai Turunan
subtotal_detail_penjualan, jumlah_penjualan, dan total_penjualan **tidak disimpan**.
Nilainya dihitung dari detail penjualan dan status anggota, sehingga tidak mungkin tidak konsisten.

## 8. Pemeriksaan BCNF
| Tabel | Penentu | Kunci kandidat? | BCNF |
|---|---|---|---|
| petugas | kode_petugas | Ya | ✔ |
| anggota | no_anggota, nim_anggota | Ya, keduanya unik (AB-05) | ✔ |
| barang | kode_barang | Ya | ✔ |
| penjualan | no_nota_penjualan | Ya | ✔ |
| detail_penjualan | (no_nota_penjualan, kode_barang) | Ya | ✔ |

## 9. Skema Kanonik Kopma (Tabel 4.2)
| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |