-- =====================================================================
-- SECTION 1: DUAL SELECT QUERIES (For Performance Comparison)
-- =====================================================================

-- Query 1.A: Find active engines in 2024 (Using JOIN)
SELECT DISTINCT e.name, e.version, EXTRACT(YEAR FROM ee.computed_date) AS eval_year
FROM Engine e
JOIN EngineEvaluation ee ON e.engine_id = ee.engine_id
WHERE EXTRACT(YEAR FROM ee.computed_date) = 2024;

-- Query 1.B: Find active engines in 2024 (Using EXISTS - More efficient)
SELECT e.name, e.version, 2024 AS eval_year
FROM Engine e
WHERE EXISTS (
    SELECT 1 
    FROM EngineEvaluation ee 
    WHERE ee.engine_id = e.engine_id 
      AND EXTRACT(YEAR FROM ee.computed_date) = 2024
);

-- Query 2.A: Find high difficulty bots running on Local Engines (Using JOIN)
SELECT b.display_name, b.difficulty_level, b.created_date
FROM Bot b
JOIN LocalEngine le ON b.engine_id = le.engine_id
WHERE b.difficulty_level >= 8;

-- Query 2.B: Find high difficulty bots running on Local Engines (Using IN - Better for separated logic)
SELECT display_name, difficulty_level, created_date
FROM Bot 
WHERE difficulty_level >= 8 
  AND engine_id IN (SELECT engine_id FROM LocalEngine);

-- Query 3.A: Find UI Clients supporting 'Stockfish' or 'Komodo Dragon' (Using JOIN)
SELECT DISTINCT u.name, u.client_type, u.release_date
FROM UIClient u
JOIN Engine_UI_Support eus ON u.client_id = eus.client_id
JOIN Engine e ON eus.engine_id = e.engine_id
WHERE e.name IN ('Stockfish', 'Komodo Dragon');

-- Query 3.B: Find UI Clients supporting 'Stockfish' or 'Komodo Dragon' (Using EXISTS)
SELECT name, client_type, release_date
FROM UIClient u
WHERE EXISTS (
    SELECT 1 
    FROM Engine_UI_Support eus 
    JOIN Engine e ON eus.engine_id = e.engine_id 
    WHERE eus.client_id = u.client_id 
      AND e.name IN ('Stockfish', 'Komodo Dragon')
);

-- Query 4.A: Find hardware nodes hosting engines with high thread limits (Using JOIN)
SELECT DISTINCT hn.host_name, hn.datacenter_zone, hn.ram_gb
FROM HardwareNode hn
JOIN Installed_On io ON hn.node_id = io.node_id
JOIN LocalEngine le ON io.engine_id = le.engine_id
WHERE le.threads_limit > 16;

-- Query 4.B: Find hardware nodes hosting engines with high thread limits (Using Nested IN)
SELECT host_name, datacenter_zone, ram_gb
FROM HardwareNode 
WHERE node_id IN (
    SELECT node_id 
    FROM Installed_On 
    WHERE engine_id IN (
        SELECT engine_id 
        FROM LocalEngine 
        WHERE threads_limit > 16
    )
);


-- =====================================================================
-- SECTION 2: COMPLEX SELECT QUERIES
-- =====================================================================

-- Query 5: Monthly Telemetry Averages (Uses Dates, Group By, Order By, Aggregation)
SELECT 
    hn.host_name, 
    EXTRACT(YEAR FROM ht.time_stamp) AS log_year, 
    EXTRACT(MONTH FROM ht.time_stamp) AS log_month, 
    ROUND(AVG(ht.temp_celsius), 2) AS avg_monthly_temp, 
    ROUND(AVG(ht.cpu_usage_pct), 2) AS avg_monthly_cpu
FROM HardwareNode hn
JOIN HardwareTelemetry ht ON hn.node_id = ht.node_id
GROUP BY hn.host_name, EXTRACT(YEAR FROM ht.time_stamp), EXTRACT(MONTH FROM ht.time_stamp)
ORDER BY log_year DESC, log_month DESC, avg_monthly_temp DESC
LIMIT 50;

-- Query 6: Engine Evaluation Statistics (Uses Group By, Having, Count, Max)
SELECT 
    e.name AS engine_name, 
    COUNT(ee.eval_id) AS total_evaluations, 
    MAX(ee.search_depth) AS max_depth_reached
FROM Engine e
JOIN EngineEvaluation ee ON e.engine_id = ee.engine_id
GROUP BY e.name
HAVING COUNT(ee.eval_id) > 100
ORDER BY total_evaluations DESC;

-- Query 7: Top evaluated openings showing specific moves (Multiple Joins)
SELECT 
    op.opening_name, 
    op.eco_code, 
    e.name AS evaluated_by, 
    ee.eval_score_cp, 
    ee.best_move_pgn
FROM OpeningPosition op
JOIN EngineEvaluation ee ON op.fen_id = ee.fen_id
JOIN Engine e ON ee.engine_id = e.engine_id
WHERE ee.eval_score_cp > 100
ORDER BY ee.eval_score_cp DESC
LIMIT 20;

-- Query 8: Count of new bots created per month and year
SELECT 
    EXTRACT(YEAR FROM created_date) AS creation_year, 
    EXTRACT(MONTH FROM created_date) AS creation_month, 
    COUNT(bot_id) AS total_bots_created
FROM Bot
GROUP BY EXTRACT(YEAR FROM created_date), EXTRACT(MONTH FROM created_date)
ORDER BY creation_year DESC, creation_month DESC;


-- =====================================================================
-- SECTION 3: UPDATE QUERIES
-- =====================================================================

-- Update 1: Max out difficulty for Stockfish bots below level 10
UPDATE Bot 
SET difficulty_level = 10 
WHERE engine_id IN (SELECT engine_id FROM Engine WHERE name LIKE 'Stockfish%') 
  AND difficulty_level < 10;

-- Update 2: Upgrade RAM for older servers in US-East zone
UPDATE HardwareNode 
SET ram_gb = ram_gb + 128 
WHERE datacenter_zone LIKE 'US-East%' 
  AND ram_gb < 512;

-- Update 3: Adjust evaluation scores for deep searches in 2023
UPDATE EngineEvaluation 
SET eval_score_cp = eval_score_cp + 15 
WHERE search_depth >= 25 
  AND EXTRACT(YEAR FROM computed_date) = 2023;


-- =====================================================================
-- SECTION 4: DELETE QUERIES
-- =====================================================================

-- Delete 1: Remove weak bots created early in the project
DELETE FROM Bot 
WHERE difficulty_level <= 2 
  AND EXTRACT(YEAR FROM created_date) <= 2023;

-- Delete 2: Clean up extreme telemetry anomalies (Overheating spikes)
DELETE FROM HardwareTelemetry 
WHERE temp_celsius > 75 
  AND cpu_usage_pct > 75 
  AND EXTRACT(YEAR FROM time_stamp) = 2024;

-- Delete 3: Remove UI support for obsolete early mobile integrations
DELETE FROM Engine_UI_Support 
WHERE supported_since < '2026-01-01' 
  AND client_id IN (SELECT client_id FROM UIClient WHERE client_type = 'Web');