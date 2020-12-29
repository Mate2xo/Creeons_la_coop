CREATE OR REPLACE PROCEDURE transfert_old_to_new()
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE Enrollments
  SET start_time = ('2000-01-01 ' || CAST(old_start_time AS text))::timestamp, end_time = ('2000-01-01 ' || CAST(old_end_time AS text))::timestamp
      WHERE old_start_time IS NOT NULL OR old_end_time IS NOT NULL;

    RAISE Warning 'transfert_old_to_new';
  END;
$$;

START TRANSACTION;

call transfert_old_to_new();

COMMIT;
