-- ====================================================================
-- VIEW 1: Internal Perspective (Bot Administrator) V2
-- Enhanced with additional structural, transactional and temporal metrics
-- ====================================================================
CREATE VIEW v_bot_tournament_performance AS
SELECT 
    b.bot_id,
    b.display_name AS bot_name,
    b.difficulty_level,
    b.created_date AS bot_creation_date,
    e.name AS engine_name,
    e.version AS engine_version,
    p.player_id,
    t.tournament_id,
    t.name AS tournament_name,
    t.start_date AS tournament_start,
    t.end_date AS tournament_end,
    r.registered_date AS registration_date,
    r.status AS registration_status
FROM Bot b
JOIN Engine e ON b.engine_id = e.engine_id
JOIN Player p ON b.bot_id = p.bot_id
JOIN Registration r ON p.player_id = r.player_id
JOIN Tournament t ON r.tournament_id = t.tournament_id;
SELECT * FROM v_bot_tournament_performance;

-- Query 1 on View 1: Comprehensive active bot tracking with rich schema fields
SELECT bot_name, engine_name, engine_version, tournament_name, tournament_start, tournament_end, registration_status
FROM v_bot_tournament_performance
WHERE difficulty_level >= 9
ORDER BY tournament_start DESC;

-- Query 2 on View 1: Advanced registration metrics aggregated per engine release
SELECT engine_name, engine_version, COUNT(tournament_name) AS total_tournaments_entered
FROM v_bot_tournament_performance
GROUP BY engine_name, engine_version
ORDER BY total_tournaments_entered DESC;


-- ====================================================================
-- VIEW 2: External Perspective (Tournament Organizer) V2
-- Expanded context for comprehensive multiplayer roster analysis
-- ====================================================================
CREATE VIEW v_tournament_roster_details AS
SELECT 
    t.tournament_id,
    t.name AS tournament_name,
    t.start_date AS tournament_start,
    t.end_date AS tournament_end,
    c.name AS hosting_club,
    p.player_id,
    p.username AS player_name,
    p.bot_id AS system_bot_id,
    CASE 
        WHEN p.bot_id IS NOT NULL THEN 'AI Bot'
        ELSE 'Human'
    END AS player_type,
    r.reg_id AS registration_reference,
    r.registered_date AS signup_date,
    r.status AS registration_status
FROM Tournament t
JOIN Club c ON t.club_id = c.club_id
JOIN Registration r ON t.tournament_id = r.tournament_id
JOIN Player p ON r.player_id = p.player_id;
SELECT * FROM v_tournament_roster_details;

-- Query 1 on View 2: Complete analytical roster breakdown for all combined events
SELECT tournament_name, player_name, player_type, system_bot_id, signup_date, registration_status
FROM v_tournament_roster_details
ORDER BY tournament_name, player_type, player_name;

-- Query 2 on View 2: Club hosting statistics involving integrated automated agents
SELECT DISTINCT tournament_name, hosting_club, tournament_start, tournament_end
FROM v_tournament_roster_details
WHERE player_type = 'AI Bot'
ORDER BY tournament_start;