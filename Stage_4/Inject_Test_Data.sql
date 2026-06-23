-- ====================================================================
-- HELPER SCRIPT: Inject dummy data to test the Functions/Procedures
-- ====================================================================

UPDATE Tournament SET status = 'Open' WHERE tournament_id = 1;

INSERT INTO Registration (reg_id, tournament_id, player_id, registered_date, status)
VALUES (9999, 1, 501, CURRENT_DATE, 'Confirmed')
ON CONFLICT (reg_id) DO NOTHING;

INSERT INTO Round (round_id, tournament_id, round_number, scheduled_date)
VALUES (9999, 1, 1, CURRENT_DATE)
ON CONFLICT (round_id) DO NOTHING;

INSERT INTO Game (game_id, white_player_id, black_player_id, tc_id, variant_id, result, start_date)
VALUES (9999, 501, 502, 1, 1, '1-0', CURRENT_DATE)
ON CONFLICT (game_id) DO NOTHING;

INSERT INTO RoundResult (result_id, round_id, game_id, white_points, black_points)
VALUES (9999, 9999, 9999, 1.0, 0.0)
ON CONFLICT (result_id) DO NOTHING;