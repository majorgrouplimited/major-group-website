import { useEffect, useRef } from "react";
import { Clock, BookOpen, Heart, MessageCircle, Sparkles, CheckCircle } from "lucide-react";

const features = [
  {
    icon: Clock,
    title: "Accurate Prayer Times",
    desc: "Precise timings for Fajr, Dhuhr, Asr, Maghrib, and Isha with live countdown to the next prayer.",
    accent: false,
  },
  {
    icon: CheckCircle,
    title: "Prayer Tracker",
    desc: "Track your daily prayers with a simple check-in system. View your history and build consistency.",
    accent: false,
  },
  {
    icon: BookOpen,
    title: "Quran Verses (Ayat)",
    desc: "Receive beautiful Quran verses on your home screen. Choose your refresh interval.",
    accent: false,
  },
  {
    icon: Heart,
    title: "Daily Duas",
    desc: "Curated supplications for every moment — morning, evening, travel, meals, and more.",
    accent: false,
  },
  {
    icon: MessageCircle,
    title: "Ask about Islam",
    desc: "Get answers grounded in Quran & Hadith. AI-powered knowledge at your fingertips.",
    accent: true,
  },
  {
    icon: Sparkles,
    title: "Dua for Your Mood",
    desc: "Share how you feel and receive a personalized dua with comforting guidance.",
    accent: true,
  },
];

const FeaturesSection = () => {
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
    <section ref={sectionRef} id="features" className="py-24 sm:py-32">
      <div className="nura-container">
        <div data-reveal className="text-center mb-16 opacity-0">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4 text-balance" style={{ lineHeight: 1.15, fontFamily: "'Playfair Display', Georgia, serif" }}>
            Everything you need for your spiritual journey
          </h2>
          <p className="text-lg text-[hsl(200_10%_46%)] max-w-2xl mx-auto" style={{ textWrap: "pretty" }}>
            From prayer times to AI-powered Islamic guidance, Nura keeps your faith at the center of your day.
          </p>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {features.map((f, i) => (
            <div
              key={f.title}
              data-reveal
              className="opacity-0 group relative p-6 rounded-2xl transition-all duration-300 hover:shadow-lg active:scale-[0.98]"
              style={{
                animationDelay: `${(i + 1) * 80}ms`,
                background: f.accent
                  ? "linear-gradient(135deg, hsl(43 100% 97%), hsl(38 80% 94%))"
                  : "hsl(0 0% 96%)",
                border: f.accent ? "1px solid hsl(43 60% 85%)" : "1px solid hsl(120 10% 90%)",
              }}
            >
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center mb-4"
                style={{
                  background: f.accent ? "var(--nura-amber-gradient)" : "var(--nura-green-gradient)",
                }}
              >
                <f.icon className="w-6 h-6 text-white" />
              </div>
              <h3 className="text-lg font-semibold mb-2" style={{ fontFamily: "'Inter', system-ui, sans-serif" }}>{f.title}</h3>
              <p className="text-[hsl(200_10%_46%)] text-sm leading-relaxed">{f.desc}</p>
              {f.accent && (
                <span className="absolute top-4 right-4 text-xs font-medium px-2 py-0.5 rounded-full bg-[hsl(43_100%_50%)]/20 text-[hsl(200_19%_18%)]">
                  AI-Powered
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
