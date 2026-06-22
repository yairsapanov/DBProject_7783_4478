-- ====================================================================
-- SECTION 1: DUAL SELECT QUERIES (For Performance Comparison)
-- ====================================================================
BEGIN;
-- Query 1.A: Find active engines in 2023 (Using JOIN)
SELECT DISTINCT 
    e.engine_id, 
    e.name AS engine_name, 
    e.version AS engine_version, 
    EXTRACT(YEAR FROM ee.computed_date) AS eval_year, 
    EXTRACT(MONTH FROM ee.computed_date) AS eval_month, 
    EXTRACT(DAY FROM ee.computed_date) AS eval_day
FROM Engine e
JOIN EngineEvaluation ee ON e.engine_id = ee.engine_id
WHERE EXTRACT(YEAR FROM ee.computed_date) = 2023
ORDER BY e.name;

-- Query 1.B: Find active engines in 2023 (Using EXISTS - More efficient)
SELECT 
    e.engine_id, 
    e.name AS engine_name, 
    e.version AS engine_version, 
    2023 AS eval_year
FROM Engine e
WHERE EXISTS (
    SELECT 1 
    FROM EngineEvaluation ee 
    WHERE ee.engine_id = e.engine_id 
      AND EXTRACT(YEAR FROM ee.computed_date) = 2023
)
ORDER BY e.name;


-- Query 2.A: Find high difficulty bots running on Local Engines (Using JOIN)
SELECT 
    b.bot_id, 
    b.display_name AS bot_name, 
    b.difficulty_level, 
    EXTRACT(YEAR FROM b.created_date) AS bot_created_year, 
    le.engine_id, 
    le.threads_limit
FROM Bot b
JOIN LocalEngine le ON b.engine_id = le.engine_id
WHERE b.difficulty_level >= 8
ORDER BY b.difficulty_level DESC, b.display_name;

-- Query 2.B: Find high difficulty bots running on Local Engines (Using IN)
SELECT 
    b.bot_id, 
    b.display_name AS bot_name, 
    b.difficulty_level, 
    EXTRACT(YEAR FROM b.created_date) AS bot_created_year, 
    b.engine_id
FROM Bot b
WHERE b.difficulty_level >= 8 
  AND b.engine_id IN (
      SELECT le.engine_id 
      FROM LocalEngine le
  )
ORDER BY b.difficulty_level DESC, b.display_name;

-- Query 3.A: Find UI Clients supporting specific engines (Using JOIN)
SELECT DISTINCT 
    u.client_id, 
    u.name AS client_name, 
    u.client_type, 
    EXTRACT(YEAR FROM u.release_date) AS release_year
FROM UIClient u
JOIN Engine_UI_Support eus ON u.client_id = eus.client_id
JOIN Engine e ON eus.engine_id = e.engine_id
WHERE e.name IN ('Stockfish', 'Komodo Dragon')
ORDER BY u.name;

-- Query 3.B: Find UI Clients supporting specific engines (Using EXISTS)
SELECT 
    u.client_id, 
    u.name AS client_name, 
    u.client_type, 
    EXTRACT(YEAR FROM u.release_date) AS release_year
FROM UIClient u
WHERE EXISTS (
    SELECT 1 
    FROM Engine_UI_Support eus
    JOIN Engine e ON eus.engine_id = e.engine_id
    WHERE eus.client_id = u.client_id 
      AND e.name IN ('Stockfish', 'Komodo Dragon')
)
ORDER BY u.name;


-- Query 4.A: Find hardware nodes hosting engines with high thread limits (Using JOIN)
SELECT DISTINCT 
    hn.node_id, 
    hn.host_name, 
    hn.datacenter_zone, 
    hn.ram_gb, 
    hn.cpu_cores, 
    le.threads_limit
FROM HardwareNode hn
JOIN Installed_On io ON hn.node_id = io.node_id
JOIN LocalEngine le ON io.engine_id = le.engine_id
WHERE le.threads_limit > 16
ORDER BY hn.ram_gb DESC, hn.host_name;

-- Query 4.B: Find hardware nodes hosting engines with high thread limits (Using Nested IN)
SELECT 
    hn.node_id, 
    hn.host_name, 
    hn.datacenter_zone, 
    hn.ram_gb, 
    hn.cpu_cores
FROM HardwareNode hn
WHERE hn.node_id IN (
    SELECT io.node_id 
    FROM Installed_On io 
    WHERE io.engine_id IN (
        SELECT le.engine_id 
        FROM LocalEngine le 
        WHERE le.threads_limit > 16
    )
)
ORDER BY hn.ram_gb DESC, hn.host_name;


-- ====================================================================
-- SECTION 2: COMPLEX SINGLE SELECT QUERIES
-- ====================================================================

-- Query 5: Monthly Telemetry Averages per Hardware Server
SELECT 
    hn.node_id, 
    hn.host_name, 
    hn.datacenter_zone, 
    EXTRACT(YEAR FROM ht.time_stamp) AS log_year, 
    EXTRACT(MONTH FROM ht.time_stamp) AS log_month, 
    ROUND(AVG(ht.temp_celsius), 2) AS avg_monthly_temp, 
    ROUND(AVG(ht.cpu_usage_pct), 2) AS avg_monthly_cpu, 
    ROUND(AVG(ht.ram_usage_pct), 2) AS avg_monthly_ram
FROM HardwareNode hn
JOIN HardwareTelemetry ht ON hn.node_id = ht.node_id
GROUP BY hn.node_id, hn.host_name, hn.datacenter_zone, EXTRACT(YEAR FROM ht.time_stamp), EXTRACT(MONTH FROM ht.time_stamp)
ORDER BY log_year DESC, log_month DESC, avg_monthly_temp DESC;

-- Query 6: Engine Evaluation Statistics with high threshold filtering
SELECT 
    e.engine_id, 
    e.name AS engine_name, 
    e.version AS engine_version, 
    COUNT(ee.eval_id) AS total_evaluations, 
    MAX(ee.search_depth) AS max_depth_reached, 
    ROUND(AVG(ee.eval_score_cp), 2) AS avg_evaluation_score
FROM Engine e
JOIN EngineEvaluation ee ON e.engine_id = ee.engine_id
GROUP BY e.engine_id, e.name, e.version
HAVING COUNT(ee.eval_id) > 100
ORDER BY total_evaluations DESC;

-- Query 7: Top evaluated opening positions
SELECT 
    op.fen_id, 
    op.opening_name, 
    op.eco_code, 
    e.name AS evaluated_by_engine, 
    ee.eval_score_cp AS centipawn_score, 
    ee.best_move_pgn, 
    EXTRACT(YEAR FROM ee.computed_date) AS evaluation_year, 
    EXTRACT(MONTH FROM ee.computed_date) AS evaluation_month
FROM OpeningPosition op
JOIN EngineEvaluation ee ON op.fen_id = ee.fen_id
JOIN Engine e ON ee.engine_id = e.engine_id
WHERE ee.eval_score_cp > 50
ORDER BY ee.eval_score_cp DESC, op.opening_name;

-- Query 8: Historical timeline analysis of bot creation
SELECT 
    b.engine_id, 
    e.name AS engine_name, 
    EXTRACT(YEAR FROM b.created_date) AS creation_year, 
    EXTRACT(MONTH FROM b.created_date) AS creation_month, 
    EXTRACT(DAY FROM b.created_date) AS creation_day, 
    COUNT(b.bot_id) AS total_bots_created
FROM Bot b
JOIN Engine e ON b.engine_id = e.engine_id
GROUP BY b.engine_id, e.name, EXTRACT(YEAR FROM b.created_date), EXTRACT(MONTH FROM b.created_date), EXTRACT(DAY FROM b.created_date)
ORDER BY creation_year DESC, creation_month DESC, total_bots_created DESC;


-- ====================================================================
-- UPDATE Queries (Before, Execution, After)
-- ====================================================================

-- Update 1: "Before" - Stockfish bots below level 10
SELECT b.bot_id, b.display_name, b.difficulty_level, e.name AS engine_name
FROM Bot b
JOIN Engine e ON b.engine_id = e.engine_id
WHERE e.name LIKE 'Stockfish%' AND b.difficulty_level < 10;

-- Update 1: Execution - Update Stockfish bots
UPDATE Bot 
SET difficulty_level = 10, display_name = display_name || ' (Grandmaster)'
WHERE engine_id IN (SELECT engine_id FROM Engine WHERE name LIKE 'Stockfish%') 
  AND difficulty_level < 10;

-- Update 1: "After" - Verify updated bots
SELECT b.bot_id, b.display_name, b.difficulty_level, e.name AS engine_name
FROM Bot b
JOIN Engine e ON b.engine_id = e.engine_id
WHERE b.display_name LIKE '%(Grandmaster)';


-- Update 2: "Before" - US-East nodes with less than 512GB
SELECT node_id, host_name, datacenter_zone, ram_gb, os_version
FROM HardwareNode
WHERE datacenter_zone LIKE 'US-East%' AND ram_gb < 512;

-- Update 2: Execution - Upgrade RAM
UPDATE HardwareNode 
SET ram_gb = ram_gb + 128, os_version = os_version || ' (Upgraded)'
WHERE datacenter_zone LIKE 'US-East%' AND ram_gb < 512;

-- Update 2: "After" - Verify updated RAM and OS label
SELECT node_id, host_name, datacenter_zone, ram_gb, os_version
FROM HardwareNode
WHERE os_version LIKE '%(Upgraded)';


-- Update 3: "Before" - 2023 evaluations with depth 25 or more
SELECT eval_id, engine_id, fen_id, search_depth, eval_score_cp, computed_date
FROM EngineEvaluation
WHERE search_depth >= 25 AND EXTRACT(YEAR FROM computed_date) = 2023;

-- Update 3: Execution - Add score to evaluations
UPDATE EngineEvaluation 
SET eval_score_cp = eval_score_cp + 15 
WHERE search_depth >= 25 AND EXTRACT(YEAR FROM computed_date) = 2023;

-- Update 3: "After" - Verify score increased by 15
SELECT eval_id, engine_id, fen_id, search_depth, eval_score_cp, computed_date
FROM EngineEvaluation
WHERE search_depth >= 25 AND EXTRACT(YEAR FROM computed_date) = 2023;


-- ====================================================================
-- DELETE Queries (Before, Execution, After)
-- ====================================================================

-- ====================================================================
-- DELETE Queries (Before, Execution, After) - Contextual View
-- ====================================================================

-- Delete 1: "Before" - Show bots up to level 5
SELECT bot_id, display_name, difficulty_level, created_date
FROM Bot
WHERE difficulty_level <= 5
ORDER BY difficulty_level;

-- Delete 1: Execution - Delete ONLY bots level 2 or below from 2023 or older
DELETE FROM Bot 
WHERE difficulty_level <= 2 AND EXTRACT(YEAR FROM created_date) <= 2023;

-- Delete 1: "After" - Levels 1 and 2 are gone, but levels 3, 4, 5 remain
SELECT bot_id, display_name, difficulty_level, created_date
FROM Bot
WHERE difficulty_level <= 5
ORDER BY difficulty_level;


-- Delete 2: "Before" - Show 2024 telemetry with temperatures over 65
SELECT telemetry_id, node_id, time_stamp, temp_celsius, cpu_usage_pct
FROM HardwareTelemetry
WHERE temp_celsius > 65 AND EXTRACT(YEAR FROM time_stamp) = 2024
ORDER BY temp_celsius DESC;

-- Delete 2: Execution - Delete ONLY extreme anomalies (temp > 75 and cpu > 75)
DELETE FROM HardwareTelemetry 
WHERE temp_celsius > 75 AND cpu_usage_pct > 75 AND EXTRACT(YEAR FROM time_stamp) = 2024;

-- Delete 2: "After" - Extreme rows are gone, normal rows (65-75 degrees) remain
SELECT telemetry_id, node_id, time_stamp, temp_celsius, cpu_usage_pct
FROM HardwareTelemetry
WHERE temp_celsius > 65 AND EXTRACT(YEAR FROM time_stamp) = 2024
ORDER BY temp_celsius DESC;


-- Delete 3: "Before" - Show ALL Web UI support records
SELECT eus.engine_id, eus.client_id, eus.supported_since, uc.name, uc.client_type
FROM Engine_UI_Support eus
JOIN UIClient uc ON eus.client_id = uc.client_id
WHERE uc.client_type = 'Web'
ORDER BY eus.supported_since;

-- Delete 3: Execution - Delete ONLY Web UIs supported before march 2024
DELETE FROM Engine_UI_Support 
WHERE supported_since < '2024-03-01' AND client_id IN (SELECT client_id FROM UIClient WHERE client_type = 'Web');

-- Delete 3: "After" - Older Web UIs are gone, newer ones (march24+) remain
SELECT eus.engine_id, eus.client_id, eus.supported_since, uc.name, uc.client_type
FROM Engine_UI_Support eus
JOIN UIClient uc ON eus.client_id = uc.client_id
WHERE uc.client_type = 'Web'
ORDER BY eus.supported_since;

  ROLLBACK;