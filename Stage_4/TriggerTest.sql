UPDATE Player SET elo_rating = -10 WHERE player_id = 501; -- this is the test for trigger that prevents negative ELO ratings

--Test two: tests the trigger that prevents signing up for a tournament if the tournament is closed
INSERT INTO Registration (reg_id, tournament_id, player_id, registered_date, status) VALUES (8888, 1, 502, CURRENT_DATE, 'Confirmed');
