const Footer = () => (
  <footer className="py-10 border-t border-[hsl(120_10%_90%)]">
    <div className="nura-container flex flex-col sm:flex-row items-center justify-between gap-4 text-sm text-[hsl(200_10%_46%)]">
      <span className="flex items-center gap-2 font-semibold text-[hsl(123_54%_24%)]" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>
        <img src="/nura/nura-icon.png" alt="Nura" className="w-6 h-6 rounded-md" />
        Nura
      </span>
      <p>&copy; {new Date().getFullYear()} Nura. All rights reserved.</p>
      <div className="flex gap-5">
        <a href="#" className="hover:text-[hsl(200_19%_18%)] transition-colors">Privacy</a>
        <a href="#" className="hover:text-[hsl(200_19%_18%)] transition-colors">Terms</a>
        <a href="#" className="hover:text-[hsl(200_19%_18%)] transition-colors">Contact</a>
      </div>
    </div>
  </footer>
);

export default Footer;
