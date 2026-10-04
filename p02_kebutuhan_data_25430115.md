# Dokumen Kebutuhan Data Proyek: Toko Daring (Daniel Store - DS)
**Penyusun:** Daniel Subing (NIM: 25430115)  
**Kelas:** D  
**Mata Kuliah:** Praktikum Basis Data  

---

## 1. Profil Organisasi dan Lingkup Layanan
**Toko Daring Daniel Store (DS)** merupakan unit bisnis e-commerce yang melayani penjualan produk gaya hidup dan perlengkapan komputer secara daring. Ruang lingkup sistem mencakup pengelolaan katalog produk dan kategori, pendaftaran pelanggan, pemrosesan transaksi pesanan, pembayaran, serta pencatatan stok dan ulasan produk.

---

## 2. Proses Bisnis (PB)
* **PB-01 (Registrasi dan Autentikasi Pelanggan):** Pelanggan mendaftarkan akun baru dengan mengisi identitas dasar serta kontak, kemudian sistem mencatat data akun untuk kebutuhan autentikasi masuk ke platform.
* **PB-02 (Manajemen Katalog dan Stok Barang):** Admin mengelola varian produk, kategori barang, harga satuan, dan memperbarui stok persediaan yang tersedia di gudang.
* **PB-03 (Pemesanan dan Transaksi Pembelian):** Pelanggan memilih barang ke keranjang belanja, menentukan alamat pengiriman, dan membuat tagihan pesanan penjualan.
* **PB-04 (Konfirmasi Pembayaran dan Pelunasan):** Pelanggan melakukan pelunasan tagihan melalui saluran pembayaran, kemudian admin/sistem memvalidasi status transaksi menjadi lunas.
* **PB-05 (Pengelolaan Ulasan Produk):** Pelanggan yang telah menyelesaikan transaksi dapat memberikan rating dan ulasan teks terhadap barang yang telah dibeli.

---

## 3. Entitas Kandidat (Minimal 6 Entitas)
1. **Pelanggan:** Menyimpan data profil pembeli yang terdaftar di platform.
2. **Kategori:** Menyimpan klasifikasi kelompok barang.
3. **Produk:** Menyimpan data barang dagangan, spesifikasi, harga jual, dan jumlah persediaan stok.
4. **Pesanan:** Menyimpan header nota transaksi pemesanan barang oleh pelanggan.
5. **Detail_Pesanan:** Menyimpan rincian item produk yang dibeli, jumlah item, serta subtotal harga per item.
6. **Pembayaran:** Menyimpan catatan pelunasan faktur transaksi pesanan, metode bayar, dan bukti konfirmasi.
7. **Ulasan:** Menyimpan penilaian produk dari pelanggan atas barang yang dibeli.

---

## 4. Aturan Bisnis (AB) - Minimal 8 Aturan
* **AB-01 (Keunikan Identitas Akun):** Setiap akun pelanggan wajib menggunakan alamat email yang unik dan kata sandi disimpan dalam bentuk hash terenkripsi.
* **AB-02 (Validitas Harga dan Stok):** Harga satuan produk dan sisa stok barang tidak boleh bernilai negatif (harus $\ge 0$).
* **AB-03 (Klasifikasi Kategori):** Setiap produk wajib terhubung dengan minimal satu kategori barang aktif.
* **AB-04 (Pemberian Nomor Pesanan):** Setiap transaksi pesanan baru wajib diberikan nomor transaksi yang unik dan otomatis tercatat tanggal/waktu pembuatannya.
* **AB-05 (Pemesanan Berbasis Ketersediaan):** Jumlah kuantitas barang dalam Detail_Pesanan tidak boleh melebihi jumlah sisa stok produk yang tersedia di gudang.
* **AB-06 (Otomatisasi Pemotongan Stok):** Ketika pesanan berhasil dibuat, sistem wajib langsung mengurangi kuantitas stok produk terkait sesuai jumlah pembelian secara atomik.
* **AB-07 (Batas Waktu Pelunasan):** Pesanan yang tidak dilakukan konfirmasi pembayaran dalam waktu $1 \times 24$ jam akan dibatalkan otomatis dan stok dikembalikan (*restock*).
* **AB-08 (Validasi Nominal Pembayaran):** Nominal pada entitas Pembayaran wajib bernilai sama persis dengan total tagihan pada entitas Pesanan.
* **AB-09 (Syarat Ulasan Produk):** Pelanggan hanya diperbolehkan membuat ulasan pada produk yang status transaksinya sudah terverifikasi selesai (*completed*).

---

## 5. Kebutuhan Informasi (KI) - Minimal 5 Kebutuhan
* **KI-01 (Katalog Produk Aktif):** Menampilkan daftar nama barang, harga, nama kategori, dan sisa stok yang siap dijual.
* **KI-02 (Riwayat Belanja Pelanggan):** Menampilkan rekap histori pesanan per pelanggan lengkap dengan nomor nota, tanggal, status pelunasan, dan total biaya.
* **KI-03 (Laporan Penjualan Harian/Bulanan):** Rekapitulasi omzet pemasukan toko dan total volume transaksi dalam periode tanggal tertentu untuk pemilik toko.
* **KI-04 (Peringatan Stok Menipis):** Informasi daftar barang dengan persediaan stok di bawah batas ambang minimum ($\le 5$ unit) agar segera dilakukan restock.
* **KI-05 (Rata-rata Rating Produk):** Menghitung nilai rerata ulasan bintang (1-5) dan testimoni pelanggan pada halaman detail produk.

---

## 6. Matriks CRUD Lengkap

| Entitas | Registrasi Akun | Kelola Katalog | Buat Pesanan | Bayar Pesanan | Beri Ulasan | Rekap Laporan |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Pelanggan** | C, R | - | R | R | R | R |
| **Kategori** | - | C, R, U, D | R | - | - | R |
| **Produk** | - | C, R, U, D | R, U (stok) | - | R | R |
| **Pesanan** | - | - | C, R | R, U (status) | R | R |
| **Detail_Pesanan**| - | - | C, R | R | - | R |
| **Pembayaran** | - | - | - | C, R | - | R |
| **Ulasan** | - | - | - | - | C, R | R |

*Catatan: Seluruh 7 entitas memiliki aksi Create (C) pada proses bisnis masing-masing sehingga tidak ada entitas yang tidak pernah dibuat.*

---

## 7. Kamus Data Awal (20 Elemen dengan Penanggung Jawab)

| No | Nama Elemen Data | Tipe Data | Keterangan / Batasan | Penanggung Jawab |
|---|---|---|---|---|
| 1 | `id_pelanggan` | INT | Kunci utama identitas akun pelanggan | Database Administrator |
| 2 | `nama_lengkap` | VARCHAR(100) | Nama lengkap pembeli | Pelanggan / Front-End Dev |
| 3 | `email_pelanggan` | VARCHAR(100) | Alamat email unik untuk login | Pelanggan / Front-End Dev |
| 4 | `kata_sandi_hash` | VARCHAR(255) | Hash kata sandi terenkripsi | Backend Developer / Security |
| 5 | `nomor_telepon` | VARCHAR(20) | Kontak aktif pelanggan | Pelanggan |
| 6 | `alamat_pengiriman`| TEXT | Alamat lengkap tujuan paket | Pelanggan |
| 7 | `id_kategori` | INT | Kunci utama kategori produk | Admin Gudang |
| 8 | `nama_kategori` | VARCHAR(50) | Nama kelompok barang (mis: Aksesoris) | Admin Gudang |
| 9 | `id_produk` | INT | Kunci utama barang | Admin Gudang |
| 10 | `nama_produk` | VARCHAR(150) | Nama resmi barang dagangan | Admin Gudang |
| 11 | `harga_satuan` | DECIMAL(12,2) | Nilai nominal rupiah barang ($\ge 0$) | Bagian Keuangan / Admin |
| 12 | `stok_tersedia` | INT | Jumlah unit persediaan di gudang ($\ge 0$)| Admin Gudang |
| 13 | `id_pesanan` | INT | Nomor unik faktur pesanan | Sistem Pemesanan |
| 14 | `tanggal_pesanan` | DATETIME | Waktu transaksi dibuat otomatis | Sistem Pemesanan |
| 15 | `total_tagihan` | DECIMAL(12,2) | Total nilai belanja yang harus dibayar | Sistem Pemesanan |
| 16 | `status_pesanan` | VARCHAR(20) | Nilai: 'MENUNGGU', 'LUNAS', 'BATAL' | Sistem / Kasir |
| 17 | `jumlah_beli` | INT | Banyaknya unit barang yang dibeli ($> 0$)| Pelanggan |
| 18 | `subtotal_harga` | DECIMAL(12,2) | Perkalian jumlah beli $\times$ harga satuan| Sistem Pemesanan |
| 19 | `id_pembayaran` | INT | Kunci unik catatan pelunasan | Bagian Keuangan |
| 20 | `metode_bayar` | VARCHAR(50) | Pilihan: 'TRANSFER_BANK', 'E_WALLET' | Pelanggan |
| 21 | `nilai_rating` | INT | Bintang ulasan bernilai skala 1 hingga 5 | Pelanggan |

---

## 8. Kebutuhan Non-Fungsional dan Perlindungan Data Pribadi
1. **Perlindungan Data Pribadi (Privasi):**
   * Data sensitif seperti `kata_sandi_hash`, `nomor_telepon`, dan `alamat_pengiriman` diklasifikasikan sebagai data pribadi rahasia.
   * Kata sandi wajib di-hash menggunakan algoritma modern dan dilarang disimpan dalam bentuk teks polos (*plain text*).
   * Hak akses melihat nomor telepon dan alamat fisik hanya dibuka bagi Pelanggan pemilik akun dan staf ekspedisi/admin pengiriman dengan otorisasi berbasis peran (Role-Based Access Control).
2. **Ketersediaan & Keandalan (Availability & Reliability):**
   * Sistem mampu beroperasi 24/7 dengan batas toleransi pemulihan kegagalan (*recovery*) maksimal 15 menit.
   * Transaksi pencatatan pesanan dan pemotongan stok wajib mematuhi standar ACID untuk menghindari selisih stok (*race condition*).
3. **Performa (Performance):**
   * Pemuatan katalog barang dan kueri pencarian wajib selesai dalam waktu $\le 500$ milidetik pada penggunaan normal.

---

## 9. Bedah Dokumen Sumber Fiktif: Nota Pesanan Penjualan

### Rancangan Dokumen Nota Fiktif
```text
======================================================================
                         DANIEL STORE (DS)
                Katalog Gaya Hidup & Komputer Daring
======================================================================
No. Nota    : DS-202610-001               Tanggal: 2026-10-04 19:30
Pelanggan   : Budi Santoso                Kontak : 081234567890
Alamat      : Jl. Mawar No. 12, Metro, Lampung
----------------------------------------------------------------------
Item Produk                     Qty    Harga Satuan    Subtotal
----------------------------------------------------------------------
1. Keyboard Mechanical TKL       1     Rp450.000       Rp450.000
2. Mouse Wireless Ergonomis      2     Rp150.000       Rp300.000
----------------------------------------------------------------------
Total Pembayaran                                       Rp750.000
Metode Bayar: Transfer Bank (BCA)
Status      : LUNAS
======================================================================