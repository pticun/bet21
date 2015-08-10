-- WEB-4173 - drop MAXIMILES_ID (aka USER_ID, aka PLAYER_PROFILE_ID)

ALTER TABLE rpt_recent_registrations ADD COLUMN PLAYER_ID BIGINT(11) NULL#

UPDATE rpt_recent_registrations rrr, LOBBY_USER_INFO lui SET rrr.PLAYER_ID=lui.PLAYER_ID WHERE rrr.USER_ID=lui.USER_ID#

ALTER TABLE rpt_recent_registrations CHANGE PLAYER_ID PLAYER_ID  BIGINT(11) NOT NULL#

ALTER TABLE LOBBY_USER_INFO
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (PLAYER_ID)#

ALTER TABLE LOBBY_USER_INFO
  DROP COLUMN USER_ID#

-- These apparently should have gone in delta 187...
DROP FUNCTION IF EXISTS find_external_id_for_provider#
DROP FUNCTION IF EXISTS isMemberOfControlGroup#


DROP VIEW IF EXISTS LOBBY_USER#
CREATE VIEW LOBBY_USER
AS SELECT
   LOBBY_USER_INFO.PLAYER_ID AS PLAYER_ID,
   LOBBY_USER_INFO.TSREG AS TSREG,
   LOBBY_USER_INFO.DISPLAY_NAME AS DISPLAY_NAME,
   LOBBY_USER_INFO.REAL_NAME AS REAL_NAME,
   LOBBY_USER_INFO.FIRST_NAME AS FIRST_NAME,
   LOBBY_USER_INFO.PICTURE_LOCATION AS PICTURE_LOCATION,
   LOBBY_USER_INFO.EMAIL_ADDRESS AS EMAIL_ADDRESS,
   LOBBY_USER_INFO.COUNTRY AS COUNTRY,
   LOBBY_USER_INFO.EXTERNAL_ID AS EXTERNAL_ID,
   LOBBY_USER_INFO.PROVIDER_NAME AS PROVIDER_NAME,
   LOBBY_USER_INFO.RPX_PROVIDER AS RPX_PROVIDER,
   LOBBY_USER_INFO.BLOCKED AS BLOCKED,
   LOBBY_USER_INFO.DATE_OF_BIRTH AS DATE_OF_BIRTH,
   LOBBY_USER_INFO.GENDER AS GENDER,
   LOBBY_USER_INFO.REFERRAL_ID AS REFERRAL_ID,
   LOBBY_USER_INFO.VERIFICATION_IDENTIFIER AS VERIFICATION_IDENTIFIER,
   PLAYER_REFERRER.REGISTRATION_REFERRER AS REGISTRATION_REFERRER,
   PLAYER_REFERRER.REGISTRATION_PLATFORM AS REGISTRATION_PLATFORM,
   PLAYER_REFERRER.REGISTRATION_GAME_TYPE AS REGISTRATION_GAME_TYPE
FROM (LOBBY_USER_INFO left join PLAYER_REFERRER on((PLAYER_REFERRER.PLAYER_ID = LOBBY_USER_INFO.PLAYER_ID)))#

DROP PROCEDURE IF EXISTS account_inserts#
CREATE PROCEDURE `account_inserts`(IN account_id_val INT(11), IN tsstarted_val DATETIME, IN platform_val VARCHAR(64), IN start_page_val VARCHAR(2048), IN referer_val VARCHAR(2048))
BEGIN
    DECLARE player_id_val BIGINT(20) DEFAULT 0;
    declare maxPlayerId BIGINT(20) DEFAULT 0;

    SELECT MAX(PLAYER_ID) INTO @maxPlayerId FROM rpt_recent_registrations;

    IF NOT @maxPlayerId IS NULL THEN
        INSERT IGNORE INTO rpt_recent_registrations(PLAYER_ID,AUDIT_TIME,RPX,EXTERNAL_ID,ACCOUNT_ID,FIRST_NAME)
        SELECT lu.PLAYER_ID,lu.TSREG,lu.PROVIDER_NAME,IF(lu.PROVIDER_NAME='YAZINO',lu.PLAYER_ID,lu.EXTERNAL_ID),pd.ACCOUNT_ID,lu.FIRST_NAME
            FROM LOBBY_USER lu
            JOIN PLAYER_DEFINITION pd USING (PLAYER_ID)
            WHERE lu.PLAYER_ID > @maxPlayerId;
     ELSE
         INSERT IGNORE INTO rpt_recent_registrations(PLAYER_ID,AUDIT_TIME,RPX,EXTERNAL_ID,ACCOUNT_ID,FIRST_NAME)
         SELECT lu.PLAYER_ID,lu.TSREG,lu.PROVIDER_NAME,IF(lu.PROVIDER_NAME='YAZINO',lu.PLAYER_ID,lu.EXTERNAL_ID),pd.ACCOUNT_ID,lu.FIRST_NAME
             FROM LOBBY_USER lu
             JOIN PLAYER_DEFINITION pd USING (PLAYER_ID)
             WHERE lu.TSREG > now() - INTERVAL 98 HOUR;
    END IF;

   SELECT PLAYER_ID INTO player_id_val
   FROM PLAYER_DEFINITION WHERE ACCOUNT_ID = account_id_val;

   UPDATE rpt_recent_registrations SET PLATFORM = platform_val, START_PAGE = start_page_val WHERE PLAYER_ID = player_id_val AND PLATFORM = '';

     INSERT INTO PLAYER_ACCOUNT_INFO(ACCOUNT_ID, REGISTRATION_PLATFORM)
      VALUES (account_id_val,platform_val)
      ON DUPLICATE KEY
      UPDATE REGISTRATION_PLATFORM =
        IF(REGISTRATION_PLATFORM IS NULL,VALUES(REGISTRATION_PLATFORM),REGISTRATION_PLATFORM);

     INSERT IGNORE INTO rpt_players_by_platform_and_time(ACCOUNT_ID,PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM)
     	VALUES(account_id_val,'day',DATE(tsstarted_val),'#','*');
     INSERT IGNORE INTO rpt_players_by_platform_and_time(ACCOUNT_ID,PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM)
     	VALUES(account_id_val,'day',DATE(tsstarted_val),'#',platform_val);
     INSERT IGNORE INTO rpt_players_by_platform_and_time(ACCOUNT_ID,PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM)
     	VALUES(account_id_val,'week',last_day_of_week(tsstarted_val),'#','*');
     INSERT IGNORE INTO rpt_players_by_platform_and_time(ACCOUNT_ID,PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM)
     	VALUES(account_id_val,'week',last_day_of_week(tsstarted_val),'#',platform_val);
     INSERT IGNORE INTO rpt_players_by_platform_and_time(ACCOUNT_ID,PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM)
     	VALUES(account_id_val,'mon',last_day(tsstarted_val),'#','*');
     INSERT IGNORE INTO rpt_players_by_platform_and_time(ACCOUNT_ID,PERIOD,AUDIT_DATE,GAME_TYPE,PLATFORM)
     	VALUES(account_id_val,'mon',last_day(tsstarted_val),'#',platform_val);
END#

DROP VIEW IF EXISTS PLAYER#
CREATE VIEW PLAYER
AS SELECT
   U.PLAYER_ID AS PLAYER_ID,
   P.ACCOUNT_ID AS ACCOUNT_ID,
   P.TSCREATED AS TSCREATED,
   P.IS_INSIDER AS IS_INSIDER,
   U.PICTURE_LOCATION AS PICTURE_LOCATION
FROM (PLAYER_DEFINITION P join LOBBY_USER U on((P.PLAYER_ID = U.PLAYER_ID)))#

DROP VIEW IF EXISTS AD_TRACKING#
CREATE VIEW AD_TRACKING
AS SELECT
   LU.PLAYER_ID AS PLAYER_ID,
   LU.REGISTRATION_REFERRER AS AD_CODE,
   LU.TSREG AS REGISTRATION_TS
FROM LOBBY_USER LU where (LU.REGISTRATION_REFERRER is not null)#

DROP VIEW IF EXISTS rpt_player_sources#
CREATE VIEW rpt_player_sources
AS SELECT
   p.PLAYER_ID AS PLAYER_ID,
   (case when isnull(at.AD_CODE) then convert((case when isnull(lu.REFERRAL_ID) then 'Natural' else 'Invited' end) using latin1) else at.AD_CODE end) AS SOURCE,
   p.ACCOUNT_ID AS ACCOUNT_ID,
   p.TSCREATED AS TSCREATED
FROM ((PLAYER p join LOBBY_USER lu on((p.PLAYER_ID = lu.PLAYER_ID))) left join AD_TRACKING at on((p.PLAYER_ID = at.PLAYER_ID))) order by p.PLAYER_ID desc#

DROP VIEW IF EXISTS rpt_player_sources_mv#
CREATE VIEW rpt_player_sources_mv
AS SELECT
   p.PLAYER_ID AS PLAYER_ID,
   r.SOURCE AS SOURCE,
   r.TSCREATED AS TSCREATED
FROM rpt_account_sources_mv r join PLAYER_DEFINITION p on (r.ACCOUNT_ID = p.ACCOUNT_ID)#
