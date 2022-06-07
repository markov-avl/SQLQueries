-- Задача 3. База данных “Хроники восхождений” в альпинистском клубе.

-- В базе данных должны записываться даты начала и завершения каждого восхождения, имена и адреса участвовавших в нем
-- альпинистов, название и высота горы, страна и район, где эта гора расположена. Присвойте выразительные имена
-- таблицам и полям для хранения указанной информации. Написать запросы, осуществляющие следующие операции.

-- 1) Для введенного пользователем интервала дат показать список гор с указанием даты последнего восхождения. Для
-- каждой горы сформировать в хронологическом порядке список групп, осуществлявших восхождение.
-- 2) Предоставить возможность добавления новой вершины с указанием ее названия, высоты и страны местоположения.
-- 3) Предоставить возможность изменения данных о вершине, если на нее не было восхождения.
-- 4) Показать список альпинистов, осуществлявших восхождение в указанный интервал дат. Для каждого альпиниста вывести
-- список гор, на которые он осуществлял восхождения в этот период, с указанием названия группы и даты восхождения.
-- 5) Предоставить возможность добавления нового альпиниста в состав указанной группы.
-- 6) Показать информацию о количестве восхождений каждого альпиниста на каждую гору. При выводе список отсортировать
-- по количеству восхождений.
-- 7) Показать список восхождений (групп), которые осуществлялись в указанный пользователем период времени. Для
-- каждой группы показать ее состав.
-- 8) Предоставить возможность добавления новой группы, указав ее название, вершину, время начала восхождения.
-- 9) Предоставить информацию о том, сколько альпинистов побывало на каждой горе.


-- Создание базы данных
-- CREATE DATABASE climbing_chronicles;

DROP TABLE IF EXISTS climbers CASCADE;
DROP TABLE IF EXISTS mountains CASCADE;
DROP TABLE IF EXISTS climbing CASCADE;
DROP TABLE IF EXISTS groups CASCADE;

-- Альпинисты
CREATE TABLE climbers
(
    id      SERIAL       NOT NULL,
    name    VARCHAR(32)  NOT NULL,
    surname VARCHAR(32)  NOT NULL,
    address VARCHAR(256) NOT NULL,
    CONSTRAINT climbers_pk PRIMARY KEY (id)
);

-- Горы, вершины
CREATE TABLE mountains
(
    id      SERIAL       NOT NULL,
    name    VARCHAR(128) NOT NULL,
    country VARCHAR(64)  NOT NULL,
    region  VARCHAR(128) DEFAULT NULL,
    height  SMALLINT     NOT NULL,
    CONSTRAINT mountains_pk PRIMARY KEY (id)
);

-- Восхождения
CREATE TABLE climbing
(
    id                  SERIAL NOT NULL,
    climbing_start_date DATE   NOT NULL,
    climbing_end_date   DATE   NOT NULL,
    mountain_id         SERIAL NOT NULL,
    CONSTRAINT climbing_pk PRIMARY KEY (id),
    CONSTRAINT climbing_mountains_fk FOREIGN KEY (mountain_id) REFERENCES mountains (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX climbing_mountains_i ON climbing
    (
     mountain_id
        );

-- Связка восхождений и учавствующих в нем альпинистов
CREATE TABLE groups
(
    climbing_id SERIAL NOT NULL,
    climber_id  SERIAL NOT NULL,
    CONSTRAINT groups_pk PRIMARY KEY (climbing_id, climber_id),
    CONSTRAINT groups_climbing_fk FOREIGN KEY (climbing_id) REFERENCES climbing (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT groups_climbers_fk FOREIGN KEY (climber_id) REFERENCES climbers (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX groups_climbing_i ON groups
    (
     climbing_id
        );
CREATE INDEX groups_climbers_i ON groups
    (
     climber_id
        );