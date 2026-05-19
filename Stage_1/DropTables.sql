-- Drop junction and dependent child tables first
DROP TABLE IF EXISTS Installed_On;
DROP TABLE IF EXISTS Engine_UI_Support;
DROP TABLE IF EXISTS EngineEvaluation;
DROP TABLE IF EXISTS HardwareTelemetry;
DROP TABLE IF EXISTS ServerComponent;
DROP TABLE IF EXISTS Bot;

-- Drop specialized inheritance child tables
DROP TABLE IF EXISTS LocalEngine;
DROP TABLE IF EXISTS CloudEngine;

-- Drop independent parent tables
DROP TABLE IF EXISTS HardwareNode;
DROP TABLE IF EXISTS OpeningPosition;
DROP TABLE IF EXISTS Engine;
DROP TABLE IF EXISTS UIClient;