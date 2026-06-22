-- ====================================================================
-- INTEGRATION SCRIPT: Linking external Players to internal Bots V2
-- ====================================================================

-- Step 1: Alter the Player table to support Bot assignment (1:1 Relationship)
ALTER TABLE Player 
ADD COLUMN bot_id INT UNIQUE;

-- Step 2: Enforce Referential Integrity
ALTER TABLE Player 
ADD CONSTRAINT fk_player_bot 
FOREIGN KEY (bot_id) REFERENCES Bot(bot_id) 
ON DELETE SET NULL;

-- Step 3: Data Integration (Insert existing Bots as New Players)
INSERT INTO Player (player_id, username, bot_id)
SELECT 
    500 + row_number() OVER (ORDER BY bot_id) AS generated_player_id,
    display_name || ' (AI)',
    bot_id
FROM Bot
WHERE difficulty_level >= 8;

-- Step 4: Register Bots across multiple tournaments dynamically (IDs 1, 2, 3)
INSERT INTO Registration (reg_id, tournament_id, player_id, registered_date, status)
SELECT 
    5000 + row_number() OVER (ORDER BY player_id) AS generated_reg_id,
    ((row_number() OVER (ORDER BY player_id)) % 3) + 1 AS assigned_tournament,
    player_id,
    CURRENT_DATE,
    'Confirmed'
FROM Player
WHERE bot_id IS NOT NULL;