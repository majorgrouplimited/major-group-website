import { useEffect, useRef } from "react";

const HeroSection = () => {
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
      { threshold: 0.1 }
    );

    const els = sectionRef.current?.querySelectorAll("[data-reveal]");
    els?.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  return (
    <section
      ref={sectionRef}
      className="relative min-h-screen flex items-center justify-center overflow-hidden pt-20"
      style={{ background: "var(--harcio-hero-gradient)" }}
    >
      <div className="absolute top-20 left-10 w-72 h-72 rounded-full bg-emerald-500/10 blur-3xl" />
      <div className="absolute bottom-20 right-10 w-96 h-96 rounded-full bg-teal-500/10 blur-3xl" />
      
      <div className="harcio-container relative z-10 flex flex-col xl:flex-row items-center gap-12 lg:gap-20 py-16">
        <div className="flex-1 text-center xl:text-left max-w-2xl">
          <div
            data-reveal
            className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-emerald-100 text-emerald-800 text-sm font-semibold mb-6 opacity-0 shadow-sm"
          >
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
            Yapay Zeka Destekli Hesap Yönetimi
          </div>

          <h1
            data-reveal
            className="harcio-heading text-5xl sm:text-6xl lg:text-7xl font-bold text-gray-900 leading-[1.1] tracking-tight mb-6 opacity-0 harcio-delay-100"
          >
            Yediğini Keşfet, <br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-500 to-teal-600">
              Harcamanı Yönet.
            </span>
          </h1>

          <p
            data-reveal
            className="text-lg sm:text-xl text-gray-600 leading-relaxed mb-8 mx-auto xl:mx-0 opacity-0 harcio-delay-200"
            style={{ textWrap: "pretty" }}
          >
            Yapay Zeka ile restoran fişlerinizi saniyeler içinde analiz edin. Harcamalarınızı takip edin, rozetler kazanın ve Türkiye'nin en iyi mekanlarında liderlik tablosuna tırmanın.
          </p>

          <div data-reveal className="flex flex-col sm:flex-row gap-4 justify-center xl:justify-start opacity-0 harcio-delay-300">
            <a
              href="#download"
              className="inline-flex items-center justify-center h-14 px-8 rounded-2xl font-bold text-white bg-gray-900 shadow-md transition-all duration-200 hover:bg-gray-800 hover:shadow-xl active:scale-[0.97]"
            >
              App Store'dan İndir
            </a>
            <a
              href="#download"
              className="inline-flex items-center justify-center h-14 px-8 rounded-2xl font-bold text-emerald-900 bg-white border border-emerald-100 shadow-sm transition-all duration-200 hover:bg-emerald-50 hover:border-emerald-200 active:scale-[0.97]"
            >
              Google Play'den İndir
            </a>
          </div>
          
          <div data-reveal className="mt-10 flex items-center justify-center xl:justify-start gap-4 text-sm text-gray-500 font-medium opacity-0 harcio-delay-400">
            <div className="flex -space-x-2">
              {[1, 2, 3, 4].map((i) => (
                <div key={i} className="w-8 h-8 rounded-full border-2 border-white bg-gray-200 flex items-center justify-center overflow-hidden relative z-10">
                  <img src={`https://i.pravatar.cc/100?img=${i+10}`} alt="User" />
                </div>
              ))}
            </div>
            <p>10.000+ gurme katıldı</p>
          </div>
        </div>

        <div data-reveal className="flex-shrink-0 opacity-0 harcio-delay-400 xl:mt-0 mt-8">
          <div className="harcio-float">
            <div className="harcio-phone-mockup w-[280px] sm:w-[320px]">
              <div className="harcio-phone-inner bg-gray-50 flex flex-col justify-end pb-8 px-4" style={{ backgroundImage: 'url(https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80)', backgroundSize: 'cover', backgroundPosition: 'center' }}>
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                <div className="relative z-10 text-white">
                  <span className="inline-block px-3 py-1 bg-emerald-500 text-xs font-bold rounded-lg mb-2 shadow-lg">Yeni Analiz</span>
                  <h3 className="text-xl font-bold mb-1">Nusr-Et Steakhouse</h3>
                  <p className="text-sm text-gray-200 flex items-center justify-between">
                    <span>Toplam Harcama</span>
                    <span className="font-bold text-emerald-400 text-lg">₺3.450</span>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HeroSection;
