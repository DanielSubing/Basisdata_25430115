-- =====================================================================
-- MILESTONE PROYEK 5: SKRIP DDL LENGKAP TOKO DARING (toko_115)
-- Mahasiswa : Daniel Subing
-- NPM       : 25430115
-- Basis Data: toko_115
-- Deskripsi : Skrip DDL komprehensif yang dapat dieksekusi ulang dari 
--             basis data kosong (idempotent), dilengkapi constraint PK, 
--             FK (ON DELETE/UPDATE), CHECK constraint aturan bisnis (AB), 
--             serta analisis aturan batas P+2.
-- =====================================================================

DROP DATABASE IF EXISTS toko_115;
CREATE DATABASE toko_115 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE toko_115;

-- ---------------------------------------------------------------------
-- 1. TABEL: anggota
-- AB-01: Setiap anggota memiliki identitas unik, kontak nomor HP, dan tgl daftar.
-- ---------------------------------------------------------------------
CREATE TABLE anggota (
    id_anggota VARCHAR(10) NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20) NOT NULL,
    tgl_daftar DATE NOT NULL,
    CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
    CONSTRAINT chk_no_hp_format CHECK (LENGTH(no_hp) >= 10)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. TABEL: barang
-- AB-02: Katalog produk dengan identitas unik, harga jual, stok fisik, 
--        dan stok minimum (stok_min_barang).
-- Constraint CHECK Latihan E.1: stok fisik dan stok minimum tidak boleh negatif.
-- ---------------------------------------------------------------------
CREATE TABLE barang (
    id_barang VARCHAR(10) NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_barang VARCHAR(50) NOT NULL,
    harga_jual DECIMAL(12,2) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    stok_min_barang INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_barang PRIMARY KEY (id_barang),
    CONSTRAINT chk_harga_jual CHECK (harga_jual >= 0),
    CONSTRAINT chk_stok_barang CHECK (stok >= 0),
    CONSTRAINT chk_stok_min_barang CHECK (stok_min_barang >= 0) -- Latihan E.1: stok_min_barang >= 0
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. TABEL: penjualan
-- AB-03: Header transaksi pemesanan barang.
-- Latihan E.2: FK ke anggota menggunakan ON DELETE SET NULL sesuai UU PDP
--              agar data anggota dapat dihapus/dianonimkan tanpa merusak rekaman finansial.
-- ---------------------------------------------------------------------
CREATE TABLE penjualan (
    id_penjualan VARCHAR(20) NOT NULL,
    tgl_penjualan DATE NOT NULL,
    id_anggota VARCHAR(10) NULL, -- Harus NULL agar mendukung ON DELETE SET NULL
    bayar_penjualan DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_penjualan PRIMARY KEY (id_penjualan),
    CONSTRAINT chk_bayar_penjualan CHECK (bayar_penjualan >= 0),
    CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) 
        REFERENCES anggota(id_anggota) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. TABEL: detail_penjualan
-- AB-04: Rincian item per transaksi (Composite PK).
-- Aturan Batas P+2 (Modul 2): Batas pembelian per baris transaksi (misal maksimal 50 qty)
--                             dijaga menggunakan CHECK constraint.
-- ---------------------------------------------------------------------
CREATE TABLE detail_penjualan (
    id_penjualan VARCHAR(20) NOT NULL,
    id_barang VARCHAR(10) NOT NULL,
    qty_detail_penjualan INT NOT NULL,
    harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detail_penjualan PRIMARY KEY (id_penjualan, id_barang),
    CONSTRAINT chk_qty_positif CHECK (qty_detail_penjualan > 0),
    CONSTRAINT chk_qty_batas_p2 CHECK (qty_detail_penjualan <= 50), -- Batas baris tunggal (P+2)
    CONSTRAINT chk_harga_satuan CHECK (harga_satuan_detail_penjualan >= 0),
    CONSTRAINT fk_detail_penjualan_header FOREIGN KEY (id_penjualan) 
        REFERENCES penjualan(id_penjualan) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang) 
        REFERENCES barang(id_barang) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. TABEL: riwayat_poin
-- AB-05: Pencatatan mutasi perolehan atau penggunaan poin loyalitas anggota.
-- ---------------------------------------------------------------------
CREATE TABLE riwayat_poin (
    id_poin VARCHAR(20) NOT NULL,
    id_anggota VARCHAR(10) NOT NULL,
    id_penjualan VARCHAR(20) NULL,
    jumlah_poin INT NOT NULL,
    jenis_transaksi ENUM('dapat', 'pakai') NOT NULL,
    tgl_poin DATETIME NOT NULL,
    CONSTRAINT pk_riwayat_poin PRIMARY KEY (id_poin),
    CONSTRAINT chk_jumlah_poin CHECK (jumlah_poin > 0),
    CONSTRAINT fk_poin_anggota FOREIGN KEY (id_anggota) 
        REFERENCES anggota(id_anggota) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_poin_penjualan FOREIGN KEY (id_penjualan) 
        REFERENCES penjualan(id_penjualan) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- SEED DATA AWAL (UNTUK VALIDASI STRUKTUR & PENGUJIAN)
-- =====================================================================
INSERT INTO anggota (id_anggota, nama_anggota, no_hp, tgl_daftar) VALUES
('A01', 'Daniel Subing', '081234567890', '2026-09-01'),
('A02', 'Ahmad Zidan', '089876543210', '2026-09-15');

INSERT INTO barang (id_barang, nama_barang, kategori_barang, harga_jual, stok, stok_min_barang) VALUES
('B01', 'Kaos Polos', 'Pakaian', 50000.00, 100, 5),
('B02', 'Topi Rimba', 'Aksesoris', 30000.00, 45, 2),
('B03', 'Jaket Parasut', 'Pakaian', 120000.00, 20, 3);

INSERT INTO penjualan (id_penjualan, tgl_penjualan, id_anggota, bayar_penjualan) VALUES
('PJ01', '2026-10-10', 'A01', 130000.00),
('PJ02', '2026-10-11', 'A02', 50000.00);

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan) VALUES
('PJ01', 'B01', 2, 50000.00),
('PJ01', 'B02', 1, 30000.00),
('PJ02', 'B01', 1, 50000.00);

INSERT INTO riwayat_poin (id_poin, id_anggota, id_penjualan, jumlah_poin, jenis_transaksi, tgl_poin) VALUES
('POIN01', 'A01', 'PJ01', 13, 'dapat', '2026-10-10 14:30:00'),
('POIN02', 'A02', 'PJ02', 5, 'dapat', '2026-10-11 10:15:00');