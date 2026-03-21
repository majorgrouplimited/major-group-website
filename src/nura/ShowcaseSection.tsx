import { useEffect, useRef } from "react";

const appShalat = "/nura/assets/app-shalat.png";
const appDua = "/nura/assets/app-dua.png";
const appMood = "/nura/assets/app-mood.png";
const appAsk = "/nura/assets/app-ask.png";
const appAskAnswer = "/nura/assets/app-ask-answer.png";
const appMoodResult = "/nura/assets/app-mood-result.png";
const appPrayerHistory = "/nura/assets/app-prayer-history.png";
const appAyat = "/nura/assets/app-ayat.png";

const screens = [
  { img: appShalat, label: "Shalat Times", desc: "Detailed daily schedule with alarm support" },
  { img: appDua, label: "Do'a Collection", desc: "Supplications for every occasion" },
  { img: appPrayerHistory, label: "Prayer Tracker", desc: "Track and review your daily prayers" },
  { img: appAyat, label: "Ayat Widget", desc: "Quran verses delivered to your home screen" },
];

const aiScreens = [
  {
    imgs: [appAsk, appAskAnswer],
    label: "Ask about Islam",
    desc: "Type any question and get answers grounded in Quran & Hadith — complete with source references you can verify.",
  },
  {
    imgs: [appMood, appMoodResult],
    label: "Dua for Your Mood",
    desc: "Share how you feel and receive a personalized dua with comforting guidance tailored to your emotional state.",
  },
];

const ShowcaseSection = () => {
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
    <section ref={sectionRef} className="py-24 sm:py-32 bg-[hsl(0_0%_96%)]/50">
      <div className="nura-container">
        <div data-reveal className="text-center mb-16 opacity-0">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4 text-balance" style={{ lineHeight: 1.15, fontFamily: "'Playfair Display', Georgia, serif" }}>
            Designed with care, built with purpose
          </h2>
          <p className="text-lg text-[hsl(200_10%_46%)] max-w-lg mx-auto">
            Every screen is crafted to bring you closer to your faith.
          </p>
        </div>

        <div className="grid grid-cols-2 lg:grid-cols-4 gap-6 lg:gap-8 mb-28">
          {screens.map((s, i) => (
            <div
              key={s.label}
              data-reveal
              className="opacity-0 text-center"
              style={{ animationDelay: `${(i + 1) * 100}ms` }}
            >
              <div className="nura-phone-mockup w-[180px] sm:w-[200px] lg:w-[220px] mx-auto mb-4">
                <img src={s.img} alt={s.label} className="w-full" loading="lazy" />
              </div>
              <h3 className="font-semibold text-base mb-1" style={{ fontFamily: "'Inter', system-ui, sans-serif" }}>{s.label}</h3>
              <p className="text-sm text-[hsl(200_10%_46%)]">{s.desc}</p>
            </div>
          ))}
        </div>

        <div data-reveal className="text-center mb-16 opacity-0">
          <span className="inline-block text-xs font-medium px-3 py-1 rounded-full mb-4"
            style={{ background: "var(--nura-amber-gradient)", color: "white" }}>
            AI-Powered
          </span>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4 text-balance" style={{ lineHeight: 1.15, fontFamily: "'Playfair Display', Georgia, serif" }}>
            Islamic knowledge, powered by AI
          </h2>
          <p className="text-lg text-[hsl(200_10%_46%)] max-w-2xl mx-auto" style={{ textWrap: "pretty" as any }}>
            Ask any question about Islam or share how you feel — Nura responds with answers and duas sourced from the Quran and Hadith.
          </p>
        </div>

        <div className="flex flex-col gap-20">
          {aiScreens.map((feature, fi) => (
            <div
              key={feature.label}
              data-reveal
              className={`opacity-0 flex flex-col ${fi % 2 === 0 ? "lg:flex-row" : "lg:flex-row-reverse"} items-center gap-8 lg:gap-16`}
              style={{ animationDelay: `${(fi + 1) * 150}ms` }}
            >
              <div className="flex items-end justify-center gap-4 shrink-0">
                {feature.imgs.map((img, ii) => (
                  <div
                    key={ii}
                    className="nura-phone-mockup"
                    style={{
                      width: ii === 0 ? "160px" : "180px",
                      transform: ii === 0 ? "translateY(0)" : "translateY(-12px)",
                    }}
                  >
                    <img src={img} alt={`${feature.label} screen ${ii + 1}`} className="w-full" loading="lazy" />
                  </div>
                ))}
              </div>

              <div className={`text-center lg:text-left max-w-md ${fi % 2 === 0 ? "" : "lg:text-right"}`}>
                <h3 className="text-2xl sm:text-3xl font-bold mb-3" style={{ fontFamily: "'Inter', system-ui, sans-serif" }}>{feature.label}</h3>
                <p className="text-[hsl(200_10%_46%)] leading-relaxed">{feature.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default ShowcaseSection;
