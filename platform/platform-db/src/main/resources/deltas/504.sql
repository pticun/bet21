-- WEB-4652 - XP changes for new Blackjack client

# DELIMITER #

DELETE FROM LEVEL_SYSTEM WHERE GAME_TYPE='BINGO'#
DELETE FROM LEVEL_SYSTEM WHERE GAME_TYPE='HISSTERIA'#

UPDATE LEVEL_SYSTEM SET EXPERIENCE_FACTORS='XP_PLAY	2\nXP_WIN	4\nXP_PLAY_WITH_PEOPLE	0\n' WHERE GAME_TYPE = 'BLACKJACK'#