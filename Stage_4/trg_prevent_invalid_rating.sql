-- ====================================================================
-- TRIGGER 1: Prevent negative ELO rating on UPDATE
-- ====================================================================

-- Function executed by the trigger
CREATE OR REPLACE FUNCTION fn_trg_check_rating()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the new rating is invalid
    IF NEW.elo_rating < 0 THEN
        RAISE EXCEPTION 'Update failed: ELO rating cannot be less than zero.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- The trigger definition attached to the Player table
CREATE TRIGGER trg_prevent_invalid_rating
BEFORE UPDATE ON Player
FOR EACH ROW
EXECUTE FUNCTION fn_trg_check_rating();