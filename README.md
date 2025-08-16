# 📊 SQL ile FLO Müşteri Segmentasyonu

## 🚀 Projeye Genel Bakış

**Komut Dosyası:** 
[`FLO Customer Segmentation`](script/FLO_Customer_Segmentation.sql)


**Açıklama:** Bu proje kapsamında, Flo’nun omni-channel (hem online hem offline) alışveriş yapan müşterilerinin 2020–2021 yıllarına ait davranışları SQL teknikleri kullanılarak analiz edilmiştir. Müşteri segmentasyonu, alışveriş sıklığı, kanal bazlı performans ve kategori tercihleri detaylı olarak incelenmiştir. Elde edilen çıktılar, müşteri deneyimini kişiselleştirmeye, pazarlama stratejilerini optimize etmeye ve satış kanallarını daha verimli kullanmaya yönelik stratejik içgörüler sunmaktadır.

---

## 📂 Veri Seti Bilgisi

Projede aşağıdaki veri seti kullanıldı:  

- [**flo_data_20K.csv**](dataset/flo_data_20K.csv): Müşterilerin alışveriş kanalları, sipariş adetleri, toplam ciroları, kategori tercihleri ve mağaza türleri gibi bilgileri barındırmaktadır.
- 19.945 gözlem ve 13 değişken içermektedir.
- Boyutu: 2.7 MB  

---

## 📋 İçerik

1. Veri Yükleme & Tablo Oluşturma
2. Temel İstatistikler & Özet Bilgiler
3. Kanal & Mağaza Bazlı Analizler
4. Zaman Bazlı Analizler
5. Kategori & Segment Analizleri
6. Müşteri Bazlı Performans Analizi


<p></p>
<img width="1200" height="800" alt="image" src="https://github.com/user-attachments/assets/91f5f6d3-babe-4f2b-ba64-fa76cf934f21" />
<p></p>


---

## 🛠 Teknolojiler

- [**SQL Server**](https://www.microsoft.com/en-us/sql-server/sql-server-downloads): Veritabanı yönetimi için hızlı ve güçlü bir RDBMS.  
- [**SQL Server Management Studio (SSMS)**](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms): Veritabanlarını yönetmek için GUI (Grafiksel Kullanıcı Arayüzü). tabanlı araç.  
- [**GitHub**](https://github.com): Kodun sürüm takibi ve işbirliği için kullanılan platform.

---

## 💡 Kullanılan SQL Teknikleri

Projede aşağıdaki SQL teknikleri aktif olarak kullanılmıştır:

- **Pencere Fonksiyonları**: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` ile müşteri sıralamaları, alışveriş sıklığı ve ciro analizleri
- Örnek Çıktı: En çok alışveriş yapan 100 müşterinin sipariş başına ortalama cirosu hesaplandı.  
- **Çapraz Uygulama**: `CROSS APPLY` ile mağaza türleri ve kategori kırılımlarının detaylı incelenmesi
- Örnek Çıktı: Birden fazla mağaza türünde alışveriş yapan müşterilerin toplam katkısı ölçüldü.
- **Ortak Tablo İfadeleri (CTE)**: Karmaşık sorguların okunabilirliği ve tekrar kullanılabilir alt sorguların oluşturulması
- Örnek Çıktı: En yüksek ciroya sahip müşterilerin alışveriş sıklıkları analiz edildi.
- **Zaman Fonksiyonları**: `DATEPART()`, `DATEDIFF()` ile alışveriş yılına göre sipariş trendleri ve müşteri kazanımlarının analizi
- Örnek Çıktı: Yıllara göre müşteri kazanımları ve sipariş yoğunlukları belirlendi.
- **Koşullu Toplama ve Filtreleme**: `HAVING`, conditional aggregation ile segment bazlı alışveriş ve ciro bilgilerinin ayrıştırılması
- Örnek Çıktı: Son 12 ayda en çok ilgi gören kategoriler hesaplandı. 
- **JOIN & Alt Sorgular**: Kategori ve kanal kırılımlarında en değerli müşterilerin tespit edilmesi
- Örnek Çıktı: Her kanal özelinde en çok alışveriş yapan müşteri belirlendi.

---

## 🎯 Ana Çıktılar

- Kanallara göre toplam ciro ve sipariş başına ortalama ciro hesaplandı.
- Son 12 ayda en çok ilgi gören kategoriler tespit edildi.
- Müşteri segmentleri alışveriş sıklığı, harcama gücü ve kanal tercihleri üzerinden oluşturuldu.
- Yıllara göre müşteri kazanımı ve alışveriş trendleri analiz edildi.
- En değerli müşteri grupları belirlendi ve sadakat ölçümleri yapıldı.


## 📌 Projenin Faydaları

- **İş Zekâsı**: Müşteri segmentasyonu ile en değerli müşteri grupları ve alışveriş trendleri belirlenerek satış stratejileri güçlendirildi.
- **Pazarlama Stratejisi**: Kategori ve kanal bazlı müşteri davranışları, kişiselleştirilmiş kampanyaların tasarlanmasına imkân sağladı.
- **Kanal Optimizasyonu**: Online ve offline satış kanallarının verimliliği analiz edilerek, hangi kanalların daha fazla katkı sağladığı tespit edildi.
- **Müşteri Deneyimi İyileştirme**: Alışveriş sıklığı ve kategori tercihlerine göre yapılan segmentasyon, müşteri deneyimini kişiselleştirerek memnuniyeti artırmaya yardımcı oldu.

Veri analizi tekniklerinin doğru kullanımıyla müşterilerin alışveriş alışkanlıkları hakkında anlamlı çıkarımlar yapılmasını sağlayarak, stratejik kararlar için önemli bir veri kaynağı sunmaktadır.

---

## 📜 SQL Sorguları

## 1. Veri Yükleme & Tablo Oluşturma

	- CUSTOMERS veritabanı oluşturma  
	- FLO tablosunun manuel kolon tanımlama yöntemi  
	- FLO.csv dosyasının import edilmesi*

**Customers isimli bir veritabanı ve verilen veri setindeki değişkenleri içerecek FLO isimli bir tablo oluşturunuz.**
```sql
CREATE DATABASE CUSTOMERS
```

- 1. YÖNTEM: FLO adlı tablonun kolonları kod ile oluşturulabilir:
```sql
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
```

- 2. YÖNTEM:
     
*/
Daha basit bir yöntem olan FLO veri setinin CSV dosyasını içeri aktarma işlemi yapılır:
	CUSTOMERS Database "sağ click"
	-> Tasks -> İmoprt Flat File -> Specify Input File -> Browse -> "FLO.csv dosyasını seç" Open -> Next -> Next -> Next -> Finish -> Close
*/



## 2. Temel İstatistikler & Özet Bilgiler

**Kaç farklı müşterinin alışveriş yaptığını gösterecek sorguyu yazınız.**
```sql
SELECT COUNT(DISTINCT [master_id]) AS DISTINCT_KISI_SAYISI 
FROM FLO;
```

**Toplam yapılan alışveriş sayısı ve ciroyu getirecek sorguyu yazınız.**
```sql
SELECT 
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) AS TOPLAM_CIRO
FROM FLO;
```

**Alışveriş başına ortalama ciroyu getirecek sorguyu yazınız.**
```sql
--SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) ToplamCiro
--SUM(order_num_total_ever_online+order_num_total_ever_offline) ToplamSiparisMiktari
ROUND(
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) /
SUM(order_num_total_ever_online+order_num_total_ever_offline)
,2) AS SIPARIS_ORT_CIRO 
FROM FLO;
```


## 3. Kanal & Mağaza Bazlı Analizler

**En son alışveriş yapılan kanal (last_order_channel) üzerinden yapılan alışverişlerin toplam ciro ve alışveriş sayılarını getirecek sorguyu yazınız.** 
```sql
SELECT
[last_order_channel] AS SON_ALISVERIS_KANALI ,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) AS TOPLAM_CIRO,
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI
FROM FLO
GROUP BY [last_order_channel] 
ORDER BY TOPLAM_CIRO DESC; --Bonus: En yüksek toplam ciroya göre sıralandı.
```

**En son alışveriş yapılan kanal kırılımında alışveriş başına ortalama ciroyu hesaplayacak sorguyu yazınız.**
```sql
SELECT
[last_order_channel] SIPARIS_KANALI,
ROUND( SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) /
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]),2) AS SIPARIS_ORT_CIRO 
FROM FLO
GROUP BY [last_order_channel];
```

**Store type kırılımında elde edilen toplam ciroyu getiren sorguyu yazınız.**
```sql
SELECT 
[store_type] AS MAGAZA_TURU,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) AS TOPLAM_CIRO
FROM FLO
GROUP BY [store_type];
```

**BONUS - > Store type icerisindeki verilerin parse edilmis hali.**
```sql
SELECT value,SUM(TOPLAM_CIRO/COUNT_)
FROM
(                                                   
SELECT  [store_type] MAGAZATURU,                                                                                                                                        
        (SELECT COUNT(VALUE) FROM  string_split([store_type],',') ) COUNT_,
		-->COUNT(VALUE): liste içindeki değer sayısını hesaplıyor (ör. "A,B,C" için 3 olur).
 		-->string_split(store_type, ','): store_type sütunundaki virgülle ayrılmış değerleri parçalayıp  bir liste haline getiriyor.      
        ROUND(SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]), 2) TOPLAM_CIRO 
FROM FLO 
GROUP BY [store_type]) T
CROSS APPLY 
(
 SELECT  VALUE  FROM  string_split(T.MAGAZATURU,',')
-->string_split(T.MAGAZATURU, ','): Yukarıdaki sorgudan gelen MAGAZATURU değerini alır ve virgülle ayrılmış olarak parçalayarak her bir türü (VALUE) bağımsız bir satır haline getirir.
) D
GROUP BY Value  -->CROSS APPLY ile elde edilen VALUE değerlerine göre veriyi gruplandırıyor. Yani her alt tür için sonuçlar elde ediliyor.
```

## 4. Zaman Bazlı Analizler

**Yıl kırılımında alışveriş sayılarını getirecek sorguyu yazınız (Yıl olarak müşterinin ilk alışveriş tarihi (first_order_date) yılını baz alınız).**
```sql
SELECT
DATEPART(YEAR,[first_order_date]) YIL,
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) AS TOPLAM_SIPARIS_SAYISI
FROM FLO
GROUP BY DATEPART(YEAR,[first_order_date])
ORDER BY 1; --Bonus: Yıl sütununa göre sıralandı.
```

**Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazınız.**
```sql
SELECT
[interested_in_categories_12],
COUNT([interested_in_categories_12]) FREKANS_BILGISI 
FROM FLO
GROUP BY [interested_in_categories_12]
ORDER BY 2 DESC;
```

**En son alışveriş yapan kişinin ID’ sini getiren sorguyu yazınız. (Max son tarihte birden fazla alışveriş yapan ID bulunmakta. Bunları da getiriniz.)**
```sql
SELECT [master_id],[last_order_date]
FROM FLO
WHERE [last_order_date]=(
    SELECT MAX([last_order_date])
	FROM FLO
);
```

**BONUS - > GROUP BY yöntemi ile yapılmış cözüm**
```sql
SELECT master_id, last_order_date
FROM FLO
GROUP BY master_id, last_order_date
HAVING last_order_date = (
    SELECT MAX(last_order_date)
    FROM FLO
);
```

**BONUS - > Window Function (RANK) yöntemi ile yapılmış cözüm**
```sql
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
```

## 5. Kategori & Segment Analizleri

**En çok tercih edilen store_type bilgisini getiren sorguyu yazınız.**
```sql
SELECT TOP 1
[store_type] MAGAZA_TURU,
COUNT([store_type]) FREKANS_BILGISI
FROM FLO
GROUP BY [store_type]
ORDER BY 2 DESC;
```

**BONUS - > Window Function (ROWNUMBER) yöntemi ile yapılmış cözüm**
```sql
SELECT *
FROM
(
   SELECT [store_type],COUNT([store_type]) FREKANS_BILGISI,
       ROW_NUMBER() OVER (ORDER BY COUNT([store_type]) DESC) AS ROW_NUM
   FROM FLO
   GROUP BY [store_type] 
)D
WHERE ROW_NUM=1;
```

**En son alışveriş yapılan kanal (last_order_channel) bazında, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlık alışveriş yapıldığını getiren sorguyu yazınız.**
```sql
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
```

**BONUS - > CROSS APPLY yontemi ile yapilmis cozum**
```sql
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
```

## 6. Müşteri Bazlı Performans Analizi

**En sık alışveriş yapan (sipariş sayısı bazında) kişinin ID’ sini getiren sorguyu yazınız.**
```sql
SELECT TOP 1 [master_id]
FROM FLO
GROUP BY [master_id]
ORDER BY  SUM([order_num_total_ever_online] + [order_num_total_ever_offline]) DESC;
```

**BONUS - > Window Function (ROWNUMBER) yöntemi ile yapılmış cözüm**
```sql
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
```

**En çok (ciro bazında) alışveriş yapan kişinin ID’ sini getiren sorguyu yazınız.**
```sql
SELECT TOP 1 [master_id]
FROM FLO
GROUP BY [master_id]
ORDER BY  SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) DESC;
```

**En çok alışveriş yapan 100 kişinin alışveriş başına ortalama cirosunu yazınız.**
```sql
SELECT TOP 100 [master_id],
SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) TOPLAM_CIRO,
ROUND(SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online])/ 
SUM([order_num_total_ever_online] + [order_num_total_ever_offline]),2) AS  SIPARIS_BASINA_ORT_CIRO
FROM FLO 
GROUP BY [master_id]
ORDER BY TOPLAM_CIRO DESC;
```

**BONUS - > SUBQUERY yöntemiyle yapılmış çözüm**
```sql
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
```

**BONUS - > SUBQUERY VE JOIN yöntemiyle yapılmış çözüm**
```sql
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
```

**En çok alışveriş yapan kişinin alışveriş başına ortalama cirosunu ve alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorguyu yazınız.**
```sql
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
```

**BONUS - > WITH - Common Table Expression (CTE) yöntemi ile yapılmış çözüm**
```sql
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
```
	
**En son alışveriş yapılan kanal (last_order_channel) kırılımında en çok alışveriş yapan müşteriyi getiren sorguyu yazınız.**
```sql
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
```

**BONUS - > CROSS APPLY yöntemi ile yapılmış cözüm**
```sql
SELECT DISTINCT [last_order_channel] AS EN_SON_SIPARIS_KANALI, D.EN_COK_ALISVERIS_YAPAN_MUSTERI, D.CIRO
FROM FLO F
CROSS APPLY 
(
    SELECT TOP 1 [master_id] EN_COK_ALISVERIS_YAPAN_MUSTERI,
		          SUM([customer_value_total_ever_offline] + [customer_value_total_ever_online]) CIRO
	FROM FLO 
	WHERE [last_order_channel]=F.[last_order_channel]
	--Tabloda her satırda ki en son alışveriş yapılan kanal hücresi karşısına ilgili kayıttaki kanalın en çok alışveriş yapan müşterisini ve cirosunu getirir.
	--WHERE satırı yazılmasaydı her kanalın karşısına tüm kayıtların en çok alışveriş yapan müşterisini ve cirosu gelirdi. Yani her kanalın karışısında aynı değer görünürdü.
	GROUP BY [master_id]

    ORDER BY CIRO DESC
) D;
```





















