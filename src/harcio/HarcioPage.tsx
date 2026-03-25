import Navbar from "./Navbar";
import HeroSection from "./HeroSection";
import FeaturesSection from "./FeaturesSection";
import ShowcaseSection from "./ShowcaseSection";
import CtaSection from "./CtaSection";
import Footer from "./Footer";
import "./harcio.css";

const HarcioPage = () => {
  return (
    <div className="harcio-page">
      <Navbar />
      <main>
        <HeroSection />
        <FeaturesSection />
        <ShowcaseSection />
        <CtaSection />
      </main>
      <Footer />
    </div>
  );
};

export default HarcioPage;
