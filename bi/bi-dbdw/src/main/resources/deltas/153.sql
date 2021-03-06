
CREATE TABLE IF NOT EXISTS FACEBOOK_AD_STATS (
  TRACKING_DATE DATE NOT NULL,
  SOURCE VARCHAR(255) NOT NULL,
  CLICKS int(11) NOT NULL DEFAULT 0,
  IMPRESSIONS int(11) NOT NULL DEFAULT 0,
  SPENT bigint(21) NOT NULL DEFAULT 0,
  PRIMARY KEY (TRACKING_DATE,SOURCE)
)#

DROP VIEW IF EXISTS rpt_registrations_per_source_and_day#
CREATE TABLE IF NOT EXISTS rpt_registrations_per_source_and_day (
	TRACKING_DATE DATE NOT NULL,	
	SOURCE VARCHAR(255) NOT NULL,
	REGISTRATIONS INT(11),
	PRIMARY KEY (TRACKING_DATE,SOURCE)
)#

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
  
 IF NEW.TSREG IS NOT NULL THEN
 	INSERT INTO rpt_registrations_per_source_and_day(TRACKING_DATE,SOURCE,REGISTRATIONS)
 		VALUES(DATE(NEW.TSREG),source_val,1)
 		ON DUPLICATE KEY UPDATE REGISTRATIONS = REGISTRATIONS + 1;
 END IF;
END
#
