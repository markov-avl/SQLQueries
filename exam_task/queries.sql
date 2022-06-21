-- Задача 3. База данных “Хроники восхождений” в альпинистском клубе.

-- В базе данных должны записываться даты начала и завершения каждого восхождения, имена и адреса участвовавших в нем
-- альпинистов, название и высота горы, страна и район, где эта гора расположена. Присвойте выразительные имена
-- таблицам и полям для хранения указанной информации. Написать запросы, осуществляющие следующие операции.

-- 1) Для введенного пользователем интервала дат показать список гор с указанием даты последнего восхождения. Для
-- каждой горы сформировать в хронологическом порядке список групп, осуществлявших восхождение.
WITH date ("start", "end") AS (VALUES ('2015-12-09'::DATE, '2020-06-13'::DATE))
SELECT mountains.name                                           AS mountain,
       MAX(groups.start_date)                                   AS last_climbing,
       STRING_AGG(groups.name, ', ' ORDER BY groups.start_date) AS groups
FROM date,
     groups
         INNER JOIN mountains ON mountains.id = groups.mountain_id
WHERE groups.start_date BETWEEN date.start AND date.end
GROUP BY mountains.name;

-- 2) Предоставить возможность добавления новой вершины с указанием ее названия, высоты и страны местоположения.
INSERT INTO mountains (name, height, country)
VALUES ('Название горы', 10000, 'Страна местоположения');


-- 3) Предоставить возможность изменения данных о вершине, если на нее не было восхождения.
UPDATE mountains
SET name = 'Название горы'
WHERE id = (SELECT MAX(id)
            FROM mountains)
  AND NOT EXISTS(SELECT 1
                 FROM groups
                 WHERE groups.mountain_id = mountains.id);


-- 4) Показать список альпинистов, осуществлявших восхождение в указанный интервал дат. Для каждого альпиниста вывести
-- список гор, на которые он осуществлял восхождения в этот период, с указанием названия группы и даты восхождения.
WITH date ("start", "end") AS (VALUES ('2015-12-09'::date, '2020-06-13'::date))
SELECT climbers.name || ' ' || climbers.surname AS climber,
       mountains.name                           AS mountain_name,
       groups.name                              AS group_name,
       groups.start_date                        AS climbing_date
FROM date,
     climbers
         INNER JOIN group_members ON climbers.id = group_members.climber_id
         INNER JOIN groups ON group_members.group_id = groups.id
         INNER JOIN mountains ON groups.mountain_id = mountains.id
WHERE groups.start_date BETWEEN date.start AND date.end
ORDER BY climber;


-- 5) Предоставить возможность добавления нового альпиниста в состав указанной группы.
INSERT INTO group_members (group_id, climber_id)
VALUES (1, 1);


-- 6) Показать информацию о количестве восхождений каждого альпиниста на каждую гору. При выводе список отсортировать
-- по количеству восхождений.
SELECT climbers.name || ' ' || climbers.surname AS climber, COUNT(DISTINCT groups.mountain_id) AS climbing_count
FROM climbers
         INNER JOIN group_members ON climbers.id = group_members.climber_id
         INNER JOIN groups ON group_members.group_id = groups.id
GROUP BY climbers.id
ORDER BY climbing_count;


-- 7) Показать список восхождений (групп), которые осуществлялись в указанный пользователем период времени. Для
-- каждой группы показать ее состав.
WITH date ("start", "end") AS (VALUES ('2015-12-09'::DATE, '2020-06-13'::DATE))
SELECT groups.id,
       groups.name,
       STRING_AGG(climbers.name || ' ' || climbers.surname, ', ') AS members
FROM date,
     groups
         INNER JOIN group_members ON groups.id = group_members.group_id
         INNER JOIN climbers ON group_members.climber_id = climbers.id
WHERE groups.start_date BETWEEN date.start AND date.end
GROUP BY groups.id;


-- 8) Предоставить возможность добавления новой группы, указав ее название, вершину, время начала восхождения.
INSERT INTO groups (name, mountain_id, start_date)
VALUES ('Новая группа', 1, CURRENT_DATE);


-- 9) Предоставить информацию о том, сколько альпинистов побывало на каждой горе.
SELECT mountains.id,
       mountains.name,
       (SELECT COUNT(DISTINCT group_members.climber_id)
        FROM groups
                 INNER JOIN group_members on groups.id = group_members.group_id
        WHERE groups.mountain_id = mountains.id) AS climber_count
FROM mountains;