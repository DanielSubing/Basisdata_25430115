-- ========================================================
-- TUGAS PRAKTIKUM BASIS DATA - MODUL 1
-- Berkas      : p01_lingkungan_25430115.sql
-- Basis Data  : toko_115
-- ========================================================

-- 1. Buat database utama
CREATE DATABASE IF NOT EXISTS toko_115
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 2. Buat akun utama (hak akses penuh ke toko_115)
CREATE USER IF NOT EXISTS 'mhs_115'@'localhost' 
  IDENTIFIED BY 'danielkeren';

GRANT ALL PRIVILEGES ON toko_115.* TO 'mhs_115'@'localhost';

-- 3. Buat akun tamu (cuma bisa lihat/SELECT saja)
CREATE USER IF NOT EXISTS 'tamu_115'@'localhost' 
  IDENTIFIED BY 'danielkeren';

GRANT SELECT ON toko_115.* TO 'tamu_115'@'localhost';

-- 4. Simpan perubahan hak akses
FLUSH PRIVILEGES;