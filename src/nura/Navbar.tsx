import { useState } from "react";
import { Menu, X } from "lucide-react";

const Navbar = () => {
  const [open, setOpen] = useState(false);

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-[hsl(120_7%_99%)]/80 backdrop-blur-lg border-b border-[hsl(120_10%_90%)]/50">
      <div className="nura-container flex items-center justify-between h-16">
        <a href="/nura" className="flex items-center gap-2 text-xl font-bold text-[hsl(123_54%_24%)] tracking-tight" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>
          <img src="/nura/nura-icon.png" alt="Nura" className="w-8 h-8 rounded-lg" />
          Nura
        </a>

        <div className="hidden sm:flex items-center gap-6">
          <a href="#features" className="text-sm text-[hsl(200_10%_46%)] hover:text-[hsl(200_19%_18%)] transition-colors">
            Features
          </a>
          <a href="#download" className="text-sm text-[hsl(200_10%_46%)] hover:text-[hsl(200_19%_18%)] transition-colors">
            Download
          </a>
          <a
            href="#download"
            className="inline-flex items-center h-10 px-5 rounded-xl text-sm font-semibold text-white transition-all duration-200 hover:shadow-md active:scale-[0.97]"
            style={{ background: "var(--nura-green-gradient)" }}
          >
            Get the App
          </a>
        </div>

        <button
          onClick={() => setOpen(!open)}
          className="sm:hidden p-2 rounded-lg hover:bg-[hsl(0_0%_96%)] transition-colors"
          aria-label="Menu"
        >
          {open ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
        </button>
      </div>

      {open && (
        <div className="sm:hidden border-t border-[hsl(120_10%_90%)] bg-[hsl(120_7%_99%)] px-6 py-4 space-y-3">
          <a href="#features" onClick={() => setOpen(false)} className="block text-sm text-[hsl(200_10%_46%)]">Features</a>
          <a href="#download" onClick={() => setOpen(false)} className="block text-sm text-[hsl(200_10%_46%)]">Download</a>
          <a
            href="#download"
            onClick={() => setOpen(false)}
            className="block text-center h-10 leading-10 rounded-xl text-sm font-semibold text-white"
            style={{ background: "var(--nura-green-gradient)" }}
          >
            Get the App
          </a>
        </div>
      )}
    </nav>
  );
};

export default Navbar;
