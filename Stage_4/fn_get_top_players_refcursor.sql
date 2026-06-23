-- ====================================================================
-- FUNCTION 2: Get players above a specific ELO rating
-- Features used: Ref Cursor, Exception, Implicit Branching
-- ====================================================================
DROP FUNCTION IF EXISTS fn_get_top_players(INT);

CREATE OR REPLACE FUNCTION fn_get_top_players(p_min_rating INT)
RETURNS refcursor AS $$
DECLARE
    rc_players refcursor;
BEGIN
    IF p_min_rating < 0 THEN
        RAISE EXCEPTION 'Invalid rating: Minimum rating cannot be negative.';
    END IF;

    OPEN rc_players FOR
        SELECT p.player_id, p.username, p.elo_rating, b.difficulty_level
        FROM Player p
        LEFT JOIN Bot b ON p.bot_id = b.bot_id
        WHERE p.elo_rating >= p_min_rating
        ORDER BY p.elo_rating DESC;

    RETURN rc_players;
END;
$$ LANGUAGE plpgsql;