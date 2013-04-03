ALTER TABLE kisakonetesti_Player ADD pdga_rating INT NOT NULL DEFAULT 0;
ALTER TABLE kisakonetesti_Player ADD pdga_previous_rating INT NOT NULL DEFAULT 0;
ALTER TABLE kisakonetesti_Player ADD pdga_status ENUM('amateur','professional') NOT NULL DEFAULT 'amateur';
