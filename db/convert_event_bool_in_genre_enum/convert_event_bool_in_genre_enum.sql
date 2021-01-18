START TRANSACTION;

UPDATE Missions
  SET genre = 2 -- 2 is key for the genre 'event'
  WHERE event is true;

COMMIT;
