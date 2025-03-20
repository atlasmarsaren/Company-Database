/* soru-1 */

CREATE DATABASE sirket ON PRIMARY
(
NAME = vtys_data,
FILENAME = 'C:\sirket\data.mdf',
SIZE = 8MB,
MAXSIZE = unlimited,
FILEGROWTH = 10%
)
LOG ON
(
NAME = vtys_log,
FILENAME = 'C:\sirket\log.ldf',
SIZE = 8MB,
MAXSIZE = unlimited,
FILEGROWTH = 10%
)

use sirket 

CREATE TABLE birimler (
	birim_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	birim_ad CHAR(25) NOT NULL
);

CREATE TABLE calisanlar (
	calisan_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ad CHAR(25),
	soyad CHAR(25),
	maas INT,
	katılmaTarihi DATETIME,
	calısan_birim_id INT FOREIGN KEY REFERENCES birimler(birim_id) NOT NULL
);

CREATE TABLE ikramiye(
	ikramiye_calisan_id INT FOREIGN KEY REFERENCES calisanlar(calisan_id) NOT NULL,
	ikramiye_ucret INT,
	ikramiye_tarih DATETIME
);

CREATE TABLE unvan(
	unvan_calisan_id INT FOREIGN KEY REFERENCES calisanlar(calisan_id) NOT NULL,
	unvan_calisan CHAR(25),
	unvan_tarih DATETIME
);

/* soru-2 */ 
INSERT INTO birimler(birim_ad) 
VALUES
('Yazılım'),
('Donanım'),
('Güvenlik');

SELECT * FROM birimler

INSERT INTO calisanlar(ad, soyad, maas, katılmaTarihi, calısan_birim_id) 
VALUES
('İsmail', 'İşeri', 100000, CAST('20140220' AS DATETIME) , 1),
('Hami', 'Satılmış', 80000, CAST('20140611' AS DATETIME), 1),
('Durmuş', 'Şahin', 300000, CAST('20140220' AS DATETIME), 2),
('Kağan', 'Yazar', 500000, CAST('20140220' AS DATETIME), 3),
('Meryem', 'Soysaldı', 500000, CAST('20140611' AS DATETIME), 3),
('Duygu', 'AKşehir', 200000, CAST('20140611' AS DATETIME), 2),
('Kübra', 'Seyhan', 75000, CAST('20140120' AS DATETIME), 1),
('Gülcan', 'Yıldız', 90000, CAST('20140411' AS DATETIME), 3);

SELECT * FROM calisanlar

INSERT INTO ikramiye(ikramiye_calisan_id,ikramiye_ucret, ikramiye_tarih) 
VALUES
(1, 5000, CAST('20160220' AS DATETIME)),
(2, 3000, CAST('20160611' AS DATETIME)),
(3, 4000, CAST('20160220' AS DATETIME)),
(1, 4500, CAST('20160220' AS DATETIME)),
(2, 3500, CAST('20160611' AS DATETIME));

SELECT * FROM ikramiye

INSERT INTO unvan(unvan_calisan_id, unvan_calisan, unvan_tarih)
VALUES
(1, 'Yönetici', CAST('20160220' AS DATETIME)),
(2, 'Personel', CAST('20160611' AS DATETIME)),
(8, 'Personel', CAST('20160611' AS DATETIME)),
(5, 'Müdür', CAST('20160611' AS DATETIME)),
(4, 'Yönetici Yardımcısı', CAST('20160611' AS DATETIME)),
(7, 'Personel', CAST('20160611' AS DATETIME)),
(6, 'Takım Lideri', CAST('20160611' AS DATETIME)),
(3, 'Takım Lideri', CAST('20160611' AS DATETIME));

SELECT * FROM unvan

SELECT ad, soyad, unvan_calisan FROM calisanlar join unvan ON calısan_birim_id = unvan_calisan_id


/* soru 3 */

SELECT ad, soyad, maas
FROM calisanlar
INNER JOIN birimler ON calisanlar.calısan_birim_id = birimler.birim_id
WHERE birimler.birim_ad IN ('Yazılım', 'Donanım');

/* soru 4*/

SELECT ad, soyad, maas FROM calisanlar WHERE maas = (SELECT max(maas) FROM calisanlar);


/* soru 5*/

SELECT birimler.birim_ad , COUNT(calisanlar.calisan_id) as calisan_sayisi
FROM calisanlar
INNER JOIN birimler ON calisanlar.calısan_birim_id = birimler.birim_id
GROUP BY birim_ad

/* soru 6 */


SELECT unvan.unvan_calisan, COUNT(calisanlar.calisan_id) as calisan_sayisi
FROM calisanlar INNER JOIN unvan ON calisanlar.calisan_id = unvan.unvan_calisan_id
GROUP BY unvan_calisan HAVING COUNT(calisanlar.calisan_id) > 1

/* soru 7 */

SELECT ad, soyad, maas 
FROM calisanlar
WHERE maas BETWEEN 50000 and 100000

/* soru 8 */

SELECT ad, soyad, maas, birim_ad, unvan_calisan, ikramiye_ucret
FROM calisanlar
INNER JOIN birimler ON calisanlar.calısan_birim_id = birimler.birim_id 
INNER JOIN ikramiye ON calisanlar.calisan_id = ikramiye.ikramiye_calisan_id 
INNER JOIN unvan ON calisanlar.calisan_id = unvan.unvan_calisan_id

/* soru 9 */

SELECT ad, soyad, unvan_calisan 
FROM calisanlar
INNER JOIN unvan ON calisanlar.calisan_id = unvan.unvan_calisan_id
WHERE unvan_calisan IN ('Yönetici', 'Müdür') 

/* soru 10 */

SELECT ad, soyad, maas, birim_ad
FROM calisanlar as c
INNER JOIN birimler ON birimler.birim_id = c.calısan_birim_id
WHERE c.maas IN(
SELECT MAX(maas)
FROM calisanlar as tmp
GROUP BY tmp.calısan_birim_id
)