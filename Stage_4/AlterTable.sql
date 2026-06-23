-- ====================================================================
-- ALTER TABLE SCRIPT (Phase 4)
-- ====================================================================

-- Add ELO rating and total games counter to Player
ALTER TABLE Player 
ADD COLUMN elo_rating INT DEFAULT 1200;

ALTER TABLE Player 
ADD COLUMN total_games_played INT DEFAULT 0;

-- Add tournament status (e.g., 'Open', 'In Progress', 'Completed')
ALTER TABLE Tournament 
ADD COLUMN status VARCHAR(20) DEFAULT 'Open';