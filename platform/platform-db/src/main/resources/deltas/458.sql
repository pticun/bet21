-- Disable HISSTERIA and BINGO

UPDATE GAME_CONFIGURATION SET ENABLED=0 WHERE GAME_ID IN ('BINGO', 'HISSTERIA')#
