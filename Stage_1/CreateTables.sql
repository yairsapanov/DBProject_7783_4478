CREATE TABLE Engine (
  engine_id INT PRIMARY KEY,
  name VARCHAR(255),
  version VARCHAR(50),
  release_date DATE
);

CREATE TABLE HardwareNode (
  node_id INT PRIMARY KEY,
  hostname VARCHAR(255),
  cpu_cores INT,
  ram_gb INT
);

CREATE TABLE Bot (
  bot_id INT PRIMARY KEY,
  engine_id INT,
  display_name VARCHAR(255),
  difficulty_level INT,
  created_date DATE,
  FOREIGN KEY (engine_id) REFERENCES Engine(engine_id)
);

CREATE TABLE HardwareTelemetry (
  node_id INT,
  time_stamp TIMESTAMP,
  cpu_usage_pct INT,
  temp_celsius INT,
  PRIMARY KEY (node_id, time_stamp),
  FOREIGN KEY (node_id) REFERENCES HardwareNode(node_id)
);

CREATE TABLE UIClient (
  client_id INT PRIMARY KEY,
  name VARCHAR(255),
  version VARCHAR(50),
  release_date DATE
);

CREATE TABLE MobileClient (
  client_id INT PRIMARY KEY,
  app_store_url VARCHAR(500),
  android_version VARCHAR(50),
  FOREIGN KEY (client_id) REFERENCES UIClient(client_id)
);

CREATE TABLE WebClient (
  client_id INT PRIMARY KEY,
  domain_url VARCHAR(500),
  browser_engine VARCHAR(100),
  FOREIGN KEY (client_id) REFERENCES UIClient(client_id)
);

CREATE TABLE OpeningPosition (
  fen_id INT PRIMARY KEY,
  fen_string VARCHAR(255),
  eco_code VARCHAR(10),
  opening_name VARCHAR(255)
);

CREATE TABLE EngineEvaluation (
  eval_id INT PRIMARY KEY,
  engine_id INT,
  fen_id INT,
  eval_score_cp INT,
  search_depth INT,
  best_move_pgn VARCHAR(50),
  computed_date DATE,
  FOREIGN KEY (engine_id) REFERENCES Engine(engine_id),
  FOREIGN KEY (fen_id) REFERENCES OpeningPosition(fen_id)
);

CREATE TABLE Engine_UI_Support (
  engine_id INT,
  client_id INT,
  supported_since DATE,
  PRIMARY KEY (engine_id, client_id),
  FOREIGN KEY (engine_id) REFERENCES Engine(engine_id),
  FOREIGN KEY (client_id) REFERENCES UIClient(client_id)
);