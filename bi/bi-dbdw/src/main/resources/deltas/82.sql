CREATE TABLE IF NOT EXISTS rpt_promotion_summary (
  PROMO_ID int(11) NOT NULL,
  TYPE varchar(30) DEFAULT NULL,
  NAME varchar(255) NOT NULL,
  ALL_PLAYERS tinyint(1) NOT NULL DEFAULT '0',
  START_DATE datetime NOT NULL,
  END_DATE datetime NOT NULL,
  TARGET_COUNT int(11) NOT NULL,
  CONTROL_GROUP_COUNT int(11) NOT NULL,
  PRIMARY KEY (PROMO_ID)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8#


CREATE TABLE IF NOT EXISTS `rpt_promotion_transaction` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EXTERNAL_TRANSACTION_ID` int(11) NOT NULL,
  `PROMO_ID` int(11) NOT NULL,
  `PLAYER_ID` int(11) NOT NULL,
  `ACCOUNT_ID` int(11) NOT NULL,
  `CONTROL_GROUP` tinyint(1) NOT NULL DEFAULT '0',
  `PAYMENT_TIMESTAMP` datetime NOT NULL,
  `AMOUNT` decimal(64,4) NOT NULL,
  `CURRENCY_CODE` varchar(3) NOT NULL,
  `AMOUNT_CHIPS` decimal(64,4) NOT NULL DEFAULT '0.0000',

  PRIMARY KEY (`ID`),
  KEY `idx_promo_timestamp_promo` (`PAYMENT_TIMESTAMP`,`PROMO_ID`),
  KEY `idx_promo_external_transaction` (`EXTERNAL_TRANSACTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8#

