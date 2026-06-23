-- ====================================================================
-- MAIN PROGRAM 1: Tournament Processing
-- Calls: fn_calculate_player_score (Function) & pr_close_tournament (Procedure)
-- ====================================================================
DO $$
DECLARE
    v_player_score NUMERIC;
BEGIN
    -- 1. Test the function (Calculate score for a specific player in tournament 1)
    -- Note: Ensure player_id 501 exists and is registered in tournament 1
    v_player_score := fn_calculate_player_score(501, 1);
    RAISE NOTICE 'Player 501 achieved a total score of % in Tournament 1', v_player_score;

    -- 2. Test the procedure (Close tournament 1 and update player stats)
    CALL pr_close_tournament(1);
    RAISE NOTICE 'Tournament 1 has been successfully closed and player stats updated.';
END;
$$;