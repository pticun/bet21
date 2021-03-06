-- WEB-4274 - add forex, payment option details to external transactions


ALTER TABLE EXTERNAL_TRANSACTION ADD COLUMN PAYMENT_OPTION_ID VARCHAR(128);
ALTER TABLE EXTERNAL_TRANSACTION ADD COLUMN BASE_CURRENCY_AMOUNT NUMERIC(32,4);
ALTER TABLE EXTERNAL_TRANSACTION ADD COLUMN BASE_CURRENCY_CODE VARCHAR(3);
ALTER TABLE EXTERNAL_TRANSACTION ADD COLUMN EXCHANGE_RATE NUMERIC(12,6);
