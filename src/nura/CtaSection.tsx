import { useEffect, useRef } from "react";

const CtaSection = () => {
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
      { threshold: 0.2 }
    );

    const els = sectionRef.current?.querySelectorAll("[data-reveal]");
    els?.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  return (
    <section ref={sectionRef} id="download" className="py-24 sm:py-32">
      <div className="nura-container max-w-3xl text-center">
        <div
          data-reveal
          className="opacity-0 rounded-3xl p-10 sm:p-16"
          style={{ background: "var(--nura-green-gradient)" }}
        >
          <h2
            className="text-3xl sm:text-4xl lg:text-5xl font-bold text-white mb-4 text-balance"
            style={{ lineHeight: 1.15, fontFamily: "'Playfair Display', Georgia, serif" }}
          >
            Begin your journey with Nura
          </h2>
          <p className="text-white/80 text-lg mb-8 max-w-md mx-auto" style={{ textWrap: "pretty" }}>
            Download now and let every prayer, every dua, and every verse bring light to your day.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <a
              href="#"
              className="inline-flex items-center justify-center h-14 px-8 rounded-2xl font-semibold bg-white text-[hsl(123_54%_24%)] transition-all duration-200 hover:shadow-lg active:scale-[0.97]"
            >
              Download for iOS
            </a>
            <a
              href="#"
              className="inline-flex items-center justify-center h-14 px-8 rounded-2xl font-semibold border-2 border-white/30 text-white transition-all duration-200 hover:bg-white/10 active:scale-[0.97]"
            >
              Download for Android
            </a>
          </div>
        </div>
      </div>
    </section>
  );
};

export default CtaSection;
