-- WEB-4326 - added Player ID, Promo ID PAYMENT_SETTLEMENT

ALTER TABLE PAYMENT_SETTLEMENT
    ADD COLUMN PLAYER_ID DECIMAL(16,2) NOT NULL,
    ADD COLUMN PROMO_ID INT(11)#
