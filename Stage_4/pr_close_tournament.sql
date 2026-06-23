-- ====================================================================
-- PROCEDURE 1: Close tournament and update player stats
-- Features: DML (UPDATE), Exception, Explicit Cursor, Loop
-- ====================================================================
CREATE OR REPLACE PROCEDURE pr_close_tournament(p_tourney_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(20);
    v_player_rec RECORD;
    
    -- Cursor with updated JOINs using RoundResult
    c_players CURSOR FOR
        SELECT DISTINCT player_id 
        FROM (
            SELECT g.white_player_id AS player_id
            FROM Game g 
            JOIN RoundResult rr ON g.game_id = rr.game_id
            JOIN Round r ON rr.round_id = r.round_id
            WHERE r.tournament_id = p_tourney_id
            UNION
            SELECT g.black_player_id AS player_id
            FROM Game g 
            JOIN RoundResult rr ON g.game_id = rr.game_id
            JOIN Round r ON rr.round_id = r.round_id
            WHERE r.tournament_id = p_tourney_id
        ) AS participants;
BEGIN
    SELECT status INTO v_status FROM Tournament WHERE tournament_id = p_tourney_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tournament ID % does not exist.', p_tourney_id;
    END IF;

    IF v_status = 'Completed' THEN
        RAISE EXCEPTION 'Tournament ID % is already closed.', p_tourney_id;
    END IF;

    UPDATE Tournament 
    SET status = 'Completed' 
    WHERE tournament_id = p_tourney_id;

    OPEN c_players;
    LOOP
        FETCH c_players INTO v_player_rec;
        EXIT WHEN NOT FOUND;

        UPDATE Player
        SET total_games_played = total_games_played + 1
        WHERE player_id = v_player_rec.player_id;
    END LOOP;
    CLOSE c_players;
END;
$$;