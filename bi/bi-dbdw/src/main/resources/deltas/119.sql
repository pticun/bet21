CREATE TABLE IF NOT EXISTS `MAIL_CAMPAIGNS_SUMMARY` (
  `AUTO_ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `CAMPAIGN` char(4) NOT NULL DEFAULT '',
  `END_SENDING_TS` datetime DEFAULT NULL,
  `SUCCESSES` int(11) DEFAULT NULL,
  `FAILURES` int(11) DEFAULT NULL,
  `EXECUTION_TIME` int(11) DEFAULT NULL,
  PRIMARY KEY (`AUTO_ID`),
  KEY `CAMPAIGN` (`CAMPAIGN`),
  KEY `TIMESTAMP` (`END_SENDING_TS`)
)#

CREATE TABLE IF NOT EXISTS `MAIL_CAMPAIGNS_LOG` (
  `AUTO_ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ACCOUNT_ID` bigint(21) NOT NULL,
  `CAMPAIGN` char(4) NOT NULL DEFAULT '',
  `SEND_TS` datetime NOT NULL,
  `RESULT` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`AUTO_ID`),
  KEY `ACCOUNT_ID` (`ACCOUNT_ID`),
  KEY `SEND_TS` (`SEND_TS`),
  KEY `RESULT` (`RESULT`),
  KEY `CAMPAIGN` (`CAMPAIGN`)
)#
