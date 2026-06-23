-- ====================================================================
-- MAIN PROGRAM 2: Player Promotion and Fetching
-- Calls: pr_promote_active_players (Procedure) & fn_get_top_players (RefCursor Function)
-- ====================================================================
DO $$
DECLARE
    v_cursor refcursor;
    v_record RECORD;
BEGIN
    -- 1. Test the procedure (Promote players with at least 1 game)
    CALL pr_promote_active_players(1);
    RAISE NOTICE 'Active players and bots have been promoted successfully.';

    -- 2. Test the refcursor function (Get players with rating >= 1200)
    v_cursor := fn_get_top_players(1200);
    
    RAISE NOTICE '--- Top Players List ---';
    LOOP
        FETCH v_cursor INTO v_record;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Player: %, ELO: %', v_record.username, v_record.elo_rating;
    END LOOP;
    
    CLOSE v_cursor;
END;
$$;