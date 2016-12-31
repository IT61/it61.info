# Places
PLACES_SQL = %"
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (1, 'Рабочее пространство \"MESTO\"', 'улица Максима Горького, 151', 47.226894, 39.714285, '2016-08-25 12:11:41.806837', '2016-08-25 12:11:41.806837');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (2, 'Креативное пространство CreativeSpace.pro', 'улица Суворова, 52А', 47.225193, 39.728838, '2016-08-26 09:04:34.626668', '2016-08-26 09:04:34.626668');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (3, 'Южный IT-парк', 'улица Суворова, 91', 47.226796, 39.732746, '2016-08-26 09:05:08.291215', '2016-08-26 09:05:08.291215');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (4, 'Учебный Центр «Эксперт»', 'улица Станиславского, 167/25', 47.222415, 39.735054, '2016-08-26 09:05:57.700912', '2016-08-26 09:05:57.700912');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (5, 'Отель «Атташе»', 'проспект Соколова, 19', 47.223883, 39.72069, '2016-08-26 09:06:23.073808', '2016-08-26 09:06:23.073808');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (6, 'Конгресс-отель «Амакс»', 'проспект Михаила Нагибина, 19', 47.248779, 39.711851, '2016-08-26 09:07:06.816933', '2016-08-26 09:07:06.816933');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (7, 'ИФЖиМКК ЮФУ', 'Университетский переулок, 93', 47.226766, 39.726808, '2016-08-26 09:07:56.474912', '2016-08-26 09:07:56.474912');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (8, 'База отдыха «Казачок»', 'Очаковская коса', 47.031146, 39.099065, '2016-08-26 09:09:26.087182', '2016-08-26 09:09:26.087182');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (9, 'Конгресс-отель «Дон-Плаза»', 'Большая Садовая улица, 115', 47.226117, 39.734327, '2016-08-26 09:09:40.030728', '2016-08-26 09:09:40.030728');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (10, 'Офис «Game Insight»', 'Таганрог, Петровская улица, 26', 47.207964, 38.941527, '2016-08-26 09:10:05.032555', '2016-08-26 09:10:05.032555');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (11, 'ДГТУ, 7 корпус', 'площадь Гагарина, 1', 47.237412, 39.712632, '2016-08-26 09:12:13.254869', '2016-08-26 09:12:13.254869');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (12, 'Бизнс-центр «Оптима Ленд»', 'Таганрог, улица Москатова, 31/2', 47.257317, 38.911308, '2016-08-26 09:13:02.004318', '2016-08-26 09:13:02.004318');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (13, 'Свободное пространство «Циферблат»', 'проспект Соколова, 46', 47.225872, 39.720466, '2016-08-26 09:13:41.476870', '2016-08-26 09:13:41.476870');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (14, 'DobroCowork University', 'улица 16-я Линия, 7В', 47.231355, 39.759354, '2016-08-26 09:14:22.045622', '2016-08-26 09:14:22.045622');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (15, 'AZIMUT Hotel Sochi 3*', 'Сочи, Континентальный проспект, 6', 43.402584, 39.973099, '2016-08-26 09:14:48.345412', '2016-08-26 09:14:48.345412');
INSERT INTO public.places (id, title, address, latitude, longitude, created_at, updated_at) VALUES (16, 'ДГТУ, Академия строительства и архитектуры', 'Социалистическая улица, 162/32', 47.223736, 39.732278, '2016-08-26 09:16:23.618108', '2016-08-26 09:16:23.618108');
SELECT setval('places_id_seq', COALESCE((SELECT MAX(id)+1 FROM places), 1), false);
"

ActiveRecord::Base.transaction do
  ActiveRecord::Base.connection.execute(PLACES_SQL)
end

# Groups
Group.create!(name: "Разработчик IT61", kind: 1)
Group.create!(name: "Команда IT61", kind: 2)
