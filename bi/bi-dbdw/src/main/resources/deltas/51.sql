CREATE  TABLE OPERATIONS_USER(
  USERNAME VARCHAR(64) NOT NULL ,
  PASSWD VARCHAR(128) NOT NULL ,
  REAL_NAME VARCHAR(128) NULL ,
  PRIMARY KEY (USERNAME) ,
  UNIQUE INDEX USERNAME_UNIQUE (USERNAME ASC) )#
  
CREATE  TABLE OPERATIONS_ROLE (
  USERNAME VARCHAR(64) NOT NULL ,
  ROLE VARCHAR(32) NOT NULL ,
  PRIMARY KEY (USERNAME, ROLE) )#
  
INSERT INTO OPERATIONS_USER (USERNAME, PASSWD, REAL_NAME) VALUES ('admin', 'd26d0a54cca4cb6036c8abcfeb36d1e4107329c2', 'Administrator')#

INSERT INTO OPERATIONS_ROLE (USERNAME, ROLE) VALUES ('admin', 'ROLE_ROOT')#
INSERT INTO OPERATIONS_ROLE (USERNAME, ROLE) VALUES ('admin', 'ROLE_MARKETING')#
INSERT INTO OPERATIONS_ROLE (USERNAME, ROLE) VALUES ('admin', 'ROLE_MANAGEMENT')#
INSERT INTO OPERATIONS_ROLE (USERNAME, ROLE) VALUES ('admin', 'ROLE_SUPPORT')#
