# Milestone Proyek 4: Normalisasi Basis Data Proyek Toko Daring
**Nama:** Daniel Subing  
**NPM:** 25430115  
**Basis Data:** 

---

## 1. Dokumen Sumber dan Skema Bentuk Tidak Normal (UNF)
Titik awal analisis normalisasi diambil dari dokumen transaksi transaksi digital berupa **Faktur / Invoice Pesanan Toko Daring** (turunan dokumen kebutuhan Pertemuan 2). Pada dokumen mentah ini, satu faktur pesanan menampung rincian beberapa produk sekaligus sehingga membentuk kelompok berulang (*repeating groups*).

### A. Format Faktur Mentah (Dokumen Sumber)
```text
Nomor Faktur   : PJ01
Tanggal Pesanan: 2026-10-10
ID Pelanggan   : A01
Nama Pelanggan : Daniel Subing
Nomor Handphone: 08123456789
-------------------------------------------------------------------------------------
ID Barang | Nama Barang | Kategori | Harga Satuan | Jumlah Beli | Subtotal
-------------------------------------------------------------------------------------
B01       | Kaos Polos  | Pakaian  | Rp 50.000    | 2           | Rp 100.000
B02       | Topi Rimba  | Aksesoris| Rp 30.000    | 1           | Rp  30.000
-------------------------------------------------------------------------------------
Total Pembayaran : Rp 130.000
Poin Diperoleh   : 13 Poin
```

### B. Notasi Skema Relasi UNF
```text
Faktur_UNF (
    no_pesanan,
    tgl_pesan,
    id_anggota,
    nama_anggota,
    no_hp,
    daftar_barang(id_barang, nama_barang, kategori_barang, harga_jual, qty, subtotal),
    total_bayar,
    poin_didapat
)
```

### C. Simulasi Tabel UNF
| no_pesanan | tgl_pesan | id_anggota | nama_anggota | no_hp | daftar_barang | total_bayar | poin_didapat |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| PJ01 | 2026-10-10 | A01 | Daniel Subing | 08123456789 | B01 (Kaos Polos, Pakaian, 50000, 2, 100000), B02 (Topi Rimba, Aksesoris, 30000, 1, 30000) | 130000 | 13 |
| PJ02 | 2026-10-11 | A02 | Ahmad Zidan | 08987654321 | B01 (Kaos Polos, Pakaian, 50000, 1, 50000) | 50000 | 5 |

---

## 2. Dependensi Fungsional dan Aturan Bisnis (AB)
Ketergantungan fungsional (*Functional Dependency*) didefinisikan berdasarkan aturan bisnis sistem Toko Daring `toko_115`:

* **AB01 (Identitas Pelanggan):**  
  Setiap pembeli/anggota terdaftar memiliki pengenal unik berupa `id_anggota` yang secara tunggal menentukan identitas profilnya.  
  $$\text{id\_anggota} \rightarrow \text{nama\_anggota}, \text{no\_hp}, \text{tgl\_daftar}$$

* **AB02 (Katalog Produk):**  
  Setiap barang dagangan diidentifikasi secara unik oleh `id_barang` yang menentukan deskripsi, klasifikasi kategori, harga katalog, dan sisa stok fisik.  
  $$\text{id\_barang} \rightarrow \text{nama\_barang}, \text{kategori\_barang}, \text{harga\_jual}, \text{stok}$$

* **AB03 (Header Transaksi Penjualan):**  
  Setiap transaksi pesanan diidentifikasi secara unik oleh `id_penjualan` yang menentukan waktu terjadinya transaksi, pembeli yang memesan, serta total pembayaran akhir.  
  $$\text{id\_penjualan} \rightarrow \text{tgl\_penjualan}, \text{id\_anggota}, \text{bayar\_penjualan}$$

* **AB04 (Rincian Item Pembelian):**  
  Banyaknya barang yang dipesan dan harga kesepakatan transaksi pada nota ditentukan secara bersama-sama oleh kombinasi transaksi penjualan dan item barang tertentu.  
  $$\{\text{id\_penjualan}, \text{id\_barang}\} \rightarrow \text{qty\_detail\_penjualan}, \text{harga\_satuan\_detail\_penjualan}$$

* **AB05 (Pencatatan Poin Loyalitas):**  
  Setiap mutasi perolehan atau penggunaan poin dicatat secara unik melalui `id_poin` yang merekam pemilik akun, transaksi terkait, besaran poin, jenis mutasi, serta waktu mutasi.  
  $$\text{id\_poin} \rightarrow \text{id\_anggota}, \text{id\_penjualan}, \text{jumlah\_poin}, \text{jenis\_transaksi}, \text{tgl\_poin}$$

---

## 3. Tahapan Normalisasi (1NF, 2NF, 3NF, BCNF)

### A. Tahap Bentuk Normal Pertama (1NF)
* **Syarat:** Setiap kolom harus bernilai skalar/atomik (tidak ada atribut bernilai banyak/kumpulan teks dipisah koma), dan tidak ada perulangan kolom sejenis.
* **Tindakan:** Mengurai kelompok berulang `daftar_barang` menjadi baris-baris individual sehingga setiap baris hanya merepresentasikan satu jenis barang yang dibeli per faktur. Kunci utama gabungan komposit adalah $\{\text{no\_pesanan}, \text{id\_barang}\}$.

| no_pesanan | tgl_pesan | id_anggota | nama_anggota | no_hp | total_bayar | id_barang | nama_barang | kategori | harga_satuan | qty |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| PJ01 | 2026-10-10 | A01 | Daniel Subing | 08123456789 | 130000 | B01 | Kaos Polos | Pakaian | 50000 | 2 |
| PJ01 | 2026-10-10 | A01 | Daniel Subing | 08123456789 | 130000 | B02 | Topi Rimba | Aksesoris | 30000 | 1 |
| PJ02 | 2026-10-11 | A02 | Ahmad Zidan | 08987654321 | 50000 | B01 | Kaos Polos | Pakaian | 50000 | 1 |

---

### B. Tahap Bentuk Normal Kedua (2NF)
* **Syarat:** Memenuhi 1NF dan tidak boleh ada ketergantungan parsial (*partial functional dependency*). Semua atribut non-kunci harus bergantung sepenuhnya (*full functional dependency*) pada keseluruhan *Primary Key*, bukan hanya sebagian elemen kunci komposit.
* **Analisis Pelanggaran pada 1NF:**  
  Kunci komposit adalah $\{\text{no\_pesanan}, \text{id\_barang}\}$.
  * Atribut `nama_barang`, `kategori`, dan `harga_jual` hanya bergantung pada $\text{id\_barang}$ (bergantung parsial).
  * Atribut `tgl_pesan`, `id_anggota`, `nama_anggota`, `no_hp`, dan `total_bayar` hanya bergantung pada $\text{no\_pesanan}$ (bergantung parsial).
* **Solusi Dekomposisi:**  
  Memecah relasi menjadi tiga tabel: tabel pesanan header, tabel katalog master barang, dan tabel asosiatif detail pesanan.

#### 1. Tabel Pesanan_Header (Kunci: no_pesanan)
| no_pesanan (PK) | tgl_pesan | id_anggota | nama_anggota | no_hp | total_bayar |
| :--- | :--- | :--- | :--- | :--- | :--- |
| PJ01 | 2026-10-10 | A01 | Daniel Subing | 08123456789 | 130000 |
| PJ02 | 2026-10-11 | A02 | Ahmad Zidan | 08987654321 | 50000 |

#### 2. Tabel Master Barang (Kunci: id_barang)
| id_barang (PK) | nama_barang | kategori | harga_jual |
| :--- | :--- | :--- | :--- |
| B01 | Kaos Polos | Pakaian | 50000 |
| B02 | Topi Rimba | Aksesoris | 30000 |

#### 3. Tabel Detail Pesanan (Kunci: no_pesanan, id_barang)
| no_pesanan (PK, FK) | id_barang (PK, FK) | qty | harga_satuan |
| :--- | :--- | :--- | :--- |
| PJ01 | B01 | 2 | 50000 |
| PJ01 | B02 | 1 | 30000 |
| PJ02 | B01 | 1 | 50000 |

---

### C. Tahap Bentuk Normal Ketiga (3NF)
* **Syarat:** Memenuhi 2NF dan tidak boleh ada ketergantungan transitif (*transitive functional dependency*). Atribut non-kunci tidak boleh bergantung pada atribut non-kunci lainnya.
* **Analisis Pelanggaran pada 2NF:**  
  Pada tabel `Pesanan_Header`:  
  $$\text{no\_pesanan} \rightarrow \text{id\_anggota} \rightarrow \{\text{nama\_anggota}, \text{no\_hp}\}$$  
  Atribut `nama_anggota` dan `no_hp` bergantung fungsional pada atribut non-kunci `id_anggota`. Ini menimbulkan anomali pembaruan (jika nomor HP berganti) dan redundansi data.
* **Solusi Dekomposisi:**  
  Memisahkan entitas data pelanggan ke dalam tabel tersendiri (`anggota`), sehingga tabel `penjualan` hanya menyimpan `id_anggota` sebagai *Foreign Key*. Menambahkan tabel `riwayat_poin` untuk menangani rekaman poin secara normal.

#### Struktur Skema Akhir 5 Entitas 3NF:
1. **`anggota`**  
   * Skema: `anggota(id_anggota, nama_anggota, no_hp, tgl_daftar)`  
   * PK: `id_anggota`
2. **`barang`**  
   * Skema: `barang(id_barang, nama_barang, kategori_barang, harga_jual, stok)`  
   * PK: `id_barang`
3. **`penjualan`**  
   * Skema: `penjualan(id_penjualan, tgl_penjualan, id_anggota, bayar_penjualan)`  
   * PK: `id_penjualan` | FK: `id_anggota` $\rightarrow$ `anggota(id_anggota)`
4. **`detail_penjualan`**  
   * Skema: `detail_penjualan(id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)`  
   * PK Komposit: `(id_penjualan, id_barang)` | FK: `id_penjualan`, `id_barang`
5. **`riwayat_poin`**  
   * Skema: `riwayat_poin(id_poin, id_anggota, id_penjualan, jumlah_poin, jenis_transaksi, tgl_poin)`  
   * PK: `id_poin` | FK: `id_anggota`, `id_penjualan`

---

### D. Pemeriksaan Bentuk Normal Boyce-Codd (BCNF)
* **Definisi:** Sebuah relasi berada dalam BCNF jika dan hanya jika untuk setiap ketergantungan fungsional nontrivial $X \rightarrow Y$, maka $X$ harus merupakan *superkey* (atau kandidat kunci).
* **Pengujian Relasi:**
  1. Relasi `anggota`: Determinan adalah `id_anggota` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  2. Relasi `barang`: Determinan adalah `id_barang` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  3. Relasi `penjualan`: Determinan adalah `id_penjualan` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  4. Relasi `detail_penjualan`: Determinan adalah pasangan komposit $\{\text{id\_penjualan}, \text{id\_barang}\}$ (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  5. Relasi `riwayat_poin`: Determinan adalah `id_poin` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
* **Kesimpulan:** Tidak ada determinan tersembunyi yang bukan kandidat kunci. Seluruh skema database berada dalam kondisi **3NF dan BCNF**.

---

## 4. Analisis Nilai Turunan (Derived Attributes)
Keputusan arsitektur mengenai penyimpanan atribut komputasi/turunan:

1. **Subtotal Pembelian (`qty * harga_satuan`):**
   * **Keputusan:** **Tidak Disimpan secara fisik**.
   * **Alasan:** Menyimpan subtotal melanggar prinsip efisiensi dan integritas normalisasi karena nilainya dapat dihitung kapan saja (*on-the-fly*) menggunakan kueri proyeksi:
     ```sql
     SELECT id_penjualan, id_barang, (qty_detail_penjualan * harga_satuan_detail_penjualan) AS subtotal
     FROM detail_penjualan;
     ```

2. **Harga Satuan Transaksi (`harga_satuan_detail_penjualan`):**
   * **Keputusan:** **Tetap Disimpan secara fisik**.
   * **Alasan:** Atribut ini bukan nilai turunan dari tabel barang, melainkan **rekaman historis (*point-in-time snapshot*)** pada saat transaksi terjadi. Jika harga barang di tabel master mengalami kenaikan atau diskon di masa depan, nilai total faktur transaksi masa lalu tidak boleh ikut berubah.

3. **Total Pembayaran (`bayar_penjualan`):**
   * **Keputusan:** **Tetap Disimpan secara fisik**.
   * **Alasan:** Digunakan sebagai dasar rekonsiliasi kas riil, bukti pembayaran akuntansi, dan menjaga integritas audit transaksi jika di kemudian hari terdapat penyesuaian voucher, potongan ongkos kirim, atau pembulatan.

---

## 6. Status Perubahan ERD Proyek
Berdasarkan hasil pengujian normalisasi, struktur 5 entitas yang dirancang pada Pertemuan 3 (`anggota`, `barang`, `penjualan`, `detail_penjualan`, dan `riwayat_poin`) telah terbukti bersih dari anomali redundansi, dependensi parsial, dan dependensi transitif.

* **Dekomposisi Lanjutan:** Tidak diperlukan tabel baru tambahan.
* **Status Berkas ERD:** Diagram konseptual dan fisik pada `p03_erd_25430115.drawio` tetap valid dan digunakan sebagai acuan baku tanpa perubahan skema.