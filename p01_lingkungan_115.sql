-- Konfigurasi Lingkungan Basis Data - Modul 1
-- Pengembang: Daniel Subing (25430115)

CREATE DATABASE IF NOT EXISTS toko_115 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_115'@'localhost' 
  IDENTIFIED BY 'danielkeren';

GRANT ALL PRIVILEGES ON toko_115.* TO 'mhs_115'@'localhost';
FLUSH PRIVILEGES;