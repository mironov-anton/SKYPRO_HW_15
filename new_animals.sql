CREATE TABLE breeds
(
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL
);

INSERT INTO breeds(name)
SELECT DISTINCT breed
FROM animals;


CREATE TABLE animal_types
(
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    type VARCHAR(50) NOT NULL
);

INSERT INTO animal_types(type)
SELECT DISTINCT animal_type
FROM animals;


CREATE TABLE colors
(
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL
);

INSERT INTO colors(name)
SELECT *
FROM (SELECT DISTINCT rtrim(color1)
      FROM animals
      UNION
      SELECT DISTINCT rtrim(color2)
      FROM animals
      WHERE color2 IS NOT NULL);


CREATE TABLE animals_final
(
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    animal_id     VARCHAR(50),
    type_id       INTEGER,
    name          VARCHAR(50),
    breed_id      INTEGER,
    date_of_birth DATE,
    FOREIGN KEY (type_id) REFERENCES animal_types (id),
    FOREIGN KEY (breed_id) REFERENCES breeds (id)
);

INSERT INTO animals_final (animal_id, type_id, name, breed_id, date_of_birth)
SELECT DISTINCT animals.animal_id, animal_types.id, animals.name, breeds.id, animals.date_of_birth
FROM animals
         LEFT JOIN animal_types ON animals.animal_type = animal_types.type
         LEFT JOIN breeds ON animals.breed = breeds.name;


CREATE TABLE outcomes
(
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    age_upon_outcome VARCHAR(50),
    outcome_subtype  VARCHAR(50),
    outcome_type     VARCHAR(50),
    outcome_month    INTEGER,
    outcome_year     INTEGER,
    animal_id        VARCHAR(50),
    FOREIGN KEY (animal_id) REFERENCES animals_final (animal_id) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO outcomes (age_upon_outcome, outcome_subtype, outcome_type, outcome_month, outcome_year, animal_id)
SELECT DISTINCT age_upon_outcome, outcome_subtype, outcome_type, outcome_month, outcome_year, animal_id
FROM animals;


CREATE TABLE animal_colors
(
    animal_id INTEGER,
    color_id  INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animals_final (id),
    FOREIGN KEY (color_id) REFERENCES colors (id)
    PRIMARY KEY (animal_id, color_id)
);

INSERT INTO animal_colors
SELECT DISTINCT animals_final.id, colors.id
FROM animals_final
         JOIN animals ON animals_final.animal_id = animals.animal_id
         JOIN colors ON colors.name = rtrim(animals.color1)
UNION
SELECT DISTINCT animals_final.id, colors.id
FROM animals_final
         JOIN animals ON animals_final.animal_id = animals.animal_id
         JOIN colors ON colors.name = rtrim(animals.color2);
