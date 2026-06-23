-- ====================================================================
-- PROCEDURE 2: Promote active players and bots
-- Features: DML (UPDATE), Explicit Cursor, Loop, Branching (IF/ELSE)
-- ====================================================================
CREATE OR REPLACE PROCEDURE pr_promote_active_players(p_min_games INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_player_rec RECORD;
    
    c_active_players CURSOR FOR
        SELECT player_id, elo_rating, bot_id
        FROM Player
        WHERE total_games_played >= p_min_games;
BEGIN
    OPEN c_active_players;
    LOOP
        FETCH c_active_players INTO v_player_rec;
        EXIT WHEN NOT FOUND;

        IF v_player_rec.bot_id IS NOT NULL THEN
            UPDATE Bot
            SET difficulty_level = LEAST(difficulty_level + 1, 10)
            WHERE bot_id = v_player_rec.bot_id;
        ELSE
            UPDATE Player
            SET elo_rating = elo_rating + 50
            WHERE player_id = v_player_rec.player_id;
        END IF;
    END LOOP;
    CLOSE c_active_players;
END;
$$;