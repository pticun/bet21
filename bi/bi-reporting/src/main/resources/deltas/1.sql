CREATE TABLE ACCOUNT (
  ACCOUNT_ID DECIMAL(16,2) NOT NULL DISTKEY PRIMARY KEY,
  BALANCE DECIMAL(16,2) NOT NULL SORTKEY
)
;
GRANT SELECT ON ACCOUNT TO GROUP READ_ONLY;
GRANT ALL ON ACCOUNT TO GROUP READ_WRITE;
GRANT ALL ON ACCOUNT TO GROUP SCHEMA_MANAGER;
