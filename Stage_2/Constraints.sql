-- ==========================================
-- CONSTRAINT 1: תאריך הערכה חוקי
-- לא הגיוני שהמנוע ניתח עמדה בתאריך עתידי
-- ==========================================
ALTER TABLE EngineEvaluation ADD CONSTRAINT chk_computed_date_past CHECK (computed_date <= CURRENT_DATE);

-- טסט להפרת האילוץ (לצלם את השגיאה!):
INSERT INTO EngineEvaluation (eval_id, engine_id, fen_id, search_depth, best_move_pgn, eval_score_cp, computed_date) 
VALUES (99999, 1, 1, 20, 'e2e4', 50, '2030-01-01');


-- ==========================================
-- CONSTRAINT 2: מינימום זיכרון לשרת חומרה
-- שרת המריץ מנועי שחמט חייב לפחות 16GB ראם
-- ==========================================
ALTER TABLE HardwareNode ADD CONSTRAINT chk_min_ram CHECK (ram_gb >= 16);

-- טסט להפרת האילוץ (לצלם את השגיאה!):
INSERT INTO HardwareNode (node_id, host_name, ram_gb, cpu_cores, datacenter_zone, ip_address, os_version) 
VALUES (99, 'srv-weak-01', 8, 4, 'US-East', '10.0.0.1', 'Ubuntu');


-- ==========================================
-- CONSTRAINT 3: מניעת כפילות בשמות בוטים לאותו מנוע
-- אותו מנוע לא יכול להפעיל שני בוטים עם אותו שם תצוגה
-- ==========================================
ALTER TABLE Bot ADD CONSTRAINT unique_bot_name_per_engine UNIQUE (display_name, engine_id);

-- טסט להפרת האילוץ (לצלם את השגיאה!):
-- (יש להריץ פעמיים - בפעם הראשונה זה יצליח, בפעם השנייה זה יזרוק שגיאת כפילות)
INSERT INTO Bot (bot_id, engine_id, display_name, difficulty_level, created_date) 
VALUES (998, 1, 'DuplicateBot', 5, '2024-01-01');
INSERT INTO Bot (bot_id, engine_id, display_name, difficulty_level, created_date) 
VALUES (999, 1, 'DuplicateBot', 5, '2024-01-01');