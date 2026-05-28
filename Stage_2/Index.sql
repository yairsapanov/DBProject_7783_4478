-- ==========================================
-- INDEX 1: ייעול חיפושים על תאריכי טלמטריה
-- טבלת הטלמטריה שלנו ענקית (כ-22 אלף שורות). נשפר חיפושים לפי תאריך.
-- ==========================================

-- להריץ לפני (לצלם זמן):
EXPLAIN ANALYZE SELECT * FROM HardwareTelemetry WHERE time_stamp >= '2025-01-01 00:00:00';

-- יצירת האינדקס:
CREATE INDEX idx_telemetry_date ON HardwareTelemetry (time_stamp);

-- להריץ אחרי (לצלם את השיפור בזמן):
EXPLAIN ANALYZE SELECT * FROM HardwareTelemetry WHERE time_stamp >= '2025-01-01 00:00:00';


-- ==========================================
-- INDEX 2: ייעול סינון ציוני הערכות מנוע
-- טבלת ההערכות מכילה 25,000 שורות. סינון לפי ציון הוא תהליך כבד.
-- ==========================================

-- להריץ לפני (לצלם זמן):
EXPLAIN ANALYZE SELECT engine_id, fen_id, eval_score_cp FROM EngineEvaluation WHERE eval_score_cp > 100;

-- יצירת האינדקס:
CREATE INDEX idx_eval_score ON EngineEvaluation (eval_score_cp);

-- להריץ אחרי (לצלם את השיפור בזמן):
EXPLAIN ANALYZE SELECT engine_id, fen_id, eval_score_cp FROM EngineEvaluation WHERE eval_score_cp > 100;


-- ==========================================
-- INDEX 3: ייעול חיבורים (JOINs) על מפתחות זרים
-- בפוסטגרס (PostgreSQL), מפתחות זרים לא מקבלים אינדקס אוטומטי! ניצור אחד לבוטים.
-- ==========================================

-- להריץ לפני (לצלם זמן):
EXPLAIN ANALYZE SELECT b.display_name, e.name FROM Bot b JOIN Engine e ON b.engine_id = e.engine_id WHERE e.engine_id = 5;

-- יצירת האינדקס:
CREATE INDEX idx_bot_engine_fk ON Bot (engine_id);

-- להריץ אחרי (לצלם את השיפור בזמן):
EXPLAIN ANALYZE SELECT b.display_name, e.name FROM Bot b JOIN Engine e ON b.engine_id = e.engine_id WHERE e.engine_id = 5;