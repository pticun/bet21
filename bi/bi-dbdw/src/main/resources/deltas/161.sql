DROP TRIGGER IF EXISTS players_by_platform_and_time_trigger#
CREATE TRIGGER players_by_platform_and_time_trigger
AFTER INSERT ON rpt_players_by_platform_and_time
FOR EACH ROW
BEGIN
  DECLARE source_val varchar(255) DEFAULT '';
  
  SELECT s.SOURCE into source_val
		FROM rpt_account_sources_mv s
		WHERE s.ACCOUNT_ID = NEW.ACCOUNT_ID;

  INSERT INTO rpt_players_by_platform_and_time_count(PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM,PLAYERS,SOURCE)
  	VALUES(NEW.PERIOD,NEW.AUDIT_DATE,NEW.GAME_TYPE,
  		IF(NEW.PLATFORM = '*' , '*', IF(NEW.PLATFORM = 'IOS','iOS',IF(NEW.PLATFORM = 'ANDROID', 'Android', 'Web'))),1,IFNULL(source_val,'Natural'))
  	ON DUPLICATE KEY
	  	UPDATE PLAYERS = PLAYERS+1;
END
#
