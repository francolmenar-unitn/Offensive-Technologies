CREATE USER 'webapp'@'localhost' IDENTIFIED WITH mysql_native_password BY 'thisisaverysecurepassword2020';
GRANT SELECT ON ctf2.users TO 'webapp'@'localhost';
GRANT SELECT ON ctf2.transfers TO 'webapp'@'localhost';
GRANT INSERT ON ctf2.users TO 'webapp'@'localhost';
GRANT INSERT ON ctf2.transfers TO 'webapp'@'localhost';