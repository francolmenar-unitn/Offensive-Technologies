DROP USER 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY 'iamrootbitch1984';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;