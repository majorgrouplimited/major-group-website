import Navbar from "./Navbar";
import Footer from "./Footer";
import "./harcio.css";
import { useEffect } from "react";

const PrivacyPolicy = () => {
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="harcio-page">
      <Navbar />
      <main className="pt-32 pb-24 px-6 md:px-12 bg-gray-50 min-h-screen">
        <div className="max-w-4xl mx-auto bg-white rounded-[2rem] p-8 md:p-16 shadow-sm border border-gray-100">
          <div className="mb-12 border-b border-gray-100 pb-8">
            <h1 className="harcio-heading text-4xl font-bold text-gray-900 mb-4">Gizlilik Politikası</h1>
            <p className="text-gray-500 font-medium">Son güncelleme: 25 Mart 2026</p>
          </div>

          <div className="prose prose-emerald max-w-none text-gray-700 leading-relaxed space-y-8">
            <p className="text-lg">
              Bu Gizlilik Politikası, <strong className="text-gray-900">Harcio</strong> uygulamasını ("Uygulama", "hizmet") kullanan kişilere ("kullanıcı", "siz") kişisel verilerinizin nasıl toplandığını, kullanıldığını, depolandığını ve paylaşıldığını açıklamaktadır. Uygulamayı kullanarak bu politikayı kabul etmiş sayılırsınız.
            </p>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">1. Topladığımız Veriler</h2>
              <p className="mb-4">Aşağıdaki kişisel ve teknik verileri toplayabiliriz:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li><strong className="text-gray-900">Hesap bilgileri:</strong> Kullanıcı adı, biyografi ve profil fotoğrafı.</li>
                <li><strong className="text-gray-900">Konum bilgisi:</strong> Yakın restoranları listeleyebilmek için şehir veya konum verisi.</li>
                <li><strong className="text-gray-900">Yüklenen dosyalar:</strong> Fişler, faturalar ve diğer görsel içerikler (fotoğraflar).</li>
                <li><strong className="text-gray-900">İşlem verileri:</strong> Harcama tutarları, para birimi ve ziyaret edilen restoran bilgileri.</li>
                <li><strong className="text-gray-900">Cihaz ve teknik veriler:</strong> IP adresi, işletim sistemi, uygulama sürümü ve kullanım istatistikleri.</li>
                <li><strong className="text-gray-900">Abonelik ve ödeme verileri:</strong> RevenueCat aracılığıyla yönetilen abonelik durumu (ödeme aracı bilgileri tarafımızca saklanmaz).</li>
              </ul>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">2. Verilerin Kullanım Amaçları</h2>
              <p className="mb-4">Topladığımız veriler şu amaçlarla kullanılır:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Hizmeti sağlamak, kişiselleştirmek ve iyileştirmek,</li>
                <li>Yapay zeka aracılığıyla fiş verilerini otomatik analiz etmek,</li>
                <li>Kullanıcı sıralamaları, başarı rozetleri ve öneri sistemleri oluşturmak,</li>
                <li>Teknik sorunları tespit etmek ve gidermek,</li>
                <li>Yasal yükümlülükleri yerine getirmek,</li>
                <li>Ticari faaliyetlerimizi yürütmek (aşağıdaki 3. maddeye bakınız).</li>
              </ul>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">3. Yüklenen Fotoğrafların Ticari Kullanımı</h2>
              <div className="bg-amber-50 border-l-4 border-amber-500 p-6 rounded-r-xl my-6">
                <p className="text-amber-900 text-sm md:text-base leading-relaxed">
                  <strong className="font-bold">Önemli Bildirim:</strong> Uygulamayı kullanarak, yüklediğiniz tüm fotoğraflar (fiş görüntüleri, profil fotoğrafı ve diğer görsel içerikler) dahil olmak üzere tarafımıza ilettiğiniz her türlü görsel materyalin; reklam, pazarlama, iş geliştirme, ürün geliştirme, veri analizi, yapay zeka model eğitimi ve diğer her türlü <strong className="font-bold">ticari faaliyet</strong> kapsamında, süresiz, dünya genelinde, alt lisanslanabilir ve devredilebilir bir lisans çerçevesinde <strong className="font-bold">ücretsiz olarak kullanılmasına açık ve zımni rıza</strong> göstermiş olursunuz. Bu fotoğraflar üçüncü taraflara paylaşılabilir, yayımlanabilir ve işlenebilir; kişisel verilerle ilişkilendirildiklerinde ise yürürlükteki veri koruma mevzuatına uygun şekilde işlenir.
                </p>
              </div>
              <p>
                Fotoğraflarınızın bu şekilde kullanılmasını istemiyorsanız lütfen Uygulama'yı kullanmayınız veya <a href="mailto:support@majorgrup.tc" className="text-emerald-600 font-medium hover:text-emerald-700 hover:underline">support@majorgrup.tc</a> adresine yazarak hesabınızın silinmesini talep ediniz.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">4. Verilerin Paylaşımı</h2>
              <p className="mb-4">Verilerinizi aşağıdaki durumlarda üçüncü taraflarla paylaşabiliriz:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li><strong className="text-gray-900">Altyapı sağlayıcıları:</strong> Amazon Web Services (S3, SNS) – dosya depolama ve bildirim.</li>
                <li><strong className="text-gray-900">Ödeme ve abonelik:</strong> RevenueCat – abonelik yönetimi.</li>
                <li><strong className="text-gray-900">Yasal zorunluluk:</strong> Mahkeme kararı veya yasal talep halinde yetkili kurumlarla.</li>
                <li><strong className="text-gray-900">İş transferi:</strong> Şirket birleşmesi, satışı veya varlık devri süreçlerinde.</li>
                <li><strong className="text-gray-900">Ticari ortaklar:</strong> Yukarıda belirtilen ticari kullanım kapsamında reklam ve pazarlama iş ortaklarıyla.</li>
              </ul>
              <p className="mt-4">Verilerinizi pazarlama amacıyla üçüncü taraflara satmıyoruz; ancak ticari ortaklıklar kapsamında paylaşım yapılabilir.</p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">5. Veri Güvenliği</h2>
              <p>
                Verilerinizi yetkisiz erişim, değiştirme veya ifşadan korumak için endüstri standardı teknik ve idari güvenlik önlemleri uyguluyoruz. Yüklenen dosyalar şifreli AWS S3 depolarında saklanır. Hiçbir sistemin %100 güvenli olmadığını hatırlatırız.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">6. Veri Saklama</h2>
              <p>
                Verilerinizi hesabınız aktif olduğu sürece saklarız. Hesap silme talebinde bulunmanız halinde kişisel verilerinizi 90 gün içinde sileriz; ancak yasal yükümlülükler veya meşru menfaatlerimiz kapsamında daha uzun süre saklamamız gerekebilir.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">7. Çocukların Gizliliği</h2>
              <p>
                Uygulamamız 13 yaş altındaki bireylere yönelik değildir. 13 yaşından küçük kullanıcılara ait veri topladığımızı fark edersek söz konusu verileri derhal sileriz.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">8. Kullanıcı Hakları</h2>
              <p className="mb-4">Yürürlükteki mevzuat kapsamında aşağıdaki haklara sahip olabilirsiniz:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Verilerinize erişim talep etme,</li>
                <li>Yanlış verilerin düzeltilmesini isteme,</li>
                <li>Verilerinizin silinmesini talep etme ("unutulma hakkı"),</li>
                <li>İşlemeye itiraz etme veya kısıtlama talep etme,</li>
                <li>Veri taşınabilirliği talep etme.</li>
              </ul>
              <p className="mt-4">
                Bu haklarınızı kullanmak için <a href="mailto:support@majorgrup.tc" className="text-emerald-600 font-medium hover:text-emerald-700 hover:underline">support@majorgrup.tc</a> adresine başvurabilirsiniz.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">9. Çerezler ve İzleme Teknolojileri</h2>
              <p>
                Mobil Uygulama, performans ve kullanım analizi amacıyla uygulama içi analitik araçlar kullanabilir. Tarayıcı tabanlı çerez politikası, Uygulama'nın web varlığı için ayrıca geçerlidir.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">10. Politika Değişiklikleri</h2>
              <p>
                Bu politikayı zaman zaman güncelleyebiliriz. Önemli değişiklikler uygulama içi bildirim veya e-posta yoluyla duyurulacaktır. Değişikliğin yürürlüğe girmesinden sonra Uygulamayı kullanmaya devam etmeniz güncel politikayı kabul ettiğiniz anlamına gelir.
              </p>
            </section>

            <section>
              <h2 className="harcio-heading text-2xl font-bold text-gray-900 mb-4">11. İletişim</h2>
              <div className="bg-gray-50 p-6 rounded-xl border border-gray-100">
                <p>Bu politikayla ilgili sorularınız için:</p>
                <p className="mt-2"><strong className="text-gray-900">E-posta:</strong> <a href="mailto:support@majorgrup.tc" className="text-emerald-600 font-medium hover:text-emerald-700 hover:underline">support@majorgrup.tc</a></p>
              </div>
            </section>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default PrivacyPolicy;