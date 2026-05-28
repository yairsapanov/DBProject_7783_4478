-- Transaction 1: Test Rollback
BEGIN;

-- Show initial state
SELECT node_id, host_name, ram_gb FROM HardwareNode WHERE node_id = 1;

-- Perform update
UPDATE HardwareNode SET ram_gb = 1024 WHERE node_id = 1;

-- Show state after update (before rollback)
SELECT node_id, host_name, ram_gb FROM HardwareNode WHERE node_id = 1;

-- Revert changes
ROLLBACK;

-- Show reverted state
SELECT node_id, host_name, ram_gb FROM HardwareNode WHERE node_id = 1;


-- Transaction 2: Test Commit
BEGIN;

-- Show initial state
SELECT bot_id, display_name, difficulty_level FROM Bot WHERE bot_id = 1;

-- Perform update
UPDATE Bot SET difficulty_level = 9 WHERE bot_id = 1;

-- Show state after update (before commit)
SELECT bot_id, display_name, difficulty_level FROM Bot WHERE bot_id = 1;

-- Save changes
COMMIT;

-- Show saved state
SELECT bot_id, display_name, difficulty_level FROM Bot WHERE bot_id = 1;