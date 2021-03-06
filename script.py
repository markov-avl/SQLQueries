import faker
import datetime

QUERY = 'INSERT INTO %s (%s) VALUES (%s);'

mountains = \
    """
    Эверест	8,848	29,029	Гималаи	Непал/Китай
    K2	8,612	28,255	Каракорум	Пакистан/Китай
    Канченджанга	8,586	28,169	Гималаи	Непал/Индия
    Лхоцзе	8,516	27,940	Гималаи	Непал – Альпинисты поднимаются на вершину Лхоцзе при восхождении на Эверест
    Макалу	8,485	27,838	Гималаи	Непал
    Cho Oyu	8,188	26,864	Гималаи	Непал – Считается "самым легким" восьмитысячником
    Дхаулагири	8,167	26,795	Гималаи	Непал – считается самым высоким в мире с 1808 по 1838 год
    Манаслу	8,163	26,781	Гималаи	Непал
    Нанга Парбат	8,126	26,660	Гималаи	Пакистан
    Аннапурна	8,091	26,545	Гималаи	Непал – Первое восхождение на восьмитысячник (1950)
    Гашербрум I (Скрытый пик; K5)	8,080	26,509	Каракорум	Пакистан/Китай – Первоначально назывался К5
    Брод-Пик	8,051	26,414	Каракорум	Пакистан/Китай
    Гашербрум II (K4)	8,035	26,362	Каракорум	Пакистан/Китай – Первоначально назывался К4
    Шишапангма	8,027	26,335	Гималаи	Китай
    Гашербрум III	7,952	26,089	Каракорум	Пакистан
    Gyachung Kang	7,952	26,089	Гималаи	Непал (Кхумбу)/Китай
    Аннапурна II	7,937	26,040	Гималаи	Непал
    Гашербрум IV (K3)	7,932	26,024	Каракорум	Пакистан
    Гималаи	7,893	25,896	Гималаи	Манаслу, Непал
    Дистагил Сар	7,885	25,869	Каракорум	Пакистан
    Нгади Чули	7,871	25,823	Гималаи	Манаслу, Непал
    Нупце	7,861	25,791	Гималаи	Массив Эверест, Непал
    Кхуньянг Чхиш	7,852	25,761	Каракорум	Пакистан
    Машербрум (К1)	7,821	25,659	Каракорум	Пакистан – Первоначально назывался К1
    Нанда Деви	7,816	25,643	Гималаи	Индия (Уттаракханд)
    Чомо Лонзо	7,804	25,604	Гималаи	Массив Макалу, Непал/Китай
    Батура Сар	7,795	25,574	Каракорум	Пакистан
    Канджут Сар	7,790	25,558	Каракорум	Пакистан
    Ракапоши	7,788	25,551	Каракорум	Пакистан
    Намча Барва	7,782	25,531	Гималаи	Китай
    Батура II	7,762	25,466	Каракорум	Пакистан
    Камет	7,756	25,446	Гималаи	Индия (Уттаракханд)
    Сальторо Кангри	7,742	25,400	Каракорум	Индия (Джамму и Кашмир)
    Батура III	7,729	25,358	Каракорум	Пакистан
    Янну	7,710	25,295	Гималаи	Кангченджанга, Непал
    Tirich Mir	7,708	25,289	Гиндукуш  	Пакистан – #1 в Гиндукуше
    Моламенцин	7,703	25,272	Гималаи	Shishapangma group, Китай
    Гурла Мандхата	7,694	25,243	Гималаи (Налаканкар)	Китай
    Сасер Кангри	7,672	25,171	Каракорум	Пакистан / Индия (Джамму и Кашмир)
    Чоголиса	7,665	25,148	Каракорум	Пакистан
    Конгур Таг	7,649	25,095	Памир или Куньлунь	Китай
    Шиспаре	7,611	24,970	Каракорум	Пакистан
    Silberzacken	7,597	24,925	Гималаи	Пакистан
    Чанцзе	7,583	24,879	Гималаи	Массив Эверест, Китай
    Тривор	7,577	24,859	Каракорум	Каракорум – Пакистан
    Гангхар Пуэнсум	7,570	24,836	Гималаи	Бутан/Китай
    Гунга-Шань	7,556	24,790	Дасюэ Шань  	Сычуань, Китай
    Аннапурна III	7,555	24,787	Гималаи	Непал
    Kula Kangri	7,554	24,783	Гималаи	Китай (возможно, также Бутан)
    Скайанг Кангри	7,545	24,754	Каракорум  	Пакистан
    Ляньканг Кангри	7,535	24,721	Гималаи  	Бутан/Китай
    Юкшин Гардан Сар	7,530	24,705	Каракорум	Пакистан
    Аннапурна IV	7,525	24,688	Гималаи	Непал
    Сасер Кангри II	7,518	24,665	Каракорум	Индия (Джамму и Кашмир)
    Мамостонг Кангри	7,516	24,659	Каракорум	Индия (Джамму и Кашмир)
    Музтаг Ата	7,509	24,636	Памир или Куньлунь	Китай (Синьцзян)
    Пик Исмоил Сомони	7,495	24,590	Горы Памира  	Таджикистан
    Сасер Кангри III	7,495	24,590	Каракорум	Индия (Джамму и Кашмир)
    Noshaq	7,492	24,580	Гиндукуш  	Пакистан/Афганистан – #1 в Афганистане
    Пумари Чхиш	7,492	24,580	Каракорум	Пакистан
    Passu Sar	7,476	24,528	Каракорум	Пакистан
    Пик Джонсон	7,462	24,482	Гималаи	Индия/Непал/Китай
    Малубитинг	7,458	24,469	Каракорум	Пакистан
    Гангапурна	7,455	24,459	Аннапурна Гималаи  	Непал
    Мучу Чхиш (Батура V)	7,453	24,452	Каракорум	Пакистан
    Дженгиш Чокусу	7,439	24,406	Тянь-Шань  	Китай/Кыргызстан – #1 в Тянь-Шане
    К12	7,428	24,370	Каракорум	Индия (Джамму и Кашмир)/Пакистан
    Sia Kangri	7,422	24,350	Каракорум	Пакистан
    Момхил Сар	7,414	24,324	Каракорум	Пакистан
    История	7,403	24,288	Гиндукуш	Пакистан
    Гент Кангри	7,401	24,281	Каракорум	Индия (Джамму и Кашмир)/Пакистан
    Пик Харамош	7,397	24,268	Каракорум	Пакистан
    Кабру	7,394	24,259	Гималаи	Канченджанга, Индия (Сикким)/Непал
    Ультар	7,388	24,239	Каракорум	Пакистан
    Римо I	7,385	24,229	Каракорум	Индия (Джамму и Кашмир)
    Шерпи Кангри	7,380	24,213	Каракорум	Пакистан
    Churen Himal	7,371	24,183	Гималаи	Непал
    Labuche Kang	7,367	24,170	Гималаи	недалеко от Чо Ойю, Непал/Китай
    Кират Чули	7,365	24,163	Гималаи	Граница Непала и Индии (Сикким)
    Скил Брум	7,360	24,147	Каракорум	Пакистан - Также может быть указан как 7,410 м
    Аби Гамин	7,355	24,131	Гималаи	Индия
    Гиммигела Чули	7,350	24,114	Гималаи	Граница Непала и Индии (Сикким)
    Сараграр	7,340	24,081	Гиндукуш	Пакистан
    Боджохагур Дуанасир	7,329	24,045	Каракорум	Пакистан
    Чамланг	7,319	24,012	Гималаи	Кхумбу, Непал
    Чонгтар Кангри	7,315	23,999	Каракорум	Пакистан
    Джомолхари / Чомолхари	7,314	23,996	Гималаи	Бутан/Китай
    Балторо Кангри	7,312	23,990	Каракорум	Пакистан
    Сигуанг Ри	7,308	23,976	Гималаи	Китай
    Summa Ri	7,302	23,957	Гималаи	Пакистан
    Корона	7,295	23,934	Каракорум	Китай (Синьцзян)
    Гьяла Пери	7,294	23,930	Гималаи	Китай
    Поронг Ри	7,292	23,924	Гималаи	Китай
    Baintha Brakk	7,285	23,901	Каракорум	Пакистан
    Ютмару Сар	7,283	23,894	Каракорум	Пакистан
    K6	7,282	23,891	Каракорум	Пакистан – Также известен как пик Балтистан
    Канпэнцин	7,281	23,888	Гималаи	Китай
    Пик Мана	7,272	23,858	Гималаи	Индия (Уттаракханд) – SSE of Kamet
    Музтагская башня	7,273	23,862	Каракорум	Пакистан
    Диран	7,257	23,809	Каракорум	Пакистан
    Апсарасас Кангри	7,245	23,770	Каракорум	Китай/Пакистан
    Лангтанг Лирунг	7,227	23,711	Гималаи	Непал
    Карцзян	7,221	23,691	Гималаи	Китай
    Аннапурна Южная	7,219	23,684	Гималаи	Непал
    Хартафу	7,213	23,665	Гималаи	Китай
    Туншаньцзябу	7,207	23,645	Гималаи	Бутан/Китай
    Лангтанг Ри	7,205	23,638	Гималаи	Непал/Китай
    Kangphu Kang	7,204	23,635	Гималаи	Бутан/Китай
    Сингхи Кангри	7,202	23,629	Гималаи	Индия/Китай
    Лупгар Сар	7,200	23,622	Каракорум	Пакистан
    Гурджа Гималаи	7,193	23,599	Гималаи	Непал
    Мелунгце	7,181	23,560	Гималаи Ролвалинга	Китай
    Люши-Шань	7,167	23,514	Куньлунь	Китай – #1 в Куньлунь
    Барунце	7,162	23,497	Гималаи	Кхумбу, Непал
    Пумори	7,161	23,494	Гималаи	Кхумбу, Непал
    Хардеол	7,151	23,461	Гималаи	Индия (Уттаракханд)
    Гашербрум В	7,147	23,448	Каракорум	Пакистан
    Латок I	7,145	23,442	Каракорум	Пакистан
    Кампире Диор	7,143	23,435	Каракорум	Пакистан
    Немджунг	7,140	23,425	Гималаи	Непал
    Удрен Зом	7,140	23,425	Гиндукуш	Пакистан
    Чаухамба	7,138	23,419	Гималаи	Индия (Уттаракханд)
    Nun Kun	7,135	23,409	Каракорум	Индия (Джамму и Кашмир)
    Пик Тиличо	7,134	23,406	Гималаи	Аннапурна Гималаи, Непал
    Гаури Санкар	7,134	23,406	Гималаи Ролвалинга	Непал/Китай
    Пик Ленина	7,134	23,406	Горы Памира  	Таджикистан-Кыргызстан – №2 на Памире
    Буларунг Сар	7,134	23,406	Каракорум	Пакистан
    API	7,132	23,399	Гималаи	Непал
    Teri Kang	7,124	23,373	Гималаи	Бутан
    Паухунри	7,128	23,386	Гималаи	Индия (Сикким)/Китай
    Трисул	7,120	23,360	Гималаи	Индия (Уттаракханд)
    Корженевская	7,105	23,310	Горы Памира	Таджикистан – #3 на Памире
    Лунпо Гангри	7,095	23,278	Гималаи (Gangdise)	Китай
    Сатопантх	7,075	23,212	Гималаи	Индия (Уттаракханд)
    Тирсули	7,074	23,209	Гималаи	Индия (Уттаракханд)
    Дунагири	7,066	23,182	Гималаи	Индия (Уттаракханд)
    Кангто	7,060	23,163	Гималаи	Индия (Аруначал-Прадеш)/Китай
    Nyegyi Kansang	7,047	23,120	Гималаи	Индия (Аруначал-Прадеш)/Китай
    Чомолхари Кан	7,046	23,117	Гималаи	Бутан
    Саласунго	7,043	23,107	Гималаи	Непал/Китай
    Ссылка Sar	7,041	23,100	Каракорум	Пакистан
    Пик Кежэнь	7,038	23,091	Каракорум	Китай (Синьцзян)
    Шах Дхар	7,038	23,091	Гиндукуш	Пакистан/Афганистан
    Сайпал	7,031	23,068	Гималаи	Непал
    Падманабх	7,030	23,064	Гималаи	Индия
    Спантик	7,027	23,054	Каракорум	Пакистан
    Сар Памри	7,016	23,018	Каракорум	Пакистан
    Хан-Тенгри	7,010	22,999	Тянь-Шань  	Кыргызстан-Казахстан-Китай – #2 в Тянь-Шане
    Пик Лайла	5,971	19,590	Гималаи	Пакистан
    Гора Логан	5,959	19,551	Горы Святого Ильи  	Юкон, Канада – Самая высокая в Канаде
    Альпамайо	5,947	19,511	Анды  	Перу
    Cerro Lípez	5,929	19,452	Анды  	Боливия
    Ликанкабур	5,920	19,423	Анды  	Боливия/Чили
    Фалак Сар	5,918	19,416	Гиндукуш	Пакистан
    Котопакси	5,897	19,347	Анды  	Эквадор – Второй по высоте в Эквадоре
    Гора Килиманджаро	5,895	19,341	Восточные рифтовые горы	Танзания – Самая высокая в Африке
    Hkakabo Razi	5,881	19,295	Гималаи  	Мьянма – Самая высокая в Мьянме и Юго-Восточной Азии
    San José	5,856	19,213	Анды  	Чили
    El Misti	5,822	19,101	Анды  	Перу
    Алтун-Шань	5,798	19,022	Алтын-Таг  	Ганьсу, Китай
    Кайамбе	5,790	18,996	Анды  	Эквадор – Третий по высоте в Эквадоре
    Pico Cristóbal Colón	5,776	18,950	Sierra Nevada de Santa Marta  	Колумбия – Самая высокая прибрежная гора
    Антисана	5,753	18,875	Анды  	Эквадор
    Nevado Pisco	5,752	18,871	Анды  	Перу
    Nevado Anallajsi	5,750	18,865	Анды  	Боливия
    Покалде	5,745	18,848	Кхумбу Гималаи  	Непал – 7 км юго-западнее Эвереста
    Убинас	5,672	18,609	Анды  	Перу – Действующий вулкан (2006)
    Пичу-Пичу	5,664	18,583	Анды  	Перу
    Гора Эльбрус	5,642	18,510	Кавказские горы  	Северный Кавказ, Россия – Самый высокий на Кавказе
    Пик Мехрбани	5,639	18,501	Каракорум  	Пакистан
    Pico de Orizaba	5,636	18,491	Транс-Мексиканский вулканический пояс  	Мексика – Самая высокая в Мексике
    Гора Дамаванд	5,610	18,406	Альборц  	Иран – Самый высокий в Иране и Я, самый высокий вулкан в Азии
    Невадо Мисми	5,597	18,363	Анды  	Перу – Ледниковый исток реки Амазонки
    Снежная гора Нефритового дракона	5,596	18,360	Горы Хенгдуань  	Юньнань, Китай
    Вулкан Ласкар	5,592	18,346	Анды  	Чили
    Гора Сюэбаодин	5,588	18,333	Минские горы  	Сычуань, Китай
    Кала Паттар	5,545	18,192	Кхумбу Гималаи  	Непал – Популярная вершина для треккинга
    Гора Святого Ильи	5,489	18,009	Горы Святого Ильи  	Юкон, Канада/Аляска, США – вторая по высоте в обеих странах
    Пик Конкорд	5,469	17,943	Горы Памира  	Афганистан–Таджикистан
    Диндав Рази	5,464	17,927	Гималаи	Мьянма
    Пик Мачой	5,458	17,907	Гималаи  	Индия (Джамму и Кашмир)
    El Plomo	5,450	17,881	Анды  	Чили
    Богда Фэн	5,445	17,864	Тянь-Шань  	Синьцзян, Китай
    Гора Малый Сюэбаодин	5,443	17,858	Минские горы  	Сычуань, Китай
    Cerro El Plomo	5,434	17,828	Анды  	Чили – Самая большая вершина, видимая из Сантьяго в ясные дни
    Popocatépetl	5,426	17,802	Транс-Мексиканский вулканический пояс  	Мексика – Вторая по высоте в Мексике
    Пик Колахой	5,425	17,799	Гималаи  	Индия (Джамму и Кашмир) – Самая высокая в Кашмирской долине
    Чакалтайя	5,421	17,785	Анды  	Боливия
    Гора Помиу	5,413	17,759	Хребет Цюнлай  	Сычуань, Китай
    Ритакуба Бланко	5,410	17,749	Анды  	Colombia
    Хаба Сюэшань	5,396	17,703	Гималаи  	Юньнань, Китай
    Nevado del Ruiz	5,389	17,680	Анды  	Колумбия – 23 000 человек погибли в извержении 1985 года
    Nevado del Huila	5,364	17,598	Анды  	Colombia
    El Altar	5,320	17,454	Анды  	Эквадор
    Гора Форейкер	5,304	17,402	Хребет Аляска  	Аляска, США
    Гора Харамух	5,300	17,388	Гималаи  	Индия (Джамму и Кашмир)
    Nevado del Tolima	5,276	17,310	Анды  	Colombia
    Майпо	5,264	17,270	Анды  	Аргентина/Чили
    Иллиниза	5,248	17,218	Анды  	Эквадор
    Точка 5240	5,240	17,192	Гималаи  	Джамму и Кашмир, Индия
    Пик Сирбал	5,236	17,178	Гималаи  	Долина Кашмира, Индия (Джамму и Кашмир)
    Сангай	5,230	17,159	Анды  	Эквадор
    Iztaccíhuatl	5,230	17,159	Транс-Мексиканский вулканический пояс  	Мексика – Третья по высоте в Мексике
    Гора Лукания	5,226	17,146	Горы Святого Ильи  	Юкон, Канада – третий по высоте в Канаде
    Пик Каракол	5,216	17,113	Тянь-Шань  	Кыргызстан
    Дых-Тау	5,205	17,077	Кавказские горы  	Северный Кавказ, Россия – Второй по высоте на Кавказе
    Шхара	5,201	17,064	Кавказские горы  	Грузия – Самая высокая в Грузии
    Гора Кения	5,199	17,057	  	Кения – Самая высокая в Кении, вторая по высоте в Африке
    Малика Парбат	5,190	17,028	Гималаи  	Долина Каган, Пакистан – Самая высокая в долине Каган Пакистана
    Пик Амарнатх	5,186	17,014	Гималаи  	Долина Кашмира, Индия (Джамму и Кашмир)
    Laram Q'awa (Charaña)	5,182	17,001	Анды  	Боливия
    Пик Кинг	5,173	16,972	Горы Святого Ильи  	Юкон, Канада – четвертый по высоте в Канаде
    Пик Бориса Ельцина	5,168	16,955	Тескей Ала-Тоо  	Кыргызстан
    Коштан-Тау	5,150	16,896	Кавказские горы  	Северный Кавказ, Россия
    Гора Арарат	5,137	16,854	  	Турция – Самая высокая в Турции
    Гора Стэнли	5,109	16,762	Горы Рувензори  	Демократическая Республика Конго/Уганда – третья по высоте в Африке
    Тами Рази	5,101	16,736	Гималаи	Мьянма
    Гора Стил	5,073	16,644	Горы Святого Ильи  	Юкон, Канада – пятый по высоте в Канаде
    Джанга	5,051	16,572	Кавказские горы  	Грузия / Северный Кавказ, Россия – Вторая по высоте в Грузии
    Гора Казбек	5,047	16,558	Кавказские горы  	Грузия – третья по высоте в стране
    Tungurahua	5,023	16,480	Анды  	Эквадор – Действующий вулкан
    Кариуайразо	5,018	16,463	Анды  	Эквадор
    Гора Бона	5,005	16,421	Горы Святого Ильи  	Аляска, США – также указывается как 5 030 м или 5 045 м
    """

if __name__ == '__main__':
    fake = faker.Faker('ru_RU')

    table = 'climbers'
    fields = 'name, surname, address'
    climbers_count = 0
    for _ in range(100):
        name, surname, *_ = fake.name().split()
        address = fake.address()[: -8]
        climbers_count += 1
        print(QUERY % (table, fields, f"'{name}', '{surname}', '{address}'"))
    print()

    table = 'mountains'
    fields = 'name, country, region, height'
    mountains_count = 0
    for line in mountains.split('\n'):
        try:
            name, height, _, region, country = map(str.strip, line.split('	'))
            if all(s in ' йцукенгшщзхъфывапролджэячсмитьбюёЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ' for s in
                   name + country + region):
                height = int(height.replace(',', ''))
                mountains_count += 1
                print(QUERY % (table, fields, f"'{name}', '{country}', '{region}', {height}"))
        except ValueError:
            pass
    print()

    table = 'climbing'
    fields = 'start_date, end_date, mountain_id'
    climbing_count = 0
    while climbing_count < 50:
        start_date = fake.date()
        year, *_ = map(int, start_date.split('-'))
        if year >= 2016:
            end_date = datetime.datetime.strptime(start_date, '%Y-%m-%d') + datetime.timedelta(
                fake.random.randint(7, 21))
            climbing_count += 1
            print(QUERY % (table, fields,
                           f"'{start_date}', '{end_date.strftime('%Y-%m-%d')}', "
                           f"{fake.random.randint(1, mountains_count)}"))
    print()

    table = 'groups'
    fields = 'climbing_id, climber_id'
    climbers = list(range(1, climbers_count + 1))
    for climbing_id in range(1, climbing_count + 1):
        fake.random.shuffle(climbers)
        for climber_id in climbers[: fake.random.randint(6, 20)]:
            print(QUERY % (table, fields, f"{climbing_id}, {climber_id}"))


