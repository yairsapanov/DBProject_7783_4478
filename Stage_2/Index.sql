-- ==========================================
-- Index 1: Telemetry Time Stamp
-- ==========================================

-- Check execution time before index
EXPLAIN ANALYZE SELECT * FROM HardwareTelemetry WHERE time_stamp >= '2024-01-01';

-- Create the index
CREATE INDEX idx_telemetry_timestamp ON HardwareTelemetry(time_stamp);

-- Check execution time after index
EXPLAIN ANALYZE SELECT * FROM HardwareTelemetry WHERE time_stamp >= '2024-01-01';


-- ==========================================
-- Index 2: Evaluation Score
-- ==========================================

-- Check execution time before index
EXPLAIN ANALYZE SELECT * FROM EngineEvaluation WHERE eval_score_cp > 100;

-- Create the index
CREATE INDEX idx_eval_score ON EngineEvaluation(eval_score_cp);

-- Check execution time after index
EXPLAIN ANALYZE SELECT * FROM EngineEvaluation WHERE eval_score_cp > 100;


-- ==========================================
-- Index 3: Bot Engine ID (Foreign Key Optimization)
-- ==========================================

-- Check execution time before index
EXPLAIN ANALYZE 
SELECT b.display_name, e.name 
FROM Bot b 
JOIN Engine e ON b.engine_id = e.engine_id 
WHERE e.engine_id = 1;

-- Create the index
CREATE INDEX idx_bot_engine_id ON Bot(engine_id);

-- Check execution time after index
EXPLAIN ANALYZE 
SELECT b.display_name, e.name 
FROM Bot b 
JOIN Engine e ON b.engine_id = e.engine_id 
WHERE e.engine_id = 1;