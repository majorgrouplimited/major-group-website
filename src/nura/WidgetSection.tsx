import { useEffect, useRef } from "react";

const widgetHome = "/nura/assets/app-widget-home.png";
const widgetLock = "/nura/assets/app-widget-lock.png";

const WidgetSection = () => {
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
    <section ref={sectionRef} className="py-24 sm:py-32">
      <div className="nura-container">
        <div data-reveal className="text-center mb-16 opacity-0">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[hsl(123_54%_24%)]/10 text-[hsl(123_54%_24%)] text-sm font-medium mb-5">
            <span className="w-2 h-2 rounded-full bg-[hsl(123_54%_24%)]" />
            iOS Widgets
          </div>
          <h2
            className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4 text-balance"
            style={{ lineHeight: 1.15, fontFamily: "'Playfair Display', Georgia, serif" }}
          >
            Quran on your home &amp; lock screen
          </h2>
          <p className="text-lg text-[hsl(200_10%_46%)] max-w-lg mx-auto" style={{ textWrap: "pretty" }}>
            Beautiful widgets deliver Quran verses throughout your day — no need to open the app.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-8 lg:gap-14">
          <div data-reveal className="opacity-0 text-center">
            <div className="nura-phone-mockup w-[260px] sm:w-[250px] lg:w-[280px] mx-auto mb-4">
              <img
                src={widgetHome}
                alt="Nura Quran verse widget on iPhone home screen"
                className="w-full"
                loading="lazy"
              />
            </div>
            <h3 className="font-semibold text-base mb-1" style={{ fontFamily: "'Inter', system-ui, sans-serif" }}>Home Screen Widget</h3>
            <p className="text-sm text-[hsl(200_10%_46%)]">Quran verses at a glance</p>
          </div>

          <div data-reveal className="opacity-0 nura-delay-200 text-center">
            <div className="nura-phone-mockup w-[260px] sm:w-[250px] lg:w-[280px] mx-auto mb-4">
              <img
                src={widgetLock}
                alt="Nura Quran verse widget on iPhone lock screen"
                className="w-full"
                loading="lazy"
              />
            </div>
            <h3 className="font-semibold text-base mb-1" style={{ fontFamily: "'Inter', system-ui, sans-serif" }}>Lock Screen Widget</h3>
            <p className="text-sm text-[hsl(200_10%_46%)]">Verses without unlocking</p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default WidgetSection;
