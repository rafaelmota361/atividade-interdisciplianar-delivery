CREATE USER IF NOT EXISTS 'delivery'@'localhost' IDENTIFIED BY 'rafael0712';
ALTER USER 'delivery'@'localhost' IDENTIFIED BY 'rafael0712';
GRANT ALL PRIVILEGES ON delivery_italiano.* TO 'delivery'@'localhost';
FLUSH PRIVILEGES;

SELECT user, host FROM mysql.user WHERE user = 'delivery';

