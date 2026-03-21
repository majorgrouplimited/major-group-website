/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React from 'react';
import { Routes, Route } from 'react-router-dom';
import NuraPage from './nura/NuraPage';
import { motion } from 'motion/react';
import {
  Smartphone,
  Code2,
  Palette,
  Rocket,
  ChevronRight,
  Mail,
  MapPin,
  Eye,
  ArrowRight,
} from 'lucide-react';

const Navbar = () => (
  <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md border-b border-black/5">
    <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
      <div className="text-2xl font-bold tracking-tighter">major<span className="text-black">.</span></div>
      <div className="hidden md:flex items-center gap-8 text-sm font-medium text-zinc-600">
        <a href="#services" className="hover:text-black transition-colors">Services</a>
        <a href="#products" className="hover:text-black transition-colors">Products</a>
        <a href="#contact" className="px-5 py-2.5 bg-black text-white rounded-full hover:bg-zinc-800 transition-colors">
          Start a Project
        </a>
      </div>
    </div>
  </nav>
);

const Hero = () => (
  <section className="pt-40 pb-20 px-6">
    <div className="max-w-7xl mx-auto">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="max-w-3xl"
      >
        <h1 className="text-6xl md:text-8xl font-bold tracking-tight leading-[0.9] mb-8">
          We build apps that <span className="text-zinc-400 italic">matter.</span>
        </h1>
        <p className="text-xl text-zinc-600 mb-10 leading-relaxed max-w-xl">
          major. is a boutique digital agency crafting high-performance mobile and web experiences for forward-thinking companies.
        </p>
        <div className="flex flex-wrap gap-4">
          <a href="#contact" className="px-8 py-4 bg-black text-white rounded-full font-medium flex items-center gap-2 hover:bg-zinc-800 transition-all group text-center">
            Get in touch
            <ChevronRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </a>
        </div>
      </motion.div>
    </div>
  </section>
);

const Services = () => {
  const services = [
    {
      icon: <Smartphone className="w-6 h-6" />,
      title: "Mobile Development",
      description: "Native and cross-platform mobile applications built with performance and scalability in mind."
    },
    {
      icon: <Code2 className="w-6 h-6" />,
      title: "Web Applications",
      description: "Modern, responsive web platforms using the latest technologies to drive your business forward."
    },
    {
      icon: <Palette className="w-6 h-6" />,
      title: "UI/UX Design",
      description: "User-centric design that balances aesthetic beauty with functional simplicity."
    },
    {
      icon: <Rocket className="w-6 h-6" />,
      title: "Product Strategy",
      description: "Helping you define your roadmap and navigate the path from idea to market leader."
    }
  ];

  return (
    <section id="services" className="py-24 px-6 bg-zinc-50">
      <div className="max-w-7xl mx-auto">
        <div className="mb-16">
          <h2 className="text-sm font-bold uppercase tracking-widest text-emerald-600 mb-4">What we do</h2>
          <h3 className="text-4xl font-bold tracking-tight">Full-stack digital solutions.</h3>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {services.map((service, idx) => (
            <motion.div
              key={idx}
              whileHover={{ y: -5 }}
              className="p-8 bg-white rounded-3xl border border-zinc-100 shadow-sm"
            >
              <div className="w-12 h-12 bg-zinc-50 rounded-2xl flex items-center justify-center mb-6 text-black">
                {service.icon}
              </div>
              <h4 className="text-xl font-bold mb-3">{service.title}</h4>
              <p className="text-zinc-600 text-sm leading-relaxed">
                {service.description}
              </p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

const Products = () => {
  const products = [
    {
      icon: <Eye className="w-6 h-6" />,
      title: "Sahin Goz",
      description: "AI-powered drone monitoring system for construction site surveillance with real-time alerts and multi-zone management.",
      tag: "Surveillance",
      link: "/sahingoz/index.html",
    },
    {
      icon: <Eye className="w-6 h-6" />,
      title: "Sahin Goz Aktif",
      description: "AI-powered active construction safety monitoring with real-time hazard detection, worker tracking, and automated compliance alerts.",
      tag: "Safety",
      link: "/sahingozaktif/index.html",
    },
    {
      icon: <img src="/nura/nura-icon.png" alt="Nura" className="w-12 h-12 rounded-2xl object-cover" />,
      title: "Nura",
      description: "AI-powered Islamic spiritual companion app with accurate prayer times, do'a collections, mood tracking, and multilingual support.",
      tag: "Lifestyle",
      link: "/nura",
    },
  ];

  return (
    <section id="products" className="py-24 px-6">
      <div className="max-w-7xl mx-auto">
        <div className="flex items-end justify-between mb-16">
          <div>
            <h2 className="text-sm font-bold uppercase tracking-widest text-emerald-600 mb-4">Our products</h2>
            <h3 className="text-4xl font-bold tracking-tight">Built for the real world.</h3>
          </div>
        </div>
        <div className="grid md:grid-cols-3 gap-8">
          {products.map((product, idx) => (
            <motion.div
              key={idx}
              whileHover={{ y: -5 }}
              className="relative p-8 bg-zinc-900 rounded-3xl border border-zinc-800 text-white overflow-hidden group"
            >
              <div className="absolute top-0 right-0 w-40 h-40 bg-emerald-500/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
              <div className="relative">
                <div className="flex items-center justify-between mb-6">
                  <div className="w-12 h-12 bg-white/5 border border-white/10 rounded-2xl flex items-center justify-center text-emerald-400">
                    {product.icon}
                  </div>
                  <span className="text-xs font-medium text-zinc-500 uppercase tracking-wider">{product.tag}</span>
                </div>
                <h4 className="text-xl font-bold mb-3">{product.title}</h4>
                <p className="text-zinc-400 text-sm leading-relaxed mb-6">
                  {product.description}
                </p>
                {product.link ? (
                  <a href={product.link} className="inline-flex items-center gap-2 text-sm font-medium text-emerald-400 hover:text-emerald-300 transition-colors group/link">
                    View demo
                    <ChevronRight className="w-4 h-4 group-hover/link:translate-x-1 transition-transform" />
                  </a>
                ) : (
                  <span className="inline-flex items-center gap-2 text-sm font-medium text-zinc-600">
                    Coming soon
                  </span>
                )}
              </div>
            </motion.div>
          ))}
        </div>
        <div className="mt-8 flex justify-center md:hidden">
        </div>
      </div>
    </section>
  );
};

const Contact = () => (
  <section id="contact" className="py-24 px-6">
    <div className="max-w-7xl mx-auto">
      <div className="grid lg:grid-cols-2 gap-20">
        <div>
          <h2 className="text-sm font-bold uppercase tracking-widest text-emerald-600 mb-4">Get in touch</h2>
          <h3 className="text-5xl font-bold tracking-tight mb-8">Let's build something major together.</h3>
          <p className="text-xl text-zinc-600 mb-12">
            Ready to start your next project? We're here to help you bring your vision to life.
          </p>

          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 bg-zinc-100 rounded-full flex items-center justify-center shrink-0">
                <Mail className="w-5 h-5" />
              </div>
              <div>
                <h4 className="font-bold mb-1">Email Us</h4>
                <p className="text-zinc-600">admin@majorgrup.tc</p>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-zinc-900 p-10 rounded-[2rem] text-white">
          <form className="space-y-6">
            <div className="grid md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-xs font-bold uppercase tracking-wider text-zinc-400">Name</label>
                <input type="text" className="w-full bg-zinc-800 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-emerald-500 outline-none" placeholder="John Doe" />
              </div>
              <div className="space-y-2">
                <label className="text-xs font-bold uppercase tracking-wider text-zinc-400">Email</label>
                <input type="email" className="w-full bg-zinc-800 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-emerald-500 outline-none" placeholder="john@example.com" />
              </div>
            </div>
            <div className="space-y-2">
              <label className="text-xs font-bold uppercase tracking-wider text-zinc-400">Project Type</label>
              <select className="w-full bg-zinc-800 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-emerald-500 outline-none appearance-none">
                <option>Mobile App</option>
                <option>Web Platform</option>
                <option>UI/UX Design</option>
                <option>Other</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="text-xs font-bold uppercase tracking-wider text-zinc-400">Message</label>
              <textarea rows={4} className="w-full bg-zinc-800 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-emerald-500 outline-none resize-none" placeholder="Tell us about your project..."></textarea>
            </div>
            <button className="w-full py-4 bg-emerald-500 text-black font-bold rounded-xl hover:bg-emerald-400 transition-colors">
              Send Message
            </button>
          </form>
        </div>
      </div>
    </div>
  </section>
);

const Footer = () => (
  <footer className="py-12 px-6 border-t border-zinc-100">
    <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
      <div className="text-xl font-bold tracking-tighter">major<span className="text-black">.</span></div>

      <div className="text-sm text-zinc-400">
        © {new Date().getFullYear()} major. All rights reserved.
      </div>
    </div>
  </footer>
);

function HomePage() {
  return (
    <div className="min-h-screen bg-white font-sans text-black selection:bg-emerald-100 selection:text-emerald-900">
      <Navbar />
      <main>
        <Hero />
        <Services />
        <Products />
        <Contact />
      </main>
      <Footer />
    </div>
  );
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/nura" element={<NuraPage />} />
      {/* sahingoz served as static HTML in public/sahingoz/ */}
    </Routes>
  );
}
