CREATE OR REPLACE PROCEDURE restore_enrollments_for_missions_in_last_three_months()
LANGUAGE plpgsql AS $$
DECLARE
  mission missions;
BEGIN
  FOR mission in SELECT * 
                 FROM missions 
                 WHERE start_date >= '2020-10-01'::timestamp AND start_date < '2021-01-04'::timestamp
  LOOP
    call restore_enrollments(mission);
  END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE restore_enrollments(mission missions)
LANGUAGE plpgsql AS $$
DECLARE
  enrollments_from_db_count integer;
  enrollments_from_csv_count integer;
BEGIN
  Select Count(*) INTO enrollments_from_db_count FROM get_enrollments_from_db(mission);
  Select Count(*) INTO enrollments_from_csv_count FROM get_enrollments_from_csv(mission);
  IF enrollments_from_db_count >= enrollments_from_csv_count THEN
    RETURN;
  END IF;

  RAISE WARNING 'restoration enrollments of mission with id=%', mission.id;
  call destroy_enrollments(mission);
  call recreate_enrollments_from_csv(mission);
END;
$$;

CREATE OR REPLACE FUNCTION get_enrollments_from_db(mission missions) RETURNS SETOF enrollments AS $$
BEGIN 
  RETURN QUERY SELECT * FROM enrollments WHERE mission_id = mission.id;
  RETURN;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_enrollments_from_csv(mission missions) RETURNS SETOF enrollments AS $$
BEGIN 
  RETURN QUERY SELECT * FROM temp_enrollments_from_csv WHERE mission_id = mission.id;
  RETURN;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE destroy_enrollments(mission missions)
LANGUAGE plpgsql AS $$
DECLARE
  enrollment enrollments;
BEGIN
  FOR enrollment IN SELECT * FROM get_enrollments_from_db(mission) LOOP
    DELETE FROM enrollments WHERE id=enrollment.id;
  END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE recreate_enrollments_from_csv(mission missions)
LANGUAGE plpgsql AS $$
DECLARE
  enrollment enrollments;
BEGIN
  FOR enrollment IN SELECT * FROM get_enrollments_from_csv(mission) LOOP
    INSERT INTO enrollments (start_time, end_time, member_id, mission_id)
    VALUES(enrollment.start_time, enrollment.end_time, enrollment.member_id, enrollment.mission_id);
  END LOOP;
END;
$$;


START TRANSACTION;

call restore_enrollments_for_missions_in_last_three_months();

COMMIT;

