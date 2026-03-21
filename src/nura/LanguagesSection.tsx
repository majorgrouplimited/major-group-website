import { useEffect, useRef } from "react";
import { Globe } from "lucide-react";

const languages = [
  "English", "\u0627\u0644\u0639\u0631\u0628\u064A\u0629", "T\u00FCrk\u00E7e", "Fran\u00E7ais", "Espa\u00F1ol",
  "Deutsch", "Bahasa Indonesia", "Bahasa Melayu", "Urdu",
  "\u09AC\u09BE\u0982\u09B2\u09BE", "\u0939\u093F\u0928\u094D\u0926\u0940", "\u0420\u0443\u0441\u0441\u043A\u0438\u0439", "\u4E2D\u6587",
];

const LanguagesSection = () => {
  const sectionRef = useRef<HTMLElement>(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("nura-fade-in-up");
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
    <section ref={sectionRef} className="py-24 sm:py-32 bg-[hsl(0_0%_96%)]/50">
      <div className="nura-container max-w-3xl text-center">
        <div data-reveal className="opacity-0 mb-10">
          <div className="w-14 h-14 rounded-2xl flex items-center justify-center mx-auto mb-5" style={{ background: "var(--nura-green-gradient)" }}>
            <Globe className="w-7 h-7 text-white" />
          </div>
          <h2 className="text-3xl sm:text-4xl font-bold mb-3 text-balance" style={{ lineHeight: 1.15, fontFamily: "'Playfair Display', Georgia, serif" }}>
            Available in 13 languages
          </h2>
          <p className="text-[hsl(200_10%_46%)] text-lg">
            Nura speaks your language — every screen, every feature, fully translated.
          </p>
        </div>

        <div data-reveal className="opacity-0 nura-delay-200 flex flex-wrap justify-center gap-2.5">
          {languages.map((lang) => (
            <span
              key={lang}
              className="px-4 py-2 rounded-xl bg-[hsl(120_7%_99%)] border border-[hsl(120_10%_90%)] text-sm font-medium text-[hsl(200_19%_18%)] shadow-sm"
            >
              {lang}
            </span>
          ))}
        </div>
      </div>
    </section>
  );
};

export default LanguagesSection;
