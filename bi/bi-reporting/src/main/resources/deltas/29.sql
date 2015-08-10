CREATE VIEW LAST_PLAYED_UNIQUE AS
 SELECT PLAYER_ID,MAX(LAST_PLAYED) AS LAST_PLAYED FROM LAST_PLAYED  GROUP BY PLAYER_ID;

 GRANT SELECT ON LAST_PLAYED_UNIQUE TO GROUP READ_ONLY;
 GRANT ALL ON LAST_PLAYED_UNIQUE TO GROUP READ_WRITE;
 GRANT ALL ON LAST_PLAYED_UNIQUE TO GROUP SCHEMA_MANAGER;
