ALTER TABLE LOBBY_USER ADD COLUMN REGISTRATION_REFERRER VARCHAR(255) DEFAULT NULL AFTER REFERRAL_ID#

CREATE INDEX IDX_LOBBY_USER_REFERRER ON LOBBY_USER(REGISTRATION_REFERRER)#

DROP TRIGGER IF EXISTS ad_tracking_trigger#

RENAME TABLE AD_TRACKING TO AD_TRACKING_OLD#

CREATE VIEW AD_TRACKING AS
    SELECT LU.USER_ID, LU.REGISTRATION_REFERRER AS AD_CODE, LU.TSREG AS REGISTRATION_TS
    FROM LOBBY_USER LU
    WHERE REGISTRATION_REFERRER IS NOT NULL#

UPDATE LOBBY_USER LU, AD_TRACKING_OLD A SET LU.REGISTRATION_REFERRER=A.AD_CODE WHERE LU.USER_ID=A.USER_ID#

DROP TRIGGER IF EXISTS lobby_user_trigger#

CREATE TRIGGER lobby_user_trigger
AFTER INSERT ON LOBBY_USER
FOR EACH ROW
BEGIN
 DECLARE source_val varchar(255) DEFAULT 'Natural';

 SET source_val = IF(NEW.REFERRAL_ID IS NULL,IF(NEW.REGISTRATION_REFERRER IS NULL,'Natural',NEW.REGISTRATION_REFERRER),'Invited');

 REPLACE INTO rpt_account_sources_mv(ACCOUNT_ID,SOURCE,TSCREATED)
  SELECT p.ACCOUNT_ID,
  source_val AS SOURCE,
  NEW.TSREG AS TSCREATED
  FROM strataproddw.PLAYER_DEFINITION p
  WHERE p.PLAYER_ID = NEW.PLAYER_ID;

 INSERT INTO rpt_invites_by_player_and_day(PLAYER_ID,SOURCE,AUDIT_DATE,CREATION_DATE,TOTAL_SENT)
  VALUES(NEW.PLAYER_ID,source_val,IFNULL(NEW.TSREG,'2009-07-01'),NEW.TSREG,0)
  ON DUPLICATE KEY UPDATE SOURCE = source_val;
END
#

DROP TRIGGER IF EXISTS player_definition_trigger#

CREATE TRIGGER player_definition_trigger
AFTER INSERT ON PLAYER_DEFINITION
FOR EACH ROW
BEGIN
 DECLARE source_val varchar(255) DEFAULT 'Natural';
 SELECT
  IF(l.REFERRAL_ID IS NULL,IF(l.REGISTRATION_REFERRER IS NULL,'Natural',l.REGISTRATION_REFERRER),'Invited') AS SOURCE
  INTO source_val
  FROM strataproddw.LOBBY_USER l
  WHERE l.PLAYER_ID = NEW.PLAYER_ID;

 IF NEW.ACCOUNT_ID IS NOT NULL THEN
  REPLACE INTO rpt_account_sources_mv(ACCOUNT_ID,SOURCE,TSCREATED)
   VALUES(NEW.ACCOUNT_ID,source_val,NEW.TSCREATED);
 END IF;

 INSERT IGNORE INTO rpt_invites_by_player_and_day(PLAYER_ID,SOURCE,AUDIT_DATE,CREATION_DATE,TOTAL_SENT)
  VALUES(NEW.PLAYER_ID,source_val,NEW.TSCREATED,NEW.TSCREATED,0);
END
#
