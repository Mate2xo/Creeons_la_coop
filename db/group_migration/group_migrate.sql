

CREATE TABLE tempo_group_table ( number int, name varchar(255));

START TRANSACTION;

  INSERT INTO groups (name, created_at, updated_at)
    VALUES ('Accueil', NOW(), NOW()),
           ('Gestion financière', NOW(), NOW()),
           ('Gestion adhérents', NOW(), NOW()),
           ('Coeur', NOW(), NOW()),
           ('Planning', NOW(), NOW()),
           ('Bricolage', NOW(), NOW()),
           ('Culture interne', NOW(), NOW()),
           ('Fournisseurs locaux', NOW(), NOW()),
           ('Autres fournisseurs', NOW(), NOW()),
           ('Approvisionnement', NOW(), NOW()),
           ('Commande', NOW(), NOW()),
           ('Informatique', NOW(), NOW());

  INSERT INTO tempo_group_table (number, name)
  VALUES
    (1, 'Accueil'),
    (2, 'Gestion financière'),
    (3, 'Gestion adhérents'),
    (4, 'Coeur'),
    (5, 'Planning'),
    (6, 'Bricolage'),
    (7, 'Culture interne'),
    (8, 'Fournisseurs locaux'),
    (9, 'Autres fournisseurs'),
    (10, 'Approvisionnement'),
    (11, 'Commande'),
    (12, 'Informatique')
    ;


  INSERT INTO group_members
    (group_id, member_id, created_at, updated_at)
  SELECT groups.id AS group_id, members.id AS member_id, NOW(), NOW()
    FROM members
      JOIN tempo_group_table
        ON members.group is not null and members.group = tempo_group_table.number
      INNER JOIN groups
        ON tempo_group_table.name = groups.name;

COMMIT;
