CREATE USER 'anon'@'localhost' IDENTIFIED BY 'thisisaverysecurepasswordbitch2020';
GRANT SELECT ON ctf2.users TO 'anon'@'localhost';
GRANT SELECT ON ctf2.transfers TO 'anon'@'localhost';
GRANT UPDATE ON ctf2.users TO 'anon'@'localhost';
GRANT UPDATE ON ctf2.transfers TO 'anon'@'localhost';
GRANT INSERT ON ctf2.users TO 'anon'@'localhost';
GRANT INSERT ON ctf2.transfers TO 'anon'@'localhost';