DROP TABLE IF EXISTS AD_TRACKING#

CREATE TABLE `AD_TRACKING` (
  `USER_ID` bigint(20) NOT NULL,
  `AD_CODE` varchar(255) DEFAULT NULL,
  `REGISTRATION_TS` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8#

DROP VIEW IF EXISTS PLAYER_PURCHASES#

-- Commented out by jshiell, 21/4/11 - this no longer applies to a clean schema due to strataprod.* changes.
-- CREATE VIEW PLAYER_PURCHASES AS
--   SELECT P.PLAYER_ID, P.USER_ID, ET.AUTO_ID, ET.MESSAGE_TIMESTAMP, (ET.CURRENCY_CODE='USD')*ET.AMOUNT AS USD, (ET.CURRENCY_CODE='EUR')*ET.AMOUNT AS EUR, (ET.CURRENCY_CODE='GBP')*ET.AMOUNT AS GBP
--  FROM strataprod.EXTERNAL_TRANSACTION ET, strataprod.PLAYER P WHERE ET.ACCOUNT_ID=P.ACCOUNT_ID AND EXTERNAL_TRANSACTION_STATUS='SUCCESS'#