import { useEffect, useRef } from "react";
import { Camera, BrainCircuit, Trophy, MapPin, PieChart, Users } from "lucide-react";

const features = [
  {
    icon: Camera,
    title: "Fişleri Fotoğraflayın",
    desc: "Restoran adisyonlarını kameranızla çekin veya galeriden yükleyin.",
    accent: false,
  },
  {
    icon: BrainCircuit,
    title: "AI Destekli Analiz",
    desc: "Yapay zeka entegrasyonu fişten toplam tutarı ve para birimini otomatik çıkarır.",
    accent: true,
  },
  {
    icon: PieChart,
    title: "Harcama İstatistikleri",
    desc: "Aylık mutfak giderlerinizi takip edin, bütçenizi kolaylıkla yönetin.",
    accent: false,
  },
  {
    icon: Trophy,
    title: "Başarı Rozetleri",
    desc: "Yeni mekanlar keşfettikçe ve harcama baremlerini geçtikçe gamification rozetleri kazanın.",
    accent: true,
  },
  {
    icon: MapPin,
    title: "Restoran Liderlik Tabloları",
    desc: "Yakın çevrenizde, şehrinizde ve Türkiye genelinde en popüler mekanları keşfedin.",
    accent: false,
  },
  {
    icon: Users,
    title: "Kullanıcı Sıralamaları",
    desc: "Profilinizi geliştirin, arkadaşlarınızla yarışın ve gurme seviyenizi yükseltin.",
    accent: false,
  },
];

const FeaturesSection = () => {
  const sectionRef = useRef<HTMLElement>(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("harcio-fade-in-up");
          }
        });
      },
      { threshold: 0.15 }
    );

    const els = sectionRef.current?.querySelectorAll("[data-reveal]");
    els?.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  return (
    <section ref={sectionRef} id="features" className="py-24 sm:py-32 bg-gray-50/50">
      <div className="harcio-container">
        <div data-reveal className="text-center mb-16 opacity-0">
          <h2 className="harcio-heading text-3xl sm:text-4xl lg:text-5xl font-bold mb-4 text-balance text-gray-900">
            Harcamalarınızı Sosyalleştirin
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto" style={{ textWrap: "pretty" }}>
            Mekanları keşfedin, faturalarınızı tek tıkla dijitalleştirin ve diğer yemek severlerle tatlı bir rekabete girin.
          </p>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((f, i) => (
            <div
              key={f.title}
              data-reveal
              className="opacity-0 group relative p-8 rounded-3xl transition-all duration-300 hover:shadow-xl hover:-translate-y-1 bg-white border border-gray-100"
              style={{
                animationDelay: `${(i + 1) * 80}ms`,
                background: f.accent ? "linear-gradient(145deg, #f0fdf4, #ffffff)" : "#ffffff",
                borderColor: f.accent ? "#a7f3d0" : "#f3f4f6",
              }}
            >
              <div
                className={`w-14 h-14 rounded-2xl flex items-center justify-center mb-6 shadow-sm ${
                  f.accent ? "bg-gradient-to-br from-emerald-400 to-emerald-600" : "bg-gray-100"
                }`}
              >
                <f.icon className={`w-7 h-7 ${f.accent ? "text-white" : "text-gray-700"}`} />
              </div>
              <h3 className="harcio-heading text-xl font-bold mb-3 text-gray-900">{f.title}</h3>
              <p className="text-gray-600 text-sm leading-relaxed">{f.desc}</p>
              {f.accent && (
                <span className="absolute top-6 right-6 text-xs font-bold px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700">
                  Öne Çıkan
                </span>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;
