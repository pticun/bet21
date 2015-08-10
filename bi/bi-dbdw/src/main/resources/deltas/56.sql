CREATE TABLE PROGRESS_BAR (
  PLAYER_ID bigint(20) unsigned NOT NULL,
  FACEBOOK_LIKE tinyint(1) unsigned NOT NULL DEFAULT '0',
  ACCEPTED_INVITES int(11) unsigned NOT NULL DEFAULT '0',
  BONUS_ISSUED tinyint(1) unsigned NOT NULL DEFAULT '0',
  BONUS_NOTIFIED tinyint(1) unsigned NOT NULL DEFAULT '0',
  BONUS_CHIP_AMOUNT int(11) unsigned NOT NULL DEFAULT '0',
  REVIEWS text,
  PRIMARY KEY (PLAYER_ID)
) ENGINE=InnoDB DEFAULT CHARSET=ascii#