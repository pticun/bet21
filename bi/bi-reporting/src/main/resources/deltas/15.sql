-- Table: TOURNAMENT
CREATE TABLE TOURNAMENT (
  TOURNAMENT_ID DECIMAL(16,2) NOT NULL DISTKEY PRIMARY KEY,
  TOURNAMENT_START_TS timestamp without time zone DEFAULT SYSDATE NOT NULL SORTKEY,
  TOURNAMENT_VARIATION_TEMPLATE_ID bigint NOT NULL
)
;
GRANT SELECT ON TOURNAMENT TO GROUP READ_ONLY;
GRANT ALL ON TOURNAMENT TO GROUP READ_WRITE;
GRANT ALL ON TOURNAMENT TO GROUP SCHEMA_MANAGER;

