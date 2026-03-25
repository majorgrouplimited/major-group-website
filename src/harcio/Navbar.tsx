import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { ChevronRight } from "lucide-react";

const Navbar = () => {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled ? "bg-white/80 backdrop-blur-md border-b border-gray-100 shadow-sm py-4" : "bg-transparent py-6"
      }`}
    >
      <div className="harcio-container flex items-center justify-between">
        <Link to="/" className="flex items-center gap-2 group">
          <img src="/harcio/icon.png" alt="Harcio Logo" className="w-10 h-10 rounded-xl drop-shadow-md object-cover" />
          <span className="text-2xl font-bold tracking-tight harcio-heading text-gray-900 group-hover:text-emerald-600 transition-colors">
            Harcio
          </span>
        </Link>
        <div className="hidden md:flex items-center gap-8 text-sm font-medium text-gray-600">
          <a href="#features" className="hover:text-emerald-500 transition-colors">Özellikler</a>
          <a href="#how-it-works" className="hover:text-emerald-500 transition-colors">Nasıl Çalışır</a>
          <a
            href="#download"
            className="flex items-center gap-2 px-5 py-2.5 bg-emerald-500 text-white rounded-full hover:bg-emerald-600 transition-all shadow-md hover:shadow-lg active:scale-95"
          >
            İndir <ChevronRight className="w-4 h-4" />
          </a>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
