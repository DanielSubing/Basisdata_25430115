-- ========================================================
-- TUGAS PRAKTIKUM BASIS DATA - MODUL 1
-- Berkas      : p01_lingkungan_25430115.sql
-- Basis Data  : toko_115
-- Karakter    : utf8mb4 / utf8mb4_unicode_ci
-- ========================================================

-- 1. Pembuatan Basis Data Utama (Idempotent)
CREATE DATABASE IF NOT EXISTS toko_115
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 2. Pembuatan Akun Mahasiswa / Pengembang Utama
CREATE USER IF NOT EXISTS 'mhs_115'@'localhost' 
  IDENTIFIED BY 'danielkeren';

GRANT ALL PRIVILEGES ON toko_115.* TO 'mhs_115'@'localhost';

-- 3. Pembuatan Akun Tamu / Pembaca Saja (Latihan E)
CREATE USER IF NOT EXISTS 'tamu_115'@'localhost' 
  IDENTIFIED BY 'danielkeren';

GRANT SELECT ON toko_115.* TO 'tamu_115'@'localhost';

-- 4. Terapkan Hak Akses
FLUSH PRIVILEGES;