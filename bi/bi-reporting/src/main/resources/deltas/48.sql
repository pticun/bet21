CREATE TABLE STG_LEADERBOARD (
  LEADERBOARD_ID DECIMAL(16,2) NOT NULL DISTKEY PRIMARY KEY,
  game_type character varying(255),
  end_ts timestamp without time zone SORTKEY
);

GRANT SELECT ON STG_LEADERBOARD TO GROUP READ_ONLY;
GRANT ALL ON STG_LEADERBOARD TO GROUP READ_WRITE;
GRANT ALL ON STG_LEADERBOARD TO GROUP SCHEMA_MANAGER;