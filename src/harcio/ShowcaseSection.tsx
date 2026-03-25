import { useEffect, useRef } from "react";

const ShowcaseSection = () => {
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
      { threshold: 0.2 }
    );

    const els = sectionRef.current?.querySelectorAll("[data-reveal]");
    els?.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  return (
    <section ref={sectionRef} id="how-it-works" className="py-24 overflow-hidden">
      <div className="harcio-container">
        <div className="flex flex-col lg:flex-row items-center gap-16">
          <div data-reveal className="flex-1 opacity-0">
            <div className="aspect-square rounded-full bg-emerald-500/5 relative flex items-center justify-center p-8 lg:p-12">
              <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,var(--tw-gradient-stops))] from-emerald-100 to-transparent blur-2xl opacity-50" />
              
              <div className="relative w-full max-w-[320px] aspect-[4/5] bg-white rounded-3xl shadow-2xl border border-gray-100 overflow-hidden flex flex-col z-10 scale-100 transform transform-gpu transition-all duration-500 hover:scale-105">
                <div className="h-12 bg-gray-900 flex items-center px-6">
                  <span className="text-white font-bold text-sm tracking-widest flex items-center gap-2">
                    <div className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></div>
                    YAPAY ZEKA ANALİZİ
                  </span>
                </div>
                <div className="flex-1 p-6 flex flex-col gap-4 bg-gray-50">
                  <div className="w-full h-40 bg-white rounded-xl border-2 border-dashed border-gray-300 flex items-center justify-center overflow-hidden relative">
                    <img src="https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80" alt="Receipt" className="opacity-40 object-cover w-full h-full grayscale" />
                    <div className="absolute inset-0 bg-emerald-500/10 flex items-center justify-center">
                      <div className="h-0.5 w-full bg-emerald-400 absolute top-1/2 left-0 shadow-[0_0_8px_2px_rgba(52,211,153,0.8)] animate-[harcioFloat_2s_ease-in-out_infinite]" />
                    </div>
                  </div>
                  <div className="space-y-3 mt-4">
                    <div className="h-4 bg-emerald-100 rounded-md w-3/4"></div>
                    <div className="h-4 bg-emerald-100 rounded-md w-1/2"></div>
                    <div className="h-10 bg-emerald-200 rounded-xl w-full mt-4 flex items-center justify-between px-4">
                      <span className="text-emerald-800 text-xs font-bold uppercase tracking-wider">Toplam</span>
                      <span className="text-emerald-900 text-lg font-black" style={{ fontFamily: 'Outfit, sans-serif' }}>₺ 840.50</span>
                    </div>
                  </div>
                </div>
              </div>

            </div>
          </div>

          <div className="flex-1 max-w-xl">
            <h2 data-reveal className="harcio-heading text-3xl sm:text-4xl lg:text-5xl font-bold mb-6 text-gray-900 opacity-0 harcio-delay-100 text-balance leading-tight">
              Yapay Zeka ile Fişlerinizi Okutun
            </h2>
            <p data-reveal className="text-lg text-gray-600 mb-10 opacity-0 harcio-delay-200">
              Uygulamaya yüklediğiniz restoran adisyonları, güçlü <strong className="text-gray-900">Yapay Zeka</strong> altyapısı sayesinde anında okunur. Manuel veri girmeye son!
            </p>
            
            <ul className="space-y-8">
              {[
                { number: "01", title: "Fotoğraf Çekin", desc: "Adisyonun net bir fotoğrafını çekin veya galeriden yükleyin." },
                { number: "02", title: "Otomatik Analiz", desc: "Yapay zeka toplam tutarı, para birimini ve restoran adını tespit eder." },
                { number: "03", title: "İstatistik ve Rozetler", desc: "Harcamalarınız profilinize eklenir, istatistikleriniz güncellenir ve yeni rozetler kazanırsınız." }
              ].map((step, idx) => (
                <li key={idx} data-reveal className="flex gap-5 opacity-0" style={{ animationDelay: `${(idx + 3) * 100}ms` }}>
                  <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center font-bold text-lg flex-shrink-0 harcio-heading shadow-sm">
                    {step.number}
                  </div>
                  <div>
                    <h4 className="harcio-heading text-xl font-bold text-gray-900 mb-2">{step.title}</h4>
                    <p className="text-gray-600 leading-relaxed">{step.desc}</p>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ShowcaseSection;