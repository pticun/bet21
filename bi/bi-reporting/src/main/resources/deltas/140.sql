-- WEB-4513, WEB-4569 - fix account precision

drop view registrations;
drop view player;

alter table account alter column balance type numeric(64,4);

CREATE OR REPLACE VIEW player AS
  SELECT
    P.PLAYER_ID AS PLAYER_ID,
    P.ACCOUNT_ID AS ACCOUNT_ID,
    A.balance,
    P.CREATED_TS AS registration_date,
    ref.registration_platform,
    ref.registration_game_type,
    U.picture_location,
    U.country
  FROM PLAYER_DEFINITION P LEFT join LOBBY_USER U on P.PLAYER_ID = U.PLAYER_ID
    LEFT JOIN ACCOUNT A on A.account_id = P.account_id
    LEFT JOIN PLAYER_REFERRER ref on ref.player_id = p.player_id;

GRANT SELECT ON PLAYER TO GROUP READ_ONLY;
GRANT ALL ON PLAYER TO GROUP READ_WRITE;
GRANT ALL ON PLAYER TO GROUP SCHEMA_MANAGER;

create OR REPLACE view registrations as
  select
    registration_date::date,
    registration_platform,
    count(1) num_registrations
  from player
  group by 1, 2;

GRANT SELECT ON registrations TO GROUP READ_ONLY;
GRANT ALL ON registrations TO GROUP READ_WRITE;
GRANT ALL ON registrations TO GROUP SCHEMA_MANAGER;
