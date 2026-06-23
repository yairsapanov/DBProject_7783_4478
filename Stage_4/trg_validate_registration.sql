-- ====================================================================
-- TRIGGER 2: Prevent registration to a completed tournament
-- ====================================================================

-- Function executed by the trigger
CREATE OR REPLACE FUNCTION fn_trg_validate_reg()
RETURNS TRIGGER AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    -- Fetch the status of the target tournament
    SELECT status INTO v_status 
    FROM Tournament 
    WHERE tournament_id = NEW.tournament_id;
    
    -- Block registration if tournament is closed
    IF v_status = 'Completed' THEN
        RAISE EXCEPTION 'Insert failed: Cannot register for a closed tournament.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- The trigger definition attached to the Registration table
CREATE TRIGGER trg_validate_registration
BEFORE INSERT ON Registration
FOR EACH ROW
EXECUTE FUNCTION fn_trg_validate_reg();