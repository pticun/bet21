-- WEB-4273 - add guest status column to LOBBY_USER

ALTER TABLE LOBBY_USER ADD COLUMN `GUEST_STATUS` varchar(1) NOT NULL DEFAULT 'N'#
