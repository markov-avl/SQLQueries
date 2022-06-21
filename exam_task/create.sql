-- Задача 3. База данных “Хроники восхождений” в альпинистском клубе.

-- В базе данных должны записываться даты начала и завершения каждого восхождения, имена и адреса участвовавших в нем
-- альпинистов, название и высота горы, страна и район, где эта гора расположена. Присвойте выразительные имена
-- таблицам и полям для хранения указанной информации. Написать запросы, осуществляющие следующие операции.

-- Создание базы данных
-- CREATE DATABASE climbing_chronicles;

DROP TABLE IF EXISTS climbers CASCADE;
DROP TABLE IF EXISTS mountains CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS group_members CASCADE;

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

-- Группы для восхождений
CREATE TABLE groups
(
    id          SERIAL      NOT NULL,
    name        VARCHAR(32) NOT NULL,
    start_date  DATE        NOT NULL,
    end_date    DATE        NULL,
    mountain_id SERIAL      NOT NULL,
    CONSTRAINT groups_pk PRIMARY KEY (id),
    CONSTRAINT groups_mountains_fk FOREIGN KEY (mountain_id) REFERENCES mountains (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX groups_mountains_i ON groups
    (
     mountain_id
        );

-- Связка восхождений и учавствующих в нем альпинистов
CREATE TABLE group_members
(
    group_id   SERIAL NOT NULL,
    climber_id SERIAL NOT NULL,
    CONSTRAINT group_members_pk PRIMARY KEY (group_id, climber_id),
    CONSTRAINT group_members_groups_fk FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT group_members_climbers_fk FOREIGN KEY (climber_id) REFERENCES climbers (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX group_members_groups_i ON group_members
    (
     group_id
        );
CREATE INDEX group_members_climbers_i ON group_members
    (
     climber_id
        );