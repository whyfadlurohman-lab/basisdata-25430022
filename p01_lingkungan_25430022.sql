-- p01_lingkungan_25430022.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.
CREATE DATABASE IF NOT EXISTS kopma_022
 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'mhs_022'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_022.* TO 'mhs_022'@'localhost';
CREATE DATABASE IF NOT EXISTS perpus_022
 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'dev_022'@'localhost' IDENTIFIED BY '<password_dev>';
GRANT ALL PRIVILEGES ON perpus_022.* TO 'dev_022'@'localhost';