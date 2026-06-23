-- ====================================================================
-- FUNCTION 1: Calculate a player's total score in a tournament
-- Features used: Explicit Cursor, Exception, Loop, Branching, Record
-- ====================================================================
DROP FUNCTION IF EXISTS fn_calculate_player_score(INT, INT);

CREATE OR REPLACE FUNCTION fn_calculate_player_score(p_player_id INT, p_tourney_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_game_rec RECORD;
    v_total_score NUMERIC := 0.0;
    v_is_registered BOOLEAN;
    
    -- Explicit Cursor with updated JOINs using RoundResult
    c_player_games CURSOR FOR
        SELECT g.white_player_id, g.black_player_id, g.result
        FROM Game g
        JOIN RoundResult rr ON g.game_id = rr.game_id
        JOIN Round r ON rr.round_id = r.round_id
        WHERE r.tournament_id = p_tourney_id 
          AND (g.white_player_id = p_player_id OR g.black_player_id = p_player_id);
BEGIN
    SELECT EXISTS(
        SELECT 1 FROM Registration 
        WHERE player_id = p_player_id AND tournament_id = p_tourney_id
    ) INTO v_is_registered;
    
    IF NOT v_is_registered THEN
        RAISE EXCEPTION 'Player % is not registered for tournament %.', p_player_id, p_tourney_id;
    END IF;

    OPEN c_player_games;
    LOOP
        FETCH c_player_games INTO v_game_rec;
        EXIT WHEN NOT FOUND;

        IF v_game_rec.result = '1/2-1/2' THEN
            v_total_score := v_total_score + 0.5;
        ELSIF v_game_rec.result = '1-0' AND v_game_rec.white_player_id = p_player_id THEN
            v_total_score := v_total_score + 1.0;
        ELSIF v_game_rec.result = '0-1' AND v_game_rec.black_player_id = p_player_id THEN
            v_total_score := v_total_score + 1.0;
        END IF;
    END LOOP;
    CLOSE c_player_games;

    RETURN v_total_score;
END;
$$ LANGUAGE plpgsql;