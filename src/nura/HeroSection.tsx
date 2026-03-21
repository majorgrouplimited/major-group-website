import { useEffect, useRef } from "react";

const appHome = "/nura/assets/app-home.png";

const HeroSection = () => {
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
      style={{ background: "var(--nura-hero-gradient)" }}
    >
      <div className="absolute top-20 left-10 w-72 h-72 rounded-full bg-[hsl(123_54%_24%)]/5 blur-3xl" />
      <div className="absolute bottom-20 right-10 w-96 h-96 rounded-full bg-[hsl(43_100%_50%)]/10 blur-3xl" />

      <div className="nura-container relative z-10 flex flex-col lg:flex-row items-center gap-12 lg:gap-20 py-16">
        <div className="flex-1 text-center lg:text-left max-w-xl">
          <div
            data-reveal
            className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[hsl(123_54%_24%)]/10 text-[hsl(123_54%_24%)] text-sm font-medium mb-6 opacity-0"
          >
            <span className="w-2 h-2 rounded-full bg-[hsl(123_54%_24%)]" />
            Your spiritual companion
          </div>

          <h1
            data-reveal
            className="text-5xl sm:text-6xl lg:text-7xl font-bold text-[hsl(200_19%_18%)] leading-[1.05] tracking-tight mb-6 opacity-0 nura-delay-100"
            style={{ fontFamily: "'Playfair Display', Georgia, serif" }}
          >
            Nura
          </h1>

          <p
            data-reveal
            className="text-lg sm:text-xl text-[hsl(200_10%_46%)] leading-relaxed mb-8 max-w-md mx-auto lg:mx-0 opacity-0 nura-delay-200"
            style={{ textWrap: "pretty" }}
          >
            Prayer times, duas, Quran verses, and AI-powered Islamic guidance — all in one beautifully designed app.
          </p>

          <div data-reveal className="flex flex-col sm:flex-row gap-3 justify-center lg:justify-start opacity-0 nura-delay-300">
            <a
              href="#download"
              className="inline-flex items-center justify-center h-14 px-8 rounded-2xl font-semibold text-white transition-all duration-200 hover:shadow-lg active:scale-[0.97]"
              style={{ background: "var(--nura-green-gradient)" }}
            >
              Download for iOS
            </a>
            <a
              href="#features"
              className="inline-flex items-center justify-center h-14 px-8 rounded-2xl font-semibold text-[hsl(200_19%_18%)] bg-[hsl(0_0%_96%)] border border-[hsl(120_10%_90%)] transition-all duration-200 hover:bg-[hsl(0_0%_96%)] active:scale-[0.97]"
            >
              Explore Features
            </a>
          </div>
        </div>

        <div data-reveal className="flex-shrink-0 opacity-0 nura-delay-400">
          <div className="nura-float">
            <div className="nura-phone-mockup w-[280px] sm:w-[300px]">
              <img
                src={appHome}
                alt="Nura app home screen showing prayer times and tracker"
                className="w-full"
                loading="eager"
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HeroSection;
