CREATE TABLE STG_ACCOUNT (
  ACCOUNT_ID DECIMAL(16,2) NOT NULL DISTKEY PRIMARY KEY,
  BALANCE DECIMAL(16,2) NOT NULL SORTKEY
);

GRANT SELECT ON STG_ACCOUNT TO GROUP READ_ONLY;
GRANT ALL ON STG_ACCOUNT TO GROUP READ_WRITE;
GRANT ALL ON STG_ACCOUNT TO GROUP SCHEMA_MANAGER;
