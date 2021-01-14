START TRANSACTION;

UPDATE Missions
  SET genre = 2
  WHERE event is true;

COMMIT;
