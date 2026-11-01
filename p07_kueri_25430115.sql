-- =====================================================================
-- MILESTONE PROYEK 7: SKRIP KUERI SATU TABEL (toko_115)
-- Mahasiswa : Daniel Subing
-- NPM       : 25430115
-- Basis Data: toko_115
-- Deskripsi : Kumpulan 10 kueri satu tabel untuk mendukung Kebutuhan
--             Informasi (KI) bisnis toko daring toko_115.
-- Syarat    : Menggunakan LIKE, BETWEEN, IN, IS NULL, CASE, fungsi 
--             tanggal, dan fungsi string.
-- =====================================================================

USE toko_115;

-- ---------------------------------------------------------------------
-- KUERI 1: Pencarian Produk Pakaian Menggunakan Pola Kata Kunci
-- Syarat    : LIKE (Fungsi String)
-- Kode KI   : KI-01
-- Pertanyaan: Produk apa saja dalam katalog pakaian yang mengandung kata 'Kaos' atau 'Flannel'?
-- Ekspektasi: Menampilkan id_barang, nama_barang, dan harga_jual untuk produk pakaian terkait.
-- ---------------------------------------------------------------------
SELECT 
    id_barang,
    nama_barang,
    kategori_barang,
    harga_jual
FROM barang
WHERE kategori_barang = 'Pakaian' 
  AND (nama_barang LIKE '%Kaos%' OR nama_barang LIKE '%Flannel%');

-- ---------------------------------------------------------------------
-- KUERI 2: Penyaringan Rentang Harga Menengah Produk
-- Syarat    : BETWEEN
-- Kode KI   : KI-02
-- Pertanyaan: Barang mana saja yang memiliki harga jual antara Rp 30.000 hingga Rp 100.000?
-- Ekspektasi: Daftar produk dengan rentang harga ekonomis hingga menengah beserta sisa stoknya.
-- ---------------------------------------------------------------------
SELECT 
    id_barang,
    nama_barang,
    harga_jual,
    stok
FROM barang
WHERE harga_jual BETWEEN 30000.00 AND 100000.00
ORDER BY harga_jual ASC;

-- ---------------------------------------------------------------------
-- KUERI 3: Pengelompokan Kategori Barang Tertentu
-- Syarat    : IN
-- Kode KI   : KI-03
-- Pertanyaan: Barang apa saja yang termasuk ke dalam kategori 'Aksesoris' atau 'Makanan'?
-- Ekspektasi: Baris data barang khusus untuk kategori aksesoris dan makanan ringan.
-- ---------------------------------------------------------------------
SELECT 
    id_barang,
    nama_barang,
    kategori_barang,
    harga_jual,
    stok
FROM barang
WHERE kategori_barang IN ('Aksesoris', 'Makanan')
ORDER BY kategori_barang, nama_barang;

-- ---------------------------------------------------------------------
-- KUERI 4: Audit Transaksi Tanpa Anggota Terdaftar (Anonim / Hak Hapus UU PDP)
-- Syarat    : IS NULL
-- Kode KI   : KI-04
-- Pertanyaan: Transaksi penjualan mana saja yang tidak memiliki id_anggota (transaksi tamu / anggota dihapus)?
-- Ekspektasi: Menampilkan rekaman penjualan yang id_anggota-nya bernilai NULL.
-- ---------------------------------------------------------------------
SELECT 
    id_penjualan,
    tgl_penjualan,
    bayar_penjualan
FROM penjualan
WHERE id_anggota IS NULL;

-- ---------------------------------------------------------------------
-- KUERI 5: Klasifikasi Tingkat Kritis Stok Barang Fisik
-- Syarat    : CASE
-- Kode KI   : KI-05
-- Pertanyaan: Bagaimana status ketersediaan stok fisik barang jika dibandingkan dengan batas aman?
-- Ekspektasi: Kolom status_stok yang mengelompokkan stok ke dalam 'Kritis', 'Waspada', atau 'Aman'.
-- ---------------------------------------------------------------------
SELECT 
    id_barang,
    nama_barang,
    stok,
    stok_min_barang,
    CASE 
        WHEN stok <= stok_min_barang THEN 'Kritis (Perlu Restock Segera)'
        WHEN stok <= (stok_min_barang * 3) THEN 'Waspada (Menipis)'
        ELSE 'Aman'
    END AS status_stok
FROM barang
ORDER BY stok ASC;

-- ---------------------------------------------------------------------
-- KUERI 6: Rekapitulasi Transaksi Berdasarkan Bulan dan Tahun
-- Syarat    : Fungsi Tanggal (MONTH, YEAR)
-- Kode KI   : KI-06
-- Pertanyaan: Transaksi penjualan mana saja yang terjadi pada bulan Oktober tahun 2026 dengan nilai di atas Rp 100.000?
-- Ekspektasi: Daftar penjualan bernilai besar yang dibukukan pada periode Oktober 2026.
-- ---------------------------------------------------------------------
SELECT 
    id_penjualan,
    tgl_penjualan,
    id_anggota,
    bayar_penjualan
FROM penjualan
WHERE YEAR(tgl_penjualan) = 2026 
  AND MONTH(tgl_penjualan) = 10
  AND bayar_penjualan >= 100000.00
ORDER BY tgl_penjualan DESC;

-- ---------------------------------------------------------------------
-- KUERI 7: Standardisasi Format Teks Nama Anggota dan No Handphone
-- Syarat    : Fungsi String (UPPER, CONCAT, LENGTH)
-- Kode KI   : KI-07
-- Pertanyaan: Bagaimana tampilan nama anggota dalam huruf kapital beserta panjang karakter nomor kontaknya?
-- Ekspektasi: Kolom nama berhuruf besar dan informasi validitas panjang nomor telepon.
-- ---------------------------------------------------------------------
SELECT 
    id_anggota,
    UPPER(nama_anggota) AS nama_kapital,
    CONCAT('+62', SUBSTRING(no_hp, 2)) AS no_hp_internasional,
    LENGTH(no_hp) AS digit_hp
FROM anggota
ORDER BY nama_anggota ASC;

-- ---------------------------------------------------------------------
-- KUERI 8: Perhitungan Masa Keanggotaan Pelanggan Aktif
-- Syarat    : Fungsi Tanggal (DATEDIFF, CURDATE)
-- Kode KI   : KI-08
-- Pertanyaan: Berapa hari anggota telah terdaftar di sistem hingga saat ini?
-- Ekspektasi: Kolom lama_bergabung_hari untuk setiap pelanggan terdaftar.
-- ---------------------------------------------------------------------
SELECT 
    id_anggota,
    nama_anggota,
    tgl_daftar,
    DATEDIFF(CURDATE(), tgl_daftar) AS lama_bergabung_hari
FROM anggota
ORDER BY tgl_daftar ASC;

-- ---------------------------------------------------------------------
-- KUERI 9: Penyaringan Item Detail Penjualan Volume Tinggi
-- Syarat    : Operator Logika & Perbandingan
-- Kode KI   : KI-09
-- Pertanyaan: Rincian transaksi mana saja yang memuat pembelian barang sebanyak 3 item atau lebih?
-- Ekspektasi: Daftar baris detail penjualan bervolume tinggi beserta subtotal kalkulasinya.
-- ---------------------------------------------------------------------
SELECT 
    id_penjualan,
    id_barang,
    qty_detail_penjualan,
    harga_satuan_detail_penjualan,
    (qty_detail_penjualan * harga_satuan_detail_penjualan) AS subtotal_item
FROM detail_penjualan
WHERE qty_detail_penjualan >= 3
ORDER BY qty_detail_penjualan DESC;

-- ---------------------------------------------------------------------
-- KUERI 10: Pengelompokan Perolehan Poin Loyalitas Anggota
-- Syarat    : CASE, Operator Relasional
-- Kode KI   : KI-10
-- Pertanyaan: Bagaimana kategorisasi perolehan poin per transaksi (Tinggi, Sedang, Rendah)?
-- Ekspektasi: Riwayat poin transaksi dengan label kategori mutasi poin.
-- ---------------------------------------------------------------------
SELECT 
    id_poin,
    id_anggota,
    id_penjualan,
    jumlah_poin,
    CASE 
        WHEN jumlah_poin >= 25 THEN 'Tinggi (Reward Platinum)'
        WHEN jumlah_poin >= 10 THEN 'Sedang (Reward Gold)'
        ELSE 'Standar'
    END AS kategori_reward,
    tgl_poin
FROM riwayat_poin
WHERE jenis_transaksi = 'dapat'
ORDER BY jumlah_poin DESC;

-- =====================================================================
-- CATATAN KEBUTUHAN INFORMASI (KI) YANG BELUM BISA DIJAWAB 1 TABEL:
-- ---------------------------------------------------------------------
-- 1. [KI-BELUM-01]: Laporan rekap total belanja nominal riil per nama pelanggan.
--    Alasan: Membutuhkan relasi/JOIN antara tabel `anggota` dan `penjualan`.
-- 2. [KI-BELUM-02]: Rincian nama produk apa saja yang dibeli pada nomor nota tertentu.
--    Alasan: Membutuhkan relasi/JOIN antara `penjualan`, `detail_penjualan`, dan `barang`.
-- Catatan: Kebutuhan informasi di atas ditandai untuk diselesaikan pada 
--          Pertemuan 9-12 (Multi-Table JOIN).
-- =====================================================================