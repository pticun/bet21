
-- Table: PLAYER_REFERRER --- get rid of this? put it into LOBBY_USER
CREATE TABLE PLAYER_REFERRER (
  PLAYER_ID DECIMAL(16,2) NOT NULL DISTKEY SORTKEY PRIMARY KEY,
  REGISTRATION_REFERRER character varying(255),
  REGISTRATION_PLATFORM character varying(32),
  REGISTRATION_GAME_TYPE character varying(32)
)
;
GRANT SELECT ON PLAYER_REFERRER TO GROUP READ_ONLY;
GRANT ALL ON PLAYER_REFERRER TO GROUP READ_WRITE;
GRANT ALL ON PLAYER_REFERRER TO GROUP SCHEMA_MANAGER;
