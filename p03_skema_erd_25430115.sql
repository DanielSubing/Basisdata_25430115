-- DDL Basis Data toko_115
-- Proyek Toko Daring - Penjualan & Poin Loyalitas

CREATE TABLE anggota (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(20)
);

CREATE TABLE barang (
    id_barang INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    harga DECIMAL(12, 2) NOT NULL,
    stok INT NOT NULL DEFAULT 0
);

CREATE TABLE penjualan (
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    id_anggota INT NOT NULL,
    tanggal_transaksi DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_harga DECIMAL(12, 2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_penjualan_anggota 
        FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE detail_penjualan (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    jumlah INT NOT NULL,
    harga_satuan DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_detail_penjualan 
        FOREIGN KEY (id_penjualan) REFERENCES penjualan(id_penjualan) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detail_barang 
        FOREIGN KEY (id_barang) REFERENCES barang(id_barang) 
        ON UPDATE CASCADE
);

CREATE TABLE riwayat_poin (
    id_riwayat INT AUTO_INCREMENT PRIMARY KEY,
    id_anggota INT NOT NULL,
    id_penjualan INT NOT NULL,
    jumlah_poin INT NOT NULL,
    jenis_mutasi VARCHAR(20) NOT NULL,
    tanggal DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_poin_anggota 
        FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_poin_penjualan 
        FOREIGN KEY (id_penjualan) REFERENCES penjualan(id_penjualan) 
        ON DELETE CASCADE ON UPDATE CASCADE
);