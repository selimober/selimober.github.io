---
layout: blog
category: blog
title: Behaviour Driven Development - Giriş
disqus_identifier: intro-to-bdd
---

*Tarihçe: Bu makale ilk olarak 2006'nın Mart ayında [Better Software](http://j.mp/vHRQWp)'de yayımlandı. Ardından [Japonca](http://j.mp/vJOLGl)'ya [Yukei Wachi](http://j.mp/uIwtTO), [Korece](http://j.mp/tIqby Z)'ye [HongJoo Lee](http://j.mp/tr2Z5o), [İtalyanca](http://bit.ly/v2twov)'ya [Arialdo Martini](http://bit.ly/vkjZBB), [Fransızca](http://j.mp/wPipHF)'ya [Philippe Poumaroux](http://j.mp/zKyKgT) ve de en son [İspanyolca](http://j.mp/157tvAS)'ya [Oscar Zárate](https://twitter.com/OZcarZarate) tarafından çevrildi.*

Bir problemim vardı. Değişik koşullarda gerçekleşen çeşitli projelerde Test-driven development (TDD) gibi çevik yöntemler uygular ve öğretirken hep aynı karışıklık ve yanlış anlamalarla karşılaşıyordum. Programcılar nereden başlayacaklarını, neyi test edip, neyi etmeyeceklerini, bir seferde ne kadar test yazacaklarını, testlerini nasıl adlandıracaklarını ve bir testin başarısız olma nedenini nasıl anlayacaklarını bilmek istiyorlardı.

TDD'de derinleştikçe, kendi deneyimimin giderek artan bir ustalaşma yerine daha çok deneme yanılmalardan oluşan bir yolculuk olduğunu farkettim. Birçok kez "Evet, anlıyorum" yerine "Keşke biri bana bunu daha önce söyleseydi!" dediğimi hatırlıyorum. Sonuçta TDD'nin tuzaklarından kaçınarak, doğrudan iyi taraflarını öne çıkartacak bir şekilde sunmanın mümkün olduğuna karar verdim.

Cevabım Behaviour-driven development (BDD) oldu. Bu yöntem oturmuş çevik uygulamalarından gelişti ve çevik yazılım süreçlerine yeni olan takımlar için daha erişilebilir ve etkin olması amacıyla tasarlandı. Zamanla BDD, çevik analiz ve otomatik kabul testlerinden oluşan daha geniş bir kitleye hitap eder hale dönüştü.

## Test metodlarının isimleri cümle şeklinde olmalı

İlk "İşte bu!" anı, çalışma arkadaşım Chris Stevenson'ın yazdığı, yanıltıcı derecede basit [agiledox](http://agiledox.sourceforge.net/) uygulamasını bana gösterdiğinde oldu. Bu yardımcı program bir JUnit test sınıfını alıp metodlarını düz cümleler haline getirmekteydi. Yani şuna benzeyen bir test senaryosu:

{% highlight java %}
public class CustomerLookupTest extends TestCase {
    testFindsCustomerById() {
        ...
    }
    testFailsForDuplicateCustomers() {
        ...
    }
    ...
}
{% endhighlight %}

şöyle bir şekile dönüşmekte:

	CustomerLookup
	- finds customer by id
	- fails for duplicate customers
	- ...

"test" kelimesi hem sınıftan hem de metod isimlerinden çıkartılıp, camel-case isimlerin düz metine çevrilmesiyle oluşuyordu. Tüm yaptığı bu, fakat sonuçları şaşırtıcı.

Geliştiriciler, bu uygulamanın, en azından bir kısım dokumantasyonu kendileri için yapabileceğini keşfedince, testlerine gerçek cümlelerden oluşan metod isimleri vermeye başladılar. Daha da iyisi, metod isimlerini iş diliyle yazdıklarında, üretilen dokumanlar kullanıcılara, analistlere ve testçilere de anlam ifade etmeye başladı.

## Basit bir cümle şablonu, test metodlarının spesifik olmasını sağlar

Ardından test metod isimlerinin "should" ile başlaması konvansiyonunu geliştirdim. Bu cümle şablonu -"Bu nesne bir şey yapmalı"- sadece o sınıf için test tanımlayabileceğinizi belirtmektedir. Ve bu dağılmanızı engeller. Eğer bu şablona uymayan bir metod ismi yazdığınızı farkederseniz, bu aslında size, davranışın başka bir yere ait olduğunu söyler.

Örnek olarak, ekrandan gelen inputu doğrulayan bir sınıf yazıyordum. Çoğu alan basit kullanıcı detayları -isim, soyad, vs., içeriyordu. Fakat hem doğum tarihi hem de yaş için alanlar da vardı. `ClientDetailsValidatorTest` sınıfını `testShouldFailForMissingSurname` ve `testShouldFailForMissingTitle` gibi metodlarla yazmaya başladım.

Ardından yaşı hesaplama kısmına geldim ve karışık iş kuralları karşıma çıktı: Hem yaş hem de doğum tarihi girilmişse ama değerler birbirini tutmuyorsa ne olacak? Doğum tarihi bugünse? Sadece doğum tarihi varsa yaşı nasıl hesaplayacağım? Bu davranışları açıklayan gittikçe çapraşık test metod isimleri yazdım. Sonuçta bu davranışı başka bir yere aktarmaya karar verdim. Bu beni yeni bir `AgeCalculator` sınıfı yaratmaya yönlendirdi. Ve de ona ait `AgeCalculatorTest` sınıfını. Tüm yaş hesaplama davranışı Calculator sınıfına geçti, dolayısıyla Validator'ın Calculator ile doğru etkileşime geçtiğini görmek için tek bir test yetti.

Eğer bir sınıf birden çok iş yapıyorsa, bunu genellikle başka sınıflar yaratıp, bazı işlerini onlara devretmek için bir işaret olarak alırım. Yeni servisi *ne yaptığını* anlatan bir isimle interface olarak tanımlar ve bu servisi sınıfa constructor vasıtasıyla geçerim:

{% highlight java %}
public class ClientDetailsValidator {
 
    private final AgeCalculator ageCalc;
 
    public ClientDetailsValidator(AgeCalculator ageCalc) {
        this.ageCalc = ageCalc;
    }
}
{% endhighlight %}

Bu şekilde nesleri birbirine bağlama tarzı [dependency injection](http://www.martinfowler.com/articles/injection.html) olarak bilinir ve özellikle mock'larla çalışırken faydalıdır.

## Açıklayıcı bir test ismi o test başarısız olduğunda yardımcı olur

Bir süre sonra, eğer kodu değiştirdiğim zaman test başarısız oluyorsa, testin ismine bakıp, o kodun amaçlanan davranışını anlayabildiğimi farkettim. Genelde 3 durumdan biri gerçekleşmiştir:

- Bir bug yaratmışımdır. Çözüm: Bug'ı düzelt.
- Amaçlanan davranış hala geçerli fakat başka bir yere taşınmıştır. Çözüm: Testi taşı, veya değiştir.
- Davranış artık geçersizdir, sistemin gereksinimleri değişmiştir. Çözüm: *Testi sil.*

Son madde çevik projelerde bilginiz arttıkça sıklıkla karşınıza çıkar. Maalesef yeni TDD'ciler, kodlarının kalitesini düşüreceği korkusuyla testleri silmekten çekinirler.

*Should* (-meli/malı) kelimesinin püf noktası, daha resmi olan *will* veya *shall* (-ecek) ile karşılaştırıldığında  ortaya çıkmaktadır. *Should* dolaylı olarak size testin ilk nedenini sorgulamanıza izin verir: *"Olmalı mı? Gerçekten mi?"* Bu soru, eğer test başarısız olduysa, yerleştirdiğiniz bir bug'dan dolayı mı, yoksa sistem hakkındaki varsayımlarınızın artık geçerli olmadığı için mi olduğunu anlamanızı sağlar.

## "Behaviour" (davranış) "test"e göre daha kullanışlı bir kelimedir

Artık test kelimesini kaldırmak için bir aracım -agiledox- ve de test metod isimleri için bir şablonum vardı. Bu sayede insanların TDD hakkında yanılgılarının dönüp dolaşıp "test" kelimesine takıldığını anladım.

Tabii ki bu, test yapmanın TDD'nin özü olmadığı anlamına gelmiyor. Sonuçta çıkan metodlar sistemin doğru çalıştığını garanti etmek için etkin bir yoldur. Yine de, eğer bu metodlar sisteminizin davranışını açıklayıcı bir şekilde tanımlanmıyorsa, sizi sahte bir güvenlik duygusuyla teskin ediyorlardır.

TDD ile çalışırken "test" kelimesi yerine "behaviour"ı (davranış) kullanmaya başladım ve sadece daha iyi oturduğunu değil aynı zamanda koçluk sırasında ortaya çıkan birçok sorunu da sihirli bir şekilde çözdüğünü gördüm. Artık bazı sorulara cevabım vardı. Teste ne isim vermeli? Kolay, ilgilendiğin bir sonraki davranışı anlatan bir cümle olmalı. Nereye kadar test etmeli? Tek bir cümlede davranışı anlatabildiğiniz kadar. Test  neden başarısız oldu? yukarıdaki prosedürü izleyin: ya bir bug yerleştirdiniz, ya davranış taşındı, ya da test artık geçerli değildir.

Testlerle düşünmekten davranışlarla (behaviour) düşünmeye geçmenin etkileri o kadar derindi ki TDD'ye BDD, behaviour-driven development demeye başladım.

## JBehave test yerine davranışa önem veriyor

2003'ün sonuna doğru paramı, daha doğrusu zamanımı, konuştuğum doğrultuda yatırmaya karar verdim. JUnit yerine geçmesi için, teste yapılan göndermeleri kaldırıp yerine davranışları doğrulama üzerine kurulu bir jargonu olan JBehave'i yazmaya başladım. Bunu, katı bir şekilde davranış odaklı prensiplerime sadık kalırsam, bu framework'ün nasıl gelişeceğini görmek için yaptım. Aynı zamanda, test odaklı jargon olmadan, TDD'yi ve BDD'yi öğretmek için etkin bir yöntem olacağını da düşündüm.

Farz edelim bir `CustomerLookup` sınıfı için davranışı tanımlamak istiyorum. O zaman `CustomerLookupBehaviour` adı altında bir davranış sınıfı yazarım. Bu sınıf "should" ile başlayan metodlar barındırır. Behaviour runner, davranış sınıfından bir nesne üretir ve her metodunu, aynı JUnit'in yaptığı gibi sırayla çağırır. İlerledikçe sonuçları döker ve sonunda bir özet basar.

İlk hedefim JBehave'ı kendini denetler hale getirmekti. Sadece kendini çalıştırabilmesi için gerekli davranışları ekledim. Tüm JUnit testlerini JBehave'e taşımayı ve JUnit gibi anında geri bildirim almayı sağlamıştım.

## Bir sonraki en önemli davranışı belirle

Ardından "business value" konseptini keşfettim. Elbette, her zaman bir amaç için yazdığımın bilincindeydim. Fakat gerçekte o an yazdığım kodun "işe" olan yansımasını hiç düşünmemiştim. Bir başka çalışma arkadaşım, Chris Matts, beni behaviour-driven development'ı "business value" bağlamında düşünmeye itti.

Amaç JBehave'in kendi kendini denetleyen bir yapıda olmasını sağlamaktı. Bu kapsamda **Sistemin şu anda yapmadığı bir sonraki en önemli şey nedir?** sorusunu sormanın hedeften sapmamak için faydalı bir yol olduğunu keşfettim.

Bu soru, henüz gerçekleştirmediğiniz özelliklerin değerini belirlemenizi ve onları önceliklendirmenizi gerektirir. Aynı zamanda behaviour metodunuzun ismini bulmanıza yardım eder: Sistem X'i yapmıyor (X anlamlı bir davranış olsun), ve X önemli, demek ki sistem X'i yapmalı. Öyleyse bir sonraki davranışınız basitçe:

{% highlight java %}
public void shouldDoX() {
    // ...
}
{% endhighlight %}

Artık diğer bir TDD sorusuna da cevabım vardı: Nereden başlamalı?

## Gereksinimler de davranışlardır

Bu noktaya geldiğimde, TDD'nin nasıl çalıştığını anlamamı, daha da önemlisi anlatmamı sağlayacak bir framework'üm vardı. Aynı zamanda bu yaklaşım daha evvel karşılaştığım tuzaklardan da koruyordu.

2004 yılının sonuna doğru, Matts'e yeni keşfimi, davranış bazlı jargonumu anlatırken, bana "Bu aynı analiz gibi." dedi. Bu fikri hazmetmek için biraz durduk, ardından tüm bu davranış odaklı düşünme şeklini gereksinimleri tanımlama adımına uygulamaya karar verdik. Eğer analistler, testçiler, geliştiriciler ve de çalıştığımız alandaki kullanıcılar için tutarlı bir jargon oluşturabilirsek, bu teknik ve iş dünyası arasındaki çoğu anlaşmazlığı ve karışıklığı da ortadan kaldırmaya yarayacaktı.

## BDD analiz için "hazır bir dil" sağlar

O sıralarda, Eric Evans liste başı kitabı Domain-Driven Design'ı yayımladı. Kitabında bir sistemi, o sistemin alanını baz alan hali hazırdaki bir dili kullanarak modellemeyi tarif ediyordu. Böylelikle "iş dili" direk olarak koda yansıyordu.

Chris ve ben *bizzat analiz süreci* için bir dil yaratmaya çalışıyorduk. İyi bir başlangıç noktası yakalamıştık. Şirketçe ortak kullanımda olan hali hazırda şu sekilde bir şablon vardı:

**Bir** [X] **olarak**  
[Y]'**yi istiyorum**  
**böylece** [Z]

burada Y herhangi bir özellik, Z bu özelliğin faydası veya değeri, X ise Y'den faydalanacak bir kullanıcı veya bir rol yerine geçmektedir. Bu yaklaşımın gücü, sizi, özelliği daha tanımlarken, onun değerini de belirlemeye itmesidir. Eğer bir özelliğin arkasında gerçek bir değer (business value) yoksa çoğu zaman diyalog şöyle gerçekleşir: "... [herhangi bir özelliği] istiyorum, böylece [sadece istiyorum]." Bu şablon bu gibi egzantirik gereksinimleri kapsam dışı bırakmayı daha kolay kılmaktadır.

Bu noktadan yola çıkarak, Matts ile birlikte zaten her çevik testçinin bildiğini yeniden keşfettik: Bir hikayenin davranışı basitçe onun kabul kriterleridir - eğer sistem tüm kabul kriterlerini karşılarsa, o zaman doğru davranıyordur, tersiyse, doğru davranmıyordur. Dolayısıyla bir hikayenin kabul kriterlerini yakalayan bir şablon oluşturduk.

Bu şablonun analistlere suni veya sınırlayıcı hissettirmeyecek kadar esnek ama bir hikayeyi parçalarına ayırabilecek ve onları otomatikleştirecek kadar yapısal olması gerekmekteydi. Dolayısıyla kabul kriterlerini *senaryolar* olarak tanımlamaya başladık. Şu şekli aldı:

**Given** (Tanımlanan): İlk şartlar,  
**when** (Ne zaman): bir olay olunca,  
**then** (Sonuç): sonuçları doğrula.

Örneklendirmek için, klasik ATM örneğini verelim. Hikaye kartlarından biri şöyle olabilir:

+Başlık: Müşteri para çeker+  
**Bir** müşteri **olarak**,  
ATM'den para çekmek **istiyorum**,  
**böylece** bankada sıra beklememe gerek kalmaz.

O zaman bu hikayeyi tamamladığımızı ne zaman bilebiliriz? Göz önüne alınması gereken birkaç senaryo var: Hesapta bakiye mevcuttur. Hesap eksi bakiyededir, ama eksi bakiye limitinin altındadır. Hesap eksi bakiyededir ve eksi bakiye limitini de aşmıştır. Tabii ki başka senaryolar da olacaktır, mesela hesapta bakiye mevcuttur ama çekilecek para hesabı eksi bakiyeye düşürecektir veya ATM'de para kalmamıştır.

Burada *given-when-then* şablonunu kullanarak, ilk iki senaryo şu şekilde oluşturabiliriz:

+Senaryo 1: Hesapta bakiye var+  
**Given** Bakiyesi olan bir hesap   
**And** kart geçerli  
**And** ATM'de nakit   
**When** müşteri para çekmek istediği zaman  
**Then** paranın hesaptan düğtüğüne emin ol  
**And** paranın verildiğine emin ol  
**And** kartın iade edildiğine emin ol  

Tanımlanan ve sonuçların bağlanması için kullanılan "and"'e (ve) dikkat edin.

+Senaryo 2: Hesap bakiyesi ekside ve eksi limit aşılmış+  
**Given** Hesap eksi bakiyede  
**And** kart geçerli  
**When** müşteri para çekmek istediği zaman  
**Then** red mesajının gösterildiğine emin ol    
**And** paranın verilmediğine emin ol  
**And** kartın iade edildiğine emin ol  

İki senaryo da aynı olay üzerine kurulu, hatta aynı girdileri (given) ve sonuçları da (then) paylaşıyorlar. Burada girdileri, olayları ve sonuçları tekrar kullanabileceğimizin altını çizelim.

## Kabul kriterlerinin çalıştırılabilir olması lazım

Senaryoların parçaları, girdiler, olaylar ve sonuçlar, kodda direk olarak temsil edilebilecek kadar ayrıntılı olmalı. JBehave bize senaryo parçalarını Java sınıflarında adresleyebilmemizi sağlayan bir nesne modeli vermektedir.

Her given'ı temsil eden bir sınıfı şu şekilde yazabilirsiniz:

{% highlight java %}
public class AccountIsInCredit implements Given {
    public void setup(World world) {
        ...
    }
}
public class CardIsValid implements Given {
    public void setup(World world) {
        ...
    }
}
{% endhighlight %}

Bir olay (when) için:

{% highlight java %}
public class CustomerRequestsCash implements Event {
    public void occurIn(World world) {
        ...
    }
}
{% endhighlight %}

Benzer sınıflar çıktılar (then) için de yapılır. JBehave tüm bunları birbirine bağlar ve çalıştırır. Nesnelerinizi saklayıp, given'ları geçirebileceği bir "dünya" yaratır. Ardından JBehave "olaya",  o "dünyada" "gerçekleşmesini" söyler. Bu da senaryonun davranışını işletir. En sonunda da kontrolü, tanımladığımız "sonuç" nesnelerine geçirir.

Elimizde her bir parçayı temsil eden bir sınıf olması, bu parçaları başka senaryolarda tekrardan kullanmamıza olanak verir. İlk başta bu parçalar mock'lar kullanılarak gerçekleştirilir. Mesela bakiyesi olan bir hesabı veya geçerli bir kartı temsil etmek için. Böylece davranışı tanımlarken bir başlangıç noktası oluşmuş olur. Uygulamayı kodladıkça, tanımlananlar (given) ve sonuçlar (then) gerçek sınıfları kullanacak şekilde değiştirilir. Böylelikle sonunda gerçek sınıflardan oluşan uçtan uca fonksiyonel testleriniz olmuş olur.

## JBehave'in bugünü ve yarını

Kısa bir aradan sonra JBehave tekrar aktif geliştirmeye dönmüş durumda. Çekirdeği oldukça tam ve sağlam bir halde. Bir sonraki adım IntelliJ IDEA ve Eclipse gibi popüler IDE'ler ile entegrasyon.

[Dave Astels](http://daveastels.com/) aktif olarak BDD'nin reklamını yapıyor. Blogu ve yayımlanmış makaleleri birçok hareket çekti. BDD'nin Ruby dilinde gerçekleştirilmiş hali olan [rspec](http://rspec.rubyforge.org/) bunlardan biri. Ben de JBehave'in Ruby versiyonu olan rbehave üzerinde çalışmaya başladım.

Bazı çalışma arkadaşlarım çeşitli projelerde BDD tekniklerini kullandılar ve bunları oldukça başarılı buldular. JBehave'in hikaye çalıştırıcısı (Behaviour runner) yani kabul kriterlerini onaylayan kısmı, aktif olarak geliştirilmekte.

Vizyonumuz analistlerin ve testçilerin düz metin editöründe hikayeleri yazabileceği ve bunlardan davranış sınıflarının yaratılabileceği bir editor yaratmak. Ve hepsi iş alanının dilinde olacak şekilde. BDD birçok kişinin yardımıyla gelişti ve hepsine minnettarım.

-- *Dan North*, [http://dannorth.net/introducing-bdd](http://dannorth.net/introducing-bdd)