const Footer = () => {
  return (
    <footer className="py-12 border-t border-gray-100 bg-white">
      <div className="harcio-container">
        <div className="flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-3">
            <img src="/harcio/icon.png" alt="Harcio Logo" className="w-10 h-10 rounded-xl shadow-sm object-cover" />
            <span className="font-bold text-xl text-gray-900 tracking-tight harcio-heading">Harcio</span>
          </div>
          
          <div className="flex flex-wrap justify-center gap-6 text-sm text-gray-500 font-medium">
            <a href="#" className="hover:text-emerald-600 transition-colors">Hakkımızda</a>
            <a href="/harcio/privacy-policy" className="hover:text-emerald-600 transition-colors">Gizlilik Politikası</a>
            <a href="#" className="hover:text-emerald-600 transition-colors">Kullanım Koşulları</a>
            <a href="#" className="hover:text-emerald-600 transition-colors">İletişim</a>
          </div>

          <div className="text-sm text-gray-400 font-medium">
            © {new Date().getFullYear()} Harcio. Tüm hakları saklıdır.
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;