ALTER TABLE kisakonetesti_Player ADD pdga_rating INT NOT NULL DEFAULT 0 AFTER pdga;
ALTER TABLE kisakonetesti_Player ADD pdga_status ENUM('amateur','professional') NOT NULL DEFAULT 'amateur' AFTER pdga_rating;
