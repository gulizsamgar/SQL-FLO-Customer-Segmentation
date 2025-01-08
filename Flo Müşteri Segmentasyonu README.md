Bu proje kapsamında, Flo'nun omni-channel (hem online hem offline) alışveriş yapan müşterilerinin 2020-2021 yıllarına ait alışveriş davranışları analiz edilmiştir.
Veri seti, 19.945 gözlem ve 13 değişken içermekte olup, 2.7 MB büyüklüğünde ve müşteri segmentasyonu ile davranış analizi için oldukça zengin bir içeriğe sahiptir.

Proje Teknikleri:

Veri yükleme ve tablo oluşturma: Manuel kolon tanımlama ve CSV dosyasını veri tabanına yükleme yöntemleri kullanılmıştır.

🔹 Analiz Teknikleri:

1️⃣ Window Functions (ROW_NUMBER, RANK):
Müşteri sıralamaları ve alışveriş frekanslarını analiz ederek en değerli müşteriler belirlendi.
Örnek Sonuç: En çok alışveriş yapan müşterinin alışveriş başına ortalama ciro hesaplandı.

2️⃣ CROSS APPLY:
Mağaza türlerini parse ederek, detaylı kategori bazlı analizler gerçekleştirildi.
Örnek Sonuç: Birden fazla mağaza türünde alışveriş yapan müşterilerin katkısı hesaplandı.

3️⃣ Common Table Expressions (CTE):
Karmaşık sorguları daha okunabilir hale getirerek analiz süreçleri optimize edildi.
Örnek Sonuç: En çok ciro üreten müşterilerin alışveriş sıklığına dair bilgi elde edildi.

🔹 Ana Çıktılar:

Kanallara göre ciro ve alışveriş başına ortalama cirolar belirlendi.
Son 12 ayda en çok ilgi gören kategoriler tespit edildi.
Yıllık alışveriş trendleri analiz edilerek müşteri segmentleri oluşturuldu.

🔹Projenin Faydaları:

İş Zekası: Flo'nun müşteri segmentasyonu sayesinde, en değerli müşteriler ve alışveriş trendleri belirlenerek satış stratejileri daha etkili hale getirildi.

Pazarlama Stratejisi: Müşteri davranışlarına dair derinlemesine analizler, özelleştirilmiş pazarlama kampanyaları oluşturulmasına olanak tanıdı.

Kanal Optimizasyonu: Hem online hem offline satış kanallarının verimliliği analiz edilerek, hangi kanalların daha fazla katkı sağladığı tespit edildi.

Müşteri Deneyimi İyileştirme: Alışveriş sıklığı ve kategori tercihlerine göre yapılan segmentasyon, müşteri deneyimini kişiselleştirerek memnuniyeti artırmaya yardımcı oldu.

Bu proje, veri analizi tekniklerinin doğru kullanımıyla müşterilerin alışveriş alışkanlıkları hakkında anlamlı çıkarımlar yapılmasını sağlayarak, stratejik kararlar için önemli bir veri kaynağı sunmaktadır.
