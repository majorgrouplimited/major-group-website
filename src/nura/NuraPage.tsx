import Navbar from "./Navbar";
import HeroSection from "./HeroSection";
import FeaturesSection from "./FeaturesSection";
import WidgetSection from "./WidgetSection";
import ShowcaseSection from "./ShowcaseSection";
import LanguagesSection from "./LanguagesSection";
import CtaSection from "./CtaSection";
import Footer from "./Footer";
import "./nura.css";

const NuraPage = () => (
  <div className="nura-page">
    <Navbar />
    <main>
      <HeroSection />
      <FeaturesSection />
      <WidgetSection />
      <ShowcaseSection />
      <LanguagesSection />
      <CtaSection />
    </main>
    <Footer />
  </div>
);

export default NuraPage;
