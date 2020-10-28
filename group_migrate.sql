
START TRANSACTION;

  INSERT INTO group_members
    (group_id, member_id, created_at, updated_at)
  SELECT groups.id AS group_id, members.id AS member_id, NOW(), NOW()
    FROM members
      INNER JOIN tempo_group_table
        ON members.group = tempo_group_table.number
      INNER JOIN groups
        ON tempo_group_table.name = groups.name;

COMMIT;
