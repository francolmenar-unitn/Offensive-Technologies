DELETE FROM users WHERE user="jelena";
DELETE FROM users WHERE user="kate";
DELETE FROM users WHERE user="john";

DELETE FROM transfers WHERE user="jelena";
DELETE FROM transfers WHERE user="kate";
DELETE FROM transfers WHERE user="john";

ALTER TABLE ctf2.users ENGINE=InnoDB;
ALTER TABLE ctf2.transfers ENGINE=InnoDB;
ALTER TABLE ctf2.transfers ADD CONSTRAINT fk_users FOREIGN KEY (user) REFERENCES ctf2.users(user);
ALTER TABLE ctf2.users MODIFY pass VARCHAR(100);
ALTER TABLE ctf2.users MODIFY pass VARCHAR(100) NOT NULL;
