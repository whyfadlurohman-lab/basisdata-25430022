-- p01_lingkungan_25430022.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.
CREATE DATABASE kopma_022
 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mhs_022'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_022.* TO 'mhs_022'@'localhost';