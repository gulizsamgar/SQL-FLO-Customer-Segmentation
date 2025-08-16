
/*  

# Flo Müşteri Segmentasyonu

# Proje Teknikleri:
-> Veri Yükleme ve Tablo Oluşturma
   - Manuel kolon tanımlama ve CSV dosyası yükleme
-> Veri Gruplama ve Filtreleme
   - Distinct müşteri sayısı hesaplama
   - Alışveriş toplamı ve ciro analizi
-> İleri SQL Fonksiyonları Kullanımı
   - Window Functions (ROW_NUMBER, RANK) ile müşteri sıralaması
   - CROSS APPLY ile mağaza türü kırılımları
-> Zaman Bazlı Analizler
   - Alışveriş yılına göre gruplama
-> Conditional Aggregation
   - `HAVING` ile hedefli filtreleme
-> Common Table Expressions (CTE)
   - Karmaşık sorguların yönetimi
-> Kanal Bazlı Performans Analizi
   - Alışveriş başına ortalama ciro hesaplama

*/

# Flo Müşteri Segmentasyonu  

 
## 🧩 7. İleri SQL Teknikleri
- Window Functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`) ile sıralamalar  
- Subquery & JOIN ile müşteri analizi  
- Common Table Expressions (CTE) ile karmaşık sorguların yönetimi  
- CROSS APPLY ile kanal & kategori kırılımı  

 

/*
===============================================================================
1. Veri Yükleme & Tablo Oluşturma
	- CUSTOMERS veritabanı oluşturma  
	- FLO tablosunun manuel kolon tanımlama yöntemi  
	- FLO.csv dosyasının import edilmesi*
===============================================================================
*/
	
--1. Customers isimli bir veritabanı ve verilen veri setindeki değişkenleri içerecek FLO isimli bir tablo oluşturunuz.
CREATE DATABASE CUSTOMERS

/*1. YÖNTEM: FLO adlı tablonun kolonları kod ile oluşturulabilir:
CREATE TABLE FLO (
	master_id				VARCHAR(50),
	order_channel				VARCHAR(50),
	last_order_channel			VARCHAR(50),
	first_order_date			DATE,
	last_order_date				DATE,
	last_order_date_online			DATE,
	last_order_date_offline			DATE,
	order_num_total_ever_online		INT,
	order_num_total_ever_offline		INT,
	customer_value_total_ever_offline	FLOAT,
	customer_value_total_ever_online	FLOAT,
	interested_in_categories_12		VARCHAR(50),
	store_type				VARCHAR(10)
)
*/

/* 2. Yöntem: Daha basit bir yöntem olan FLO veri setinin CSV dosyasını içeri aktarma işlemi yapılır:
CUSTOMERS Database "sağ click"
	-> Tasks -> İmoprt Flat File -> Specify Input File -> Browse -> "FLO.csv dosyasını seç" Open -> Next -> Next -> Next -> Finish -> Close
*/


/*
===============================================================================
2. Temel İstatistikler & Özet Bilgiler
	- Farklı müşteri sayısı (`COUNT DISTINCT`)  
	- Toplam alışveriş sayısı & toplam ciro  
	- Alışveriş başına ortalama ciro  
===============================================================================
*/

--2. Kaç farklı müşterinin alışveriş yaptığını gösterecek sorguyu yazınız.
SELECT COUNT(DISTINCT [master_id]) AS DISTINCT_KISI_SAYISI 
FROM FLO;


--3. Toplam yapılan alışveriş sayısı ve ciroyu getirecek sorguyu yazınız.
SELECT 
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) AS TOPLAM_CIRO
FROM FLO;


--4. Alışveriş başına ortalama ciroyu getirecek sorguyu yazınız.
SELECT 
--SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) ToplamCiro
--SUM(order_num_total_ever_online+order_num_total_ever_offline) ToplamSiparisMiktari
ROUND(
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) /
SUM(order_num_total_ever_online+order_num_total_ever_offline)
,2) AS SIPARIS_ORT_CIRO 
FROM FLO;


/*
===============================================================================
3. Kanal & Mağaza Bazlı Analizler
	- Son alışveriş kanalı bazında toplam ciro ve sipariş sayısı  
	- Store type kırılımında toplam ciro  
	- CROSS APPLY ile store_type detay analizi* 
	- Kanal bazında alışveriş başına ortalama ciro 
===============================================================================
*/
 	
--5. En son alışveriş yapılan kanal (last_order_channel) üzerinden yapılan alışverişlerin toplam ciro ve alışveriş sayılarını getirecek sorguyu yazınız.  
SELECT
[last_order_channel] AS SON_ALISVERIS_KANALI ,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) AS TOPLAM_CIRO,
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI
FROM FLO
GROUP BY [last_order_channel] 
ORDER BY TOPLAM_CIRO DESC; --Bonus: En yüksek toplam ciroya göre sıralandı.

--6. Store type kırılımında elde edilen toplam ciroyu getiren sorguyu yazınız.
SELECT 
[store_type] AS MAGAZA_TURU,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) AS TOPLAM_CIRO
FROM FLO
GROUP BY [store_type];

--BONUS - > Store type icerisindeki verilerin parse edilmis hali.
SELECT value,SUM(TOPLAM_CIRO/COUNT_)
FROM
(                                                   
SELECT  [store_type] MAGAZATURU,                                             -->string_split(store_type, ','): store_type sütunundaki virgülle ayrılmış değerleri parçalayıp bir liste haline getiriyor.
        (SELECT COUNT(VALUE) FROM  string_split([store_type],',') ) COUNT_,  -->COUNT(VALUE): liste içindeki değer sayısını hesaplıyor (ör. "A,B,C" için 3 olur).
        ROUND(SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]), 2) TOPLAM_CIRO 
FROM FLO 
GROUP BY [store_type]) T
CROSS APPLY 
(
 SELECT  VALUE  FROM  string_split(T.MAGAZATURU,',') -->string_split(T.MAGAZATURU, ','): Yukarıdaki sorgudan gelen MAGAZATURU değerini alır ve virgülle ayrılmış olarak parçalayarak her bir türü (VALUE) bağımsız bir satır haline getirir.
) D
GROUP BY Value  -->CROSS APPLY ile elde edilen VALUE değerlerine göre veriyi gruplandırıyor. Yani her alt tür için sonuçlar elde ediliyor.


/*
===============================================================================
4. Zaman Bazlı Analizler
	- Alışveriş yılına göre sipariş trendi  
	- Son 12 ayda en çok ilgi gören kategori  
	- En son alışveriş yapan müşteri
===============================================================================
*/
	
--7. Yıl kırılımında alışveriş sayılarını getirecek sorguyu yazınız (Yıl olarak müşterinin ilk alışveriş tarihi (first_order_date) yılını baz alınız).
SELECT
DATEPART(YEAR,[first_order_date]) YIL,
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI
FROM FLO
GROUP BY DATEPART(YEAR,[first_order_date])
ORDER BY 1; --Bonus: Yıl sütununa göre sıralandı.


--9. Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazınız.
SELECT
[interested_in_categories_12],
COUNT([interested_in_categories_12]) FREKANS_BILGISI 
FROM FLO
GROUP BY [interested_in_categories_12]
ORDER BY 2 DESC;






--8. En son alışveriş yapılan kanal kırılımında alışveriş başına ortalama ciroyu hesaplayacak sorguyu yazınız.
SELECT
[last_order_channel] SIPARIS_KANALI,
ROUND( SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) /
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]),2) AS SIPARIS_ORT_CIRO 
FROM FLO
GROUP BY [last_order_channel];





/*
===============================================================================
4. Zaman Bazlı Analizler
	- İlk alışveriş yılına göre sipariş trendi  
	- Son 12 ayda en çok ilgi gören kategori  
===============================================================================
*/

## 🏷️ 5. Kategori & Segment Analizleri
- En çok tercih edilen store_type  
- Kanal bazında en çok ilgi gören kategori ve sipariş sayısı  

--10. En çok tercih edilen store_type bilgisini getiren sorguyu yazınız.
SELECT TOP 1
[store_type] MAGAZA_TURU,
COUNT([store_type]) FREKANS_BILGISI
FROM FLO
GROUP BY [store_type]
ORDER BY 2 DESC;


--BONUS - > Window Function (ROWNUMBER) yöntemi ile yapılmış cözüm
SELECT *
FROM
(
   SELECT [store_type],COUNT([store_type]) FREKANS_BILGISI,
       ROW_NUMBER() OVER (ORDER BY COUNT([store_type]) DESC) AS ROW_NUM
   FROM FLO
   GROUP BY [store_type] 
)D
WHERE ROW_NUM=1;


--11. En son alışveriş yapılan kanal (last_order_channel) bazında, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlık alışveriş yapıldığını getiren sorguyu yazınız.
SELECT
DISTINCT [last_order_channel] AS SIPARIS_KANALI,
( 
    SELECT TOP 1 [interested_in_categories_12]
    FROM FLO 
    WHERE [last_order_channel]=F.[last_order_channel] 
    GROUP BY [interested_in_categories_12] 
    ORDER BY SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) DESC
),
(
    SELECT TOP 1 SUM(order_num_total_ever_online+order_num_total_ever_offline) 
    FROM FLO 
    WHERE [last_order_channel]=F.[last_order_channel]
    GROUP BY [interested_in_categories_12]
    ORDER BY SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) DESC
)
FROM FLO F;


--BONUS - > CROSS APPLY yontemi ile yapilmis cozum
SELECT DISTINCT [last_order_channel] SIPARIS_KANALI ,D.EN_YUKSEK_ILGI_KATEGORISI,D.ILGI_KETEGORISI_TOPLAM_SIPARIS
FROM FLO F
CROSS APPLY 
(
	SELECT TOP 1 [interested_in_categories_12] EN_YUKSEK_ILGI_KATEGORISI ,SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) ILGI_KETEGORISI_TOPLAM_SIPARIS
	FROM FLO   
	WHERE [last_order_channel]=F.[last_order_channel]
	GROUP BY [interested_in_categories_12]
	ORDER BY
	SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) DESC
) D
ORDER BY D.ILGI_KETEGORISI_TOPLAM_SIPARIS DESC;


/*
===============================================================================
6. Müşteri Bazlı Performans Analizi
	- En sık alışveriş yapan müşteri (sipariş sayısına göre)  
	- En çok ciro yapan müşteri  
	- En çok alışveriş yapan 100 müşterinin alışveriş başına ortalama cirosu  
	- En çok alışveriş yapan müşterinin alışveriş sıklığı ve sipariş başına ortalama cirosu
	- Kanal bazında en çok alışveriş yapan müşteri  
===============================================================================
*/

--12. En sık alışveriş yapan (sipariş sayısı bazında) kişinin ID’ sini getiren sorguyu yazınız.
SELECT TOP 1 [master_id]
FROM FLO
GROUP BY [master_id]
ORDER BY  SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) DESC;


--BONUS - > Window Function (ROWNUMBER) yöntemi ile yapılmış cözüm
SELECT T.[master_id]
FROM
(
     SELECT [master_id], 
	        SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI,
	        ROW_NUMBER() OVER (ORDER BY SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) DESC) AS ROW_NUM
     FROM FLO
	 GROUP BY [master_id]
) T
WHERE ROW_NUM=1;


--13. En çok (ciro bazında) alışveriş yapan kişinin ID’ sini getiren sorguyu yazınız.
SELECT TOP 1 [master_id]
FROM FLO
GROUP BY [master_id]
ORDER BY  SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) DESC;


--14 En çok alışveriş yapan 100 kişinin alışveriş başına ortalama cirosunu yazınız.
SELECT TOP 100 [master_id],
SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) TOPLAM_CIRO,
ROUND(SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online])/ 
SUM([order_num_total_ever_online] + [order_num_total_ever_offline]),2) AS  SIPARIS_BASINA_ORT_CIRO
FROM FLO 
GROUP BY [master_id]
ORDER BY TOPLAM_CIRO DESC;


--BONUS - > SUBQUERY yöntemiyle yapılmış çözüm
SELECT  D.[master_id],
        D.TOPLAM_CIRO,
        ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORT_CIRO
FROM
(
SELECT TOP 100 [master_id],
		  SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) TOPLAM_CIRO,
		  SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) TOPLAM_SIPARIS_SAYISI
	FROM FLO 
	GROUP BY [master_id]
ORDER BY TOPLAM_CIRO DESC
) D
ORDER BY TOPLAM_CIRO DESC;


--BONUS - > SUBQUERY VE JOIN yöntemiyle yapılmış çözüm 
SELECT 
     F.[master_id],
	 A.TOPLAM_CIRO,
     ROUND(
           SUM(F.[customer_value_total_ever_offline] + F.[customer_value_total_ever_online]) /
           SUM(F.[order_num_total_ever_online] + F.[order_num_total_ever_offline])
		   ,2) AS SIPARIS_BASINA_ORT_CIRO
FROM FLO F
JOIN (
    SELECT TOP 100
        [master_id],
        SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) AS TOPLAM_CIRO
    FROM FLO
    GROUP BY [master_id]
    ORDER BY TOPLAM_CIRO DESC
) AS A
ON F.[master_id] = A.[master_id]
GROUP BY F.[master_id],A.TOPLAM_CIRO 
ORDER BY A.TOPLAM_CIRO DESC;


--15. En çok alışveriş yapan kişinin alışveriş başına ortalama cirosunu ve alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorguyu yazınız.
SELECT D.[master_id],
       D.TOPLAM_CIRO,
	   D.TOPLAM_SIPARIS_SAYISI,
       ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORTALAMA,
	   DATEDIFF(DAY, first_order_date, last_order_date) ILK_SN_ALVRS_GUN_FRK,
	   ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/D.TOPLAM_SIPARIS_SAYISI ),1) ALISVERIS_GUN_ORT
FROM
(
SELECT TOP 1 [master_id],[first_order_date] , [last_order_date],
		   SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) TOPLAM_CIRO,
		   SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) TOPLAM_SIPARIS_SAYISI
	FROM FLO 
	GROUP BY  [master_id],[first_order_date] , [last_order_date]
    ORDER BY TOPLAM_CIRO DESC
) D;


--BONUS - > WITH - Common Table Expression (CTE) yöntemi ile yapılmış çözüm 
WITH TOPCUSTOMER AS (
    SELECT TOP 1 [master_id],[first_order_date] , [last_order_date],
            SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) AS TOPLAM_CIRO,
		    SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI
    FROM FLO
    GROUP BY  [master_id],[first_order_date] , [last_order_date]
    ORDER BY TOPLAM_CIRO DESC
)
SELECT 
    TC.[master_id],
	TC.TOPLAM_CIRO,
	TC.TOPLAM_SIPARIS_SAYISI,
    ROUND((TC.TOPLAM_CIRO / TC.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORTALAMA,
	DATEDIFF(DAY, first_order_date, last_order_date) ILK_SN_ALVRS_GUN_FRK,
    ROUND(TC.TOPLAM_CIRO / TC.TOPLAM_SIPARIS_SAYISI, 2) AS SIPARIS_BASINA_ORT_CIRO,
    ROUND(
        DATEDIFF(DAY, TC.[first_order_date], TC.[last_order_date]) / TC.TOPLAM_SIPARIS_SAYISI, 1) AS ALISVERIS_GUN_ORT
FROM TOPCUSTOMER AS TC ;

	
--16. En son alışveriş yapılan kanal (last_order_channel) kırılımında en çok alışveriş yapan müşteriyi getiren sorguyu yazınız.
SELECT DISTINCT [last_order_channel] AS EN_SON_SIPARIS_KANALI,
(
	SELECT TOP 1 [master_id]
	FROM FLO  
	WHERE [last_order_channel]=F.[last_order_channel] 
	GROUP BY [master_id]
	ORDER BY 
	SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) desc 
) EN_COK_ALISVERIS_YAPAN_MUSTERI,
(
	SELECT top 1 SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online])
	FROM FLO  
	WHERE [last_order_channel]=F.[last_order_channel]
	GROUP BY [master_id]
	ORDER BY 
	SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) desc 
) CIRO
FROM FLO F;


--BONUS - > CROSS APPLY yöntemi ile yapılmış cözüm
SELECT DISTINCT [last_order_channel] AS EN_SON_SIPARIS_KANALI, D.EN_COK_ALISVERIS_YAPAN_MUSTERI, D.CIRO
FROM FLO F
CROSS APPLY 
(
    SELECT TOP 1 [master_id] EN_COK_ALISVERIS_YAPAN_MUSTERI,
		          SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) CIRO
	FROM FLO 
	WHERE [last_order_channel]=F.[last_order_channel] --Tabloda her satırda ki en son alışveriş yapılan kanal hücresi karşısına ilgili kayıttaki kanalın en çok alışveriş yapan müşterisini ve cirosunu getirir.
	GROUP BY [master_id]                              --WHERE satırı yazılmasaydı her kanalın karşısına tüm kayıtların en çok alışveriş yapan müşterisini ve cirosu gelirdi. Yani her kanalın karışısında aynı değer görünürdü.
    ORDER BY CIRO DESC
) D;


--17. En son alışveriş yapan kişinin ID’ sini getiren sorguyu yazınız. (Max son tarihte birden fazla alışveriş yapan ID bulunmakta. Bunları da getiriniz.) 
SELECT [master_id],[last_order_date]
FROM FLO
WHERE [last_order_date]=(
    SELECT MAX([last_order_date])
	FROM FLO
);


--BONUS - > GROUP BY yöntemi ile yapılmış cözüm
SELECT master_id, last_order_date
FROM FLO
GROUP BY master_id, last_order_date
HAVING last_order_date = (
    SELECT MAX(last_order_date)
    FROM FLO
);


--BONUS - > Window Function (RANK) yöntemi ile yapılmış cözüm
WITH RankedOrders AS (
    SELECT 
        master_id, 
        last_order_date,
        RANK() OVER (ORDER BY last_order_date DESC) AS rank
    FROM FLO
)
SELECT master_id, last_order_date
FROM RankedOrders
WHERE rank = 1;



