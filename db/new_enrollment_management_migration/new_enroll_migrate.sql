CREATE OR REPLACE FUNCTION get_concerned_members_ids(m missions, slot_start_time time with time zone) RETURNS bigint[] AS
$$
BEGIN
    return array(SELECT members.id 
    FROM members 
      INNER JOIN enrollments ON members.id = enrollments.member_id 
    WHERE enrollments.mission_id = m.id AND 
    ((enrollments.start_time at time zone 'UTC', enrollments.end_time at time zone 'UTC') overlaps (slot_start_time ,(slot_start_time + interval '90 minutes'))));
      
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE create_slots_for_a_time_slot(m missions, time_slot timestamp)
LANGUAGE plpgsql AS $$
DECLARE 
  concerned_members_ids bigint[];
  counter int = 1;
  members_count int;
BEGIN
  concerned_members_ids = get_concerned_members_ids(m, time_slot::time at time zone 'UTC');
  members_count = array_length(concerned_members_ids, 1);
  WHILE counter <= m.max_member_count OR counter <= members_count LOOP
    INSERT INTO mission_slots (start_time, mission_id, member_id, created_at, updated_at)
      VALUES (time_slot, m.id, concerned_members_ids[counter], NOW(), NOW()); 
    counter = counter + 1;
  END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE create_slots_for_a_mission(m missions)
LANGUAGE plpgsql AS $$
DECLARE
  time_slot timestamp = m.start_date;
  slot_duration interval = '90 minutes';
BEGIN
  WHILE time_slot < m.due_date LOOP
    call create_slots_for_a_time_slot(m, time_slot);
    time_slot = time_slot + slot_duration;
  END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE create_slots_for_all_missions()
LANGUAGE plpgsql AS $$
DECLARE 
  m missions;
BEGIN
  FOR m IN 
    SELECT * FROM missions
  LOOP 
    call create_slots_for_a_mission(m);
  END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE update_max_member_count_nil_of_missions()
LANGUAGE plpgsql AS $$
DECLARE
  m record;
  members_count int;
BEGIN

  FOR m IN
    SELECT * FROM missions WHERE max_member_count IS NULL
    LOOP
      SELECT COUNT (*) INTO members_count from enrollments where mission_id = m.id;
      UPDATE missions SET max_member_count = members_count WHERE id = m.id;
  END LOOP;
END;
$$;

-- MAIN


START TRANSACTION;

  INSERT INTO participations 
    (participant_id, event_id, created_at, updated_at)
  SELECT enrollments.member_id AS participant_id, enrollments.mission_id AS event_id, NOW(), NOW()
  FROM enrollments
    JOIN missions
      ON enrollments.mission_id = missions.id
    WHERE(missions.event);

  call create_slots_for_all_missions();

  call update_max_member_count_nil_of_missions();

COMMIT;
