-- WEB-2347 - Add VERIFICATION_IDENTIFIER to LOBBY_USER

ALTER TABLE LOBBY_USER ADD COLUMN VERIFICATION_IDENTIFIER VARCHAR(36) DEFAULT NULL#