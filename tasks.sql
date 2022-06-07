-- 2.1

-- 3. Напишите запрос, выбирающий все данные из таблицы STUDENT, расположив столбцы таблицы в следующем порядке: KURS,
-- SURNAME, NAME, STIPEND
SELECT kurs, surname, name, stipend
FROM student;

-- 9. Напишите запрос, который выполняет вывод списка университетов, рейтинг которых превышает 300 баллов.
SELECT univ_name
FROM university
WHERE rating > 300;

-- 16. Напишите запрос для получения списка университетов, расположенных в Москве и имеющих рейтинг меньший, чем у ВГУ.
-- Константу в ограничении на рейтинг можно определить по этой же таблице.
WITH vgu (rating) AS (SELECT rating
                      FROM university
                      WHERE univ_name = 'Воронежский государственный университет')
SELECT univ_name
FROM university,
     vgu
WHERE city = 'Москва'
  AND university.rating < vgu.rating;


-- 2.2

-- 1. Напишите запрос, выполняющий вывод находящихся в таблице EXAM_MARKS номеров предметов обучения, экзамены по
-- которым сдавались между 10 и 20 января 2000 г.
SELECT exam_id
FROM exam_marks
WHERE exam_date BETWEEN '01-10-2000' AND '01-20-2000';

-- 2. Напишите запрос, выбирающий данные обо всех предметах обучения, экзамены по которым сданы студентами, имеющими
-- идентификаторы 12 и 32.
SELECT subject.*
FROM subject
         INNER JOIN exam_marks on subject.subj_id = exam_marks.subj_id
WHERE student_id IN (12, 32);

-- 4. Напишите запрос, выбирающий сведения о студентах, у которых имена начинаются на букву ‘И’ или ‘С’.
SELECT *
FROM student
WHERE name LIKE 'И%'
   OR name LIKE 'С%';


-- 2.3

-- 1. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица содержала один столбец, содержащий
-- последовательность разделенных символом “;” (точка с запятой) значений всех столбцов этой таблицы; при этом
-- текстовые значения должны отображаться прописными символами (верхний регистр), т. е. быть представленными в
-- следующем виде: 10;КУЗНЕЦОВ;БОРИС;0;БРЯНСК;8.12.1987;10.
SELECT student_id || ';' || UPPER(surname) || ';' || UPPER(name) || ';' || stipend || ';' || kurs || ';' ||
       UPPER(city) || ';' || TO_CHAR(birthday, 'dd.mm.yyyy') || ';' || univ_id as data
FROM student;

-- 4. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица содержала всего один столбец в
-- следующем виде: Борис Кузнецов родился в 1987 году.
SELECT name || ' ' || surname || ' родился(-ась) в ' || EXTRACT(YEAR FROM birthday) || ' году' as data
FROM student;


-- 7. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица содержала всего один столбец в
-- следующем виде: Код-10; ВГУ-г.ВОРОНЕЖ; Рейтинг=296.
SELECT 'Код-' || univ_id || '; ' || univ_name || '-г.' || UPPER(city) || '; Рейтинг=' || rating as data
FROM university;


-- 2.4

-- 4. Напишите запрос, который для каждого студента выполняет выборку его идентификатора и максимальной из полученных
-- им оценок.
SELECT student_id, MAX(mark) as max_mark
FROM exam_marks
GROUP BY student_id;

-- 11. Напишите запрос для определения количества предметов, изучаемых на каждом курсе.
SELECT DIV(semester, 2) + MOD(semester, 2) as kurs, COUNT(subj_id) as subject_count
FROM subject
GROUP BY DIV(semester, 2) + MOD(semester, 2);

-- 23. Для каждого дня сдачи экзаменов напишите запрос, выводящий общее количество студентов, сдававших экзамены.
SELECT exam_date, COUNT(student_id) as student_count
FROM exam_marks
GROUP BY exam_date;


-- 2.7

-- 1. Предположим, что стипендия всем студентам увеличена на 20%. Напишите запрос к таблице STUDENT, выполняющий вывод
-- номера студента, его фамилии и величины увеличенной стипендии. Выходные данные упорядочите:
-- а) по значению последнего столбца (величине стипендии);
SELECT student_id, surname, stipend * 1.2 as new_stipend
FROM student
ORDER BY new_stipend;
-- б) в алфавитном порядке фамилий студентов.
SELECT student_id, surname, stipend * 1.2 as new_stipend
FROM student
ORDER BY surname;

-- 3. Напишите запрос, выполняющий вывод списка предметов обучения. Поле семестра в выходных данных должно быть первым,
-- за ним должны следовать имя предмета обучения и идентификатор предмета:
-- а) в порядке убывания семестров;
SELECT semester, subj_name, subj_id
FROM subject
ORDER BY semester DESC;
-- б) в порядке возрастания количества отводимых на предмет часов.
SELECT semester, subj_name, subj_id
FROM subject
ORDER BY hour DESC;

-- 5. Напишите запрос, который для каждой даты сдачи экзаменов выполняет:
-- а) вывод среднего балла в порядке убывания;
SELECT exam_date, AVG(mark) as average_mark
FROM exam_marks
GROUP BY exam_date
ORDER BY average_mark DESC;
-- б) вывод минимального балла в порядке убывания;
SELECT exam_date, MIN(mark) as minimum_mark
FROM exam_marks
GROUP BY exam_date
ORDER BY minimum_mark DESC;
-- в) вывод максимального балла в порядке убывания.
SELECT exam_date, MAX(mark) as maximum_mark
FROM exam_marks
GROUP BY exam_date
ORDER BY maximum_mark DESC;


-- 2.8

-- 2. Напишите запрос, выводящий список студентов, получающих стипендию, превышающую среднее значение стипендии.
SELECT name, surname, stipend
FROM student
WHERE stipend > (SELECT AVG(stipend)
                 FROM student);

-- 4. Напишите запрос, выводящий список предметов, на изучение которых отведено максимальное количество часов.
SELECT subj_name, hour
FROM subject
WHERE hour = (SELECT MAX(hour)
              FROM subject);

-- 5. Напишите запрос, выполняющий вывод имен и фамилий студентов, место проживания которых не совпадает с городом,
-- в котором находится их университет.
SELECT name, surname
FROM student
WHERE student.city != (SELECT university.city
                       FROM university
                       WHERE student.univ_id = university.univ_id);


-- 2.9

-- 2. Напишите запрос для получения списка иногородних студентов (обучающихся не в своем городе), с последующей
-- сортировкой по идентификаторам университетов и курсам.
SELECT student.*
FROM student,
     university
WHERE student.city != university.city
  AND student.univ_id = university.univ_id
ORDER BY student.univ_id, student.kurs;

-- 6. Напишите запрос для получения списка студентов, получающих минимальную стипендию в своем университете, с
-- последующей сортировкой по значениям идентификатора университета и стипендии.
SELECT students.*
FROM student students,
     (SELECT univ_id, MIN(stipend) as minimum
      FROM student
      GROUP BY univ_id) stipends
WHERE students.univ_id = stipends.univ_id
  AND students.stipend = stipends.minimum
ORDER BY students.univ_id, students.stipend;

-- 11. Напишите запрос, выполняющий вывод списка студентов, средняя оценка которых превышает 4 балла.
SELECT student.*
FROM student,
     (SELECT student_id, AVG(mark) as average
      FROM exam_marks
      GROUP BY student_id) marks
WHERE student.student_id = marks.student_id
  AND marks.average > 4;


-- 2.10

-- 2. Напишите запрос, выбирающий имена всех студентов, имеющих по предмету c идентификатором 1 балл выше общего
-- среднего балла.
WITH marks (average) AS (SELECT AVG(mark)
                         FROM exam_marks)
SELECT name, surname
FROM student,
     exam_marks,
     marks
WHERE mark > marks.average
  AND student.student_id = exam_marks.student_id
  AND subj_id = 1;

-- 4. Напишите запрос, выполняющий вывод количества предметов, по которым экзаменовался каждый студент, сдававший более
-- 5 предметов.
SELECT COUNT(DISTINCT subj_id) as subject_count
FROM exam_marks
GROUP BY student_id
HAVING COUNT(subj_id) > 5;

-- 6. Напишите запрос, который позволяет вывести имена и идентификаторы всех студентов, о которых точно известно, что
-- они проживают в городе, где нет ни одного университета.
SELECT name || ' ' || surname as name, student_id
FROM student
WHERE city NOT IN (SELECT DISTINCT city
                   FROM university);


-- 2.11

-- 4. Напишите запрос, выбирающий из таблицы SUBJECT данные о названиях предметов обучения, экзамены по которым сданы
-- более чем одним студентом.
SELECT subj_name
FROM subject
WHERE (SELECT COUNT(DISTINCT student_id)
       FROM exam_marks
       WHERE subject.subj_id = exam_marks.subj_id
         AND exam_marks.mark > 2) > 1;

-- 10. Напишите запрос для получения списка университетов, в которых не работает ни один преподаватель.
SELECT univ_name
FROM university
WHERE NOT EXISTS(SELECT 1
                 FROM lecturer
                 WHERE lecturer.univ_id = university.univ_id);

-- 17. Напишите запрос, выполняющий вывод имен и фамилий студентов, не получивших ни одной отличной оценки.
SELECT name, surname
FROM student
WHERE NOT EXISTS(SELECT 1
                 FROM exam_marks
                 WHERE exam_marks.student_id = student.student_id
                   AND mark = 5);


-- 2.12

-- 2. Напишите запрос, выполняющий вывод имен и фамилий студентов, имеющих весь набор положительных (тройки, четверки и
-- пятерки) оценок.
SELECT name, surname
FROM student
WHERE 3 IN (SELECT DISTINCT mark
            FROM exam_marks
            WHERE exam_marks.student_id = student.student_id)
  AND 4 IN (SELECT DISTINCT mark
            FROM exam_marks
            WHERE exam_marks.student_id = student.student_id)
  AND 5 IN (SELECT DISTINCT mark
            FROM exam_marks
            WHERE exam_marks.student_id = student.student_id);

-- 5. Напишите запрос, выполняющий вывод данных о предметах обучения, которые преподает Колесников.
WITH kolesnikov (id) AS (SELECT lecturer_id
                         FROM lecturer
                         WHERE surname = 'Колесников')
SELECT subject.*
FROM subject,
     kolesnikov
WHERE subj_id IN (SELECT subj_lect.subj_id
                  FROM subj_lect
                  WHERE subj_lect.lecturer_id = kolesnikov.id);

-- 9. Напишите запрос, выполняющий вывод списка фамилий студентов, имеющих только отличные оценки и проживающих в
-- городе, не совпадающем с городом их университета.
SELECT DISTINCT surname
FROM student
WHERE 5 = ALL (SELECT mark
               FROM exam_marks
               WHERE exam_marks.student_id = student.student_id)
  AND city != (SELECT city
               FROM university
               WHERE university.univ_id = student.univ_id);


-- 2.13

-- 1. Ниже приведены два варианта запроса, выполняющего вывод количества студентов, имеющих только отличные оценки.
-- SELECT COUNT(DISTINCT STUDENT_ID)
-- FROM EXAM_MARKS S
-- WHERE NOT EXISTS (SELECT *
--                   FROM EXAM_MARKS
--                   WHERE STUDENT_ID=S.STUDENT_ID AND MARK<5);
-- SELECT COUNT(*)
-- FROM (SELECT STUDENT_ID, MIN(MARK)
--       FROM EXAM_MARKS
--       GROUP BY STUDENT_ID
--       HAVING MIN(MARK)=5);
-- Всегда ли эти запросы будут выдавать одинаковые результаты?

-- Первый запрос не будет обрабатывать студентов, у которых вместо оценки стоит NULL, из-за конструкции NOT EXISTS, в
-- то время как второй запрос будет обрабатывать такие случаи.


-- 2.14

-- 1. Напишите запрос, выбирающий данные о названиях университетов, рейтинг которых равен или превосходит рейтинг ВГУ.
SELECT univ_name
FROM university
WHERE rating >= ANY (SELECT rating
                     FROM university
                     WHERE univ_name = 'Воронежский государственный университет');

-- 2. Напишите запрос с использованием ANY или ALL, выполняющий выборку данных о студентах, у которых в городе их
-- постоянного местожительства нет университета.
SELECT *
FROM student
WHERE city != ANY (SELECT city
                   FROM university);

-- 3. Напишите запрос, выбирающий из таблицы EXAM_MARKS названия предметов обучения, для которых все оценки (поле MARK)
-- превышают любые оценки по предмету, имеющему идентификатор 1.
WITH some_subject (max_mark) AS (SELECT MAX(mark)
                                 FROM exam_marks
                                 WHERE subj_id = 1)
SELECT subj_name
FROM subject,
     some_subject
WHERE NOT EXISTS(SELECT 1
                 FROM exam_marks
                 WHERE exam_marks.subj_id = subject.subj_id
                   AND exam_marks.mark < some_subject.max_mark);


-- 2.15

-- 1. Напишите запрос для получения списка предметов вместе с фамилиями студентов, изучающих их на соответствующем
-- курсе.
SELECT subject.subj_name, student.surname
FROM subject,
     student
WHERE subject.semester = student.kurs * 2 - 1
   OR subject.semester = student.kurs * 2;

-- 2. Напишите запрос, выполняющий вывод имен и фамилий студентов, имеющих весь набор положительных (тройки, четверки и
-- пятерки) оценок.
SELECT name, surname
FROM student,
     exam_marks
WHERE student.student_id = exam_marks.student_id
  AND exam_marks.mark > 2;


-- 2.15.1

-- 4. Напишите запрос для получения списка университетов вместе с названиями преподаваемых в них предметов.
SELECT univ_name, subj_name
FROM university,
     lecturer,
     subj_lect,
     subject
WHERE university.univ_id = lecturer.univ_id
  AND lecturer.lecturer_id = subj_lect.lecturer_id
  AND subj_lect.subj_id = subject.subj_id;

-- 9. Напишите запрос для получения списка университетов вместе с фамилиями самых молодых студентов, обучаемых в них.
SELECT univ_name, surname
FROM student,
     university
WHERE student.univ_id = university.univ_id
  AND birthday = (SELECT MAX(birthday)
                  FROM student
                  WHERE student.univ_id = university.univ_id);

-- 16. Напишите запрос для получения списка преподавателей, преподающих только один предмет.
SELECT name, surname
FROM lecturer,
     subj_lect sl
WHERE lecturer.lecturer_id = sl.lecturer_id
  AND NOT EXISTS(SELECT *
                 FROM subj_lect
                 WHERE lecturer.lecturer_id = subj_lect.lecturer_id
                   AND subj_id != sl.subj_id);


-- 2.15.2

-- 3. Напишите запрос для получения списка преподавателей с указанием нагрузки (суммарного количества часов) в каждом
-- семестре.
SELECT lecturer.name, lecturer.surname, subject.semester, SUM(subject.hour) as hours
FROM lecturer
         INNER JOIN subj_lect ON subj_lect.lecturer_id = lecturer.lecturer_id
         INNER JOIN subject ON subject.subj_id = subj_lect.subj_id
GROUP BY lecturer.lecturer_id, subject.semester;

-- 10. Напишите запрос для получения списка университетов вместе с фамилиями студентов, получающих максимальную для
-- каждого университета стипендию.
WITH max_stipend (value) AS (SELECT MAX(stipend)
                             FROM student)
SELECT university.univ_name, student.surname
FROM max_stipend,
     university
         INNER JOIN student ON student.univ_id = university.univ_id
WHERE student.stipend = max_stipend.value;

-- 19. Напишите запрос, выполняющий вывод имен и фамилий студентов, получивших хотя бы одну отличную оценку.
SELECT DISTINCT student.student_id, name, surname
FROM student
         INNER JOIN exam_marks ON exam_marks.student_id = student.student_id
WHERE exam_marks.mark = 5;


-- 2.15.3

-- 3. Напишите запрос, который позволяет получить названия университетов с рейтингом, не меньшим рейтинга ВГУ, и
-- городов, в которых они расположены.
WITH vgu (rating) AS (SELECT rating
                      FROM university
                      WHERE univ_name = 'Воронежский государственный университет')
SELECT university.univ_name, university.rating, university.city
FROM university,
     vgu
WHERE university.rating >= vgu.rating;

-- 4. Напишите запрос, выполняющий выборку идентификаторов студентов, имеющих такие же оценки, что и студент с
-- идентификатором 12.
WITH some_student (count, sum) AS (SELECT COUNT(mark), SUM(mark)
                                   FROM exam_marks
                                   WHERE student_id = 12)
SELECT exam_marks.student_id
FROM exam_marks,
     some_student
GROUP BY student_id, count, sum
HAVING COUNT(exam_marks.mark) = some_student.count
   AND SUM(exam_marks.mark) = some_student.sum;

-- 5. Напишите запрос, выполняющий выборку всех пар идентификаторов преподавателей, ведущих один и тот же предмет
-- обучения.
SELECT sl1.lecturer_id, sl2.lecturer_id
FROM subj_lect sl1,
     subj_lect sl2
WHERE sl1.subj_id = sl2.subj_id
  AND sl1.lecturer_id != sl2.lecturer_id;


-- 2.16.2

-- 1. Создайте объединение двух запросов, которые выдают значения полей UNIV_NAME, CITY, RATING для всех университетов.
-- Те из них, у которых рейтинг равен или выше 300, должны иметь комментарий ‘высокий’, все остальные — ‘низкий’.
SELECT univ_name, city, rating, 'низкий' as commentary
FROM university
WHERE rating < 300
UNION
SELECT univ_name, city, rating, 'высокий' as commentary
FROM university
WHERE rating >= 300;

-- 5. Для каждого города выведите названия университетов с минимальным и максимальным для данного города рейтингом.
-- Пометьте строки списка словами ‘min’ и ‘max’, поместив их в дополнительном столбце.
WITH city_universities (city, min_rating, max_rating) AS (SELECT city, MIN(rating), MAX(rating)
                                                          FROM university
                                                          GROUP BY city)
SELECT university.city, univ_name, rating, 'min' as assessment
FROM university,
     city_universities
WHERE university.city = city_universities.city
  AND university.rating = city_universities.min_rating
UNION
SELECT university.city, univ_name, rating, 'max' as assessment
FROM university,
     city_universities
WHERE university.city = city_universities.city
  AND university.rating = city_universities.max_rating;

-- 6. Для каждого курса выведите фамилии студентов, получающих минимальные и максимальные на их курсе стипендии.
-- Пометьте строки списка словами ‘min’ и ‘max’, поместив их в дополнительном столбце.
WITH kurs_stipends (kurs, min_stipend, max_stipend) AS (SELECT kurs, MIN(stipend), MAX(stipend)
                                                        FROM student
                                                        GROUP BY kurs)
SELECT kurs_stipends.kurs, surname, stipend, 'min' as assessment
FROM student,
     kurs_stipends
WHERE student.kurs = kurs_stipends.kurs
  AND student.stipend = kurs_stipends.min_stipend
UNION
SELECT kurs_stipends.kurs, surname, stipend, 'max' as assessment
FROM student,
     kurs_stipends
WHERE student.kurs = kurs_stipends.kurs
  AND student.stipend = kurs_stipends.max_stipend;


-- 3.1

-- 1. Напишите команду, которая вводит в таблицу SUBJECT строку для нового предмета обучения со следующими значениями
-- полей: SEMESTER = 4; SUBJ_NAME = ‘Алгебра’; HOUR = 72; SUBJ_ID = 201.
INSERT INTO subject
VALUES (201, 'Алгебра', 72, 4);

-- 2. Введите запись для нового студента, которого зовут Орлов Николай, обучающегося на первом курсе ВГУ,
-- живущего в Воронеже, сведения о дате рождения и размере стипендии неизвестны.
INSERT INTO student
VALUES ((SELECT MAX(student_id) FROM student) + 1, 'Орлов', 'Николай', NULL, 1, 'Воронеж', NULL, 40)

-- 3. Напишите команду, удаляющую из таблицы EXAM_MARKS записи обо всех оценках студента, идентификатор которого
-- равен 100.
DELETE
FROM exam_marks
WHERE student_id = 100;


-- 3.2.3

-- 1. Пусть существует таблица с именем STUDENT1, определения столбцов которой полностью совпадают с определениями
-- столбцов таблицы STUDENT. Вставьте в эту таблицу сведения о студентах, успешно сдавших экзамены более чем по пяти
-- предметам обучения.
INSERT INTO student1
SELECT *
FROM student
WHERE (SELECT COUNT(subj_id)
       FROM exam_marks
       WHERE exam_marks.student_id =
             student.student_id
         AND mark > 2) > 5;

-- 2. Напишите команду, удаляющую из таблицы SUBJECT1 сведения о предметах обучения, по которым студентами не получено
-- ни одной оценки.
DELETE
FROM subject1
WHERE NOT EXISTS(SELECT COUNT(mark)
                 FROM exam_marks,
                      subject
                 WHERE exam_marks.subj_id = subject.subj_id);

-- 3. Напишите запрос, увеличивающий размер стипендии на 20% всем студентам, у которых общая сумма баллов превышает
-- значение 50.
UPDATE student
SET stipend = stipend * 1.2
WHERE (SELECT SUM(mark)
       FROM exam_marks
       WHERE exam_marks.student_id = student.student_id) > 50;


-- 4.4

-- 4. Напишите команду CREATE TABLE для создания таблицы EXAM_MARKS1.
CREATE TABLE exam_marks1
(
    exam_id    INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    subj_id    INTEGER NOT NULL,
    mark       INTEGER,
    exam_date  DATE
);

-- 5. Напишите команду CREATE TABLE для создания таблицы SUBJ_LECT1.
CREATE TABLE subj_lect1
(
    lecturer_id INTEGER NOT NULL,
    subj_id     INTEGER NOT NULL
);

-- 6. Напишите команду, которая позволит быстро выбрать данные о студентах по курсам, на которых они учатся.
CREATE INDEX stud ON student (kurs);


-- 4.5.9

-- 1. Создайте таблицу EXAM_MARKS так, чтобы не допускался ввод в таблицу двух записей об оценках одного студента по
-- конкретным экзамену и предмету обучения, а также, чтобы не допускалось проведение двух экзаменов по любым предметам
-- в один день.
CREATE TABLE exam_marks
(
    exam_id    INTEGER NOT NULL,
    subj_id    INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    mark       INTEGER,
    exam_date  DATE    NOT NULL,
    CONSTRAINT constraint1
        UNIQUE (exam_id, subj_id, student_id),
    CONSTRAINT constraint2
        UNIQUE (exam_id, exam_date)
);

-- 2. Создайте таблицу предметов обучения SUBJECT так, чтобы количество отводимых на предмет часов по умолчанию было
-- равно 36, не допускались записи с отсутствующим количеством часов, поле SUBJ_ID являлось первичным ключом таблицы,
-- а значения семестров (поле SEMESTR) лежали в диапазоне от 1 до 12.
CREATE TABLE subject
(
    subj_id   INTEGER PRIMARY KEY,
    subj_name CHAR(25),
    hour      INTEGER DEFAULT 36 NOT NULL,
    semester  INTEGER CHECK (semester
        BETWEEN 1 AND 12)
);

-- 3. Создайте таблицу EXAM_MARKS таким образом, чтобы значения поля EXAM_ID были больше значений поля SUBJ_ID, а
-- значения поля SUBJ_ID были больше значений поля STUDENT_ID; пусть также будут запрещены значения NULL в любом из
-- этих трех полей.
CREATE TABLE exam_marks
(
    exam_id    INTEGER NOT NULL,
    subj_id    INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    CONSTRAINT constraint1
        CHECK (((exam_id > subj_id) AND
                (subj_id > student_id)))
);


-- 4.6.10

-- 3. Создайте таблицу с именем SUBJ_LECT_1 как в предыдущем задании (Создайте таблицу с именем SUBJ_LECT_1 (учебные
-- дисциплины преподавателей), с полями LECTURER_ID (идентификатор преподавателя) и SUBJ_ID (идентификатор предмета
-- обучения). Первичным ключом (составным) таблицы является пара атрибутов LECTURER_ID и SUBJ_ID; кроме того, поле
-- LECTURER_ID является внешним ключом, ссылающимся на таблицу LECTURER_1, аналогичную таблице LECTURER
-- (преподаватель), а поле SUBJ_ID является внешним ключом, ссылающимся на таблицу SUBJECT_1, аналогичную таблице
-- SUBJECT), но добавьте для всех ее внешних ключей режим обеспечения ссылочной целостности, запрещающий обновление и
-- удаление соответствующих родительских ключей.
CREATE TABLE subj_lect_1
(
    lecturer_id INTEGER NOT NULL,
    subj_id     INTEGER NOT NULL,
    CONSTRAINT subj_id
        PRIMARY KEY (lecturer_id, subj_id),
    CONSTRAINT lecturer_id_foreign_key
        FOREIGN KEY (lecturer_id)
            REFERENCES lecturer_1 ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT subject_id_foreign_key FOREIGN KEY (subj_id)
        REFERENCES subject_1 ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- 7. Создайте таблицу с именем STUDENT_1. Она должна содержать те же поля, что и таблица STUDENT, и новое поле
-- SENIOR_STUDENT (староста), значением которого должен быть идентификатор студента, являющегося старостой группы, в
-- которой учится данный студент. Укажите необходимые для этого ограничения ссылочной целостности.
CREATE TABLE student_1
(
    student_id     INTEGER PRIMARY KEY,
    surname        CHAR(25),
    name           CHAR(10),
    stipend        INTEGER,
    kurs           INTEGER,
    city           CHAR(15),
    birthday       DATE,
    univ_id        INTEGER
        REFERENCES university (univ_id),
    senior_student INTEGER
        REFERENCES student (student_id)
);

-- 8. Создайте таблицу STUDENT_2, аналогичную таблице STUDENT, в которой поле UNIV_ID (идентификатор университета)
-- является внешним ключом, ссылающимся на таблицу UNIVERSITY_1, таким образом, чтобы при удалении из таблицы
-- UNIVERSITY_1 строки с информацией о каком-либо университете в соответствующих записях таблицы STUDENT_2 поле
-- UNIV_ID очищалось (замещалось на NULL).
CREATE TABLE student_1
(
    student_id INTEGER PRIMARY KEY,
    surname    CHAR(25),
    name       CHAR(10),
    stipend    INTEGER,
    kurs       INTEGER,
    city       CHAR(15),
    birthday   DATE,
    univ_id    INTEGER
        REFERENCES university ON DELETE SET NULL
);


-- 5.7

-- 1. Создайте представление для получения сведений обо всех студентах, имеющих только отличные оценки.
CREATE VIEW excellent_students AS
SELECT student.*
FROM exam_marks
         INNER JOIN student ON student.student_id = exam_marks.student_id
GROUP BY student.student_id
HAVING MIN(mark) = 5;

-- 2. Создайте представление для получения сведений о количестве студентов в каждом городе.
CREATE VIEW students_city_count AS
SELECT city, COUNT(student_id) as count
FROM student
WHERE city IS NOT NULL
GROUP BY city;

-- 4. Создайте представление для получения сведений о количестве экзаменов, которые сдавал каждый студент.
CREATE VIEW students_exam_count AS
SELECT student_id, COUNT(mark) as count
FROM exam_marks
GROUP BY student_id;


-- 5.9

-- 1. Какие из представленных ниже представлений являются обновляемыми?
-- а) CREATE VIEW DAILYEXAM AS
--    SELECT DISTINCT STUDENT_ID, SUBJ_ID, MARK, EXAM_DATE
--    FROM EXAM_MARKS;
-- б) CREATE VIEW CUSTALS AS
--    SELECT SUBJECT.SUBJ_ID, SUM (MARK) AS MARK1
--    FROM SUBJECT,
--         EXAM_MARKS
--    WHERE SUBJECT.SUBJ_ID = EXAM_MARKS.SUBJ_ID
--    GROUP BY SUBJECT.SUBJ_ID;
-- в) CREATE VIEW THIRDEXAM AS
--    SELECT *
--    FROM DAILYEXAM
--    WHERE EXAM_DATE = ‘10/02/1999’;
-- г) CREATE VIEW NULLCITIES AS
--    SELECT STUDENT_ID, SURNAME, CITY
--    FROM STUDENT
--    WHERE CITY IS NULL
--       OR SURNAME BETWEEN ‘А’ AND ‘Д’;

-- Ответ: а, г


-- 2. Создайте представление таблицы STUDENT с именем STIP, включающее поля STIPEND и STUDENT_ID и позволяющее вводить
-- или изменять значение поля STIPEND (стипендия), но только в пределах от 100 до 200.
CREATE VIEW stip AS
SELECT stipend, student_id
FROM student
WHERE stipend BETWEEN 100 AND 200
WITH CHECK OPTION;


-- 6.9

-- 1. Передайте пользователю PETROV право на изменение оценок студентов в базе данных.
GRANT UPDATE ON exam_marks TO petrov;

-- 2. Передайте пользователю SIDOROV право передавать другим пользователям права на осуществление запросов к таблице
-- EXAM_MARKS.
GRANT SELECT ON exam_marks TO sidorov
    WITH GRANT OPTION;

-- 3. Отмените привилегию INSERT по отношению к таблице STUDENT у пользователя IVANOV и у всех других пользователей,
-- которым привилегия, в свою очередь, была предоставлена этим пользователем IVANOV.
REVOKE INSERT ON student FROM ivanod;


-- 6.12

-- 1. Пользователь IVANOV передал Вам право SELECT в таблице EXAM_MARKS. Запишите команду, позволяющую Вам обращаться
-- к этой таблице, используя имя EXAM_MARKS без префикса.
CREATE SYNONYM exam_marks FOR ivanov.exam_marks;

-- 2. Вы передали право SELECT в таблице EXAM_MARKS пользователю IVANOV. Запишите команду, позволяющую ему обращаться к
-- этой таблице, используя имя EXAM_MARKS без префикса.
CREATE PUBLIC SYNONYM exam_marks FOR exam_marks;