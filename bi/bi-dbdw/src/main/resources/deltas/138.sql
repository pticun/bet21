-- WEB-2843 - copy REGISTRATION_PLATFORM to LOBBY_USER

UPDATE LOBBY_USER LU,
       PLAYER_DEFINITION PD,
       PLAYER_ACCOUNT_INFO PAI
   SET LU.REGISTRATION_PLATFORM=PAI.REGISTRATION_PLATFORM
 WHERE PAI.ACCOUNT_ID=PD.ACCOUNT_ID
   AND LU.PLAYER_ID=PD.PLAYER_ID#
