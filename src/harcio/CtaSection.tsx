import { useEffect, useRef } from "react";
import { ArrowRight } from "lucide-react";

const CtaSection = () => {
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
    <section ref={sectionRef} id="download" className="py-24 px-4 sm:px-6 relative">
      <div className="harcio-container">
        <div 
          data-reveal
          className="bg-gray-900 rounded-[3rem] p-10 md:p-20 text-center relative overflow-hidden opacity-0 shadow-2xl"
        >
          <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-emerald-500/20 rounded-full blur-[100px] -translate-y-1/2 translate-x-1/2" />
          <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-teal-500/20 rounded-full blur-[100px] translate-y-1/2 -translate-x-1/2" />

          <div className="relative z-10 max-w-3xl mx-auto flex flex-col items-center">
            <div className="w-16 h-16 bg-white/10 rounded-2xl flex items-center justify-center mb-8 backdrop-blur-sm border border-white/10 shadow-xl">
              <span className="text-3xl font-bold text-white harcio-heading">H</span>
            </div>
            <h2 className="harcio-heading text-4xl md:text-5xl lg:text-6xl font-bold text-white mb-6 leading-tight">
              Gurme Serüveniniz Başlasın
            </h2>
            <p className="text-xl text-gray-300 mb-12 max-w-2xl leading-relaxed">
              Türkiye'nin dört bir yanındaki restoranları keşfedin, hesabınızı akıllıca takip edin ve liderlik tablolarında zirveye tırmanın.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto justify-center">
              <a
                href="#"
                className="h-16 px-10 rounded-full bg-emerald-500 text-white text-lg font-bold hover:bg-emerald-400 transition-all flex items-center justify-center gap-3 group shadow-[0_0_40px_-10px_rgba(16,185,129,0.5)] hover:shadow-[0_0_60px_-15px_rgba(16,185,129,0.7)] hover:-translate-y-1"
              >
                App Store'dan İndir
                <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
              </a>
              <a
                href="#"
                className="h-16 px-10 rounded-full bg-white/10 text-white text-lg font-bold hover:bg-white/20 transition-all border border-white/5 flex items-center justify-center gap-3 backdrop-blur-md hover:-translate-y-1"
              >
                Google Play
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default CtaSection;