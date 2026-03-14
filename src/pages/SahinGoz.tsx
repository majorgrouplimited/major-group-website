import React, { useState, useEffect } from 'react';
import { motion } from 'motion/react';
import { Link } from 'react-router-dom';
import {
  Battery,
  ArrowUp,
  Gauge,
  Wifi,
  WifiOff,
  Brain,
  Lock,
  Signal,
  AlertTriangle,
  Home,
  Video,
  User,
  ChevronLeft,
  Shield,
  Settings,
  UserCircle,
} from 'lucide-react';

// ═══════════════════════════════════════════════════════════════
//  TYPES & DATA
// ═══════════════════════════════════════════════════════════════

type ZoneAlertLevel = 'normal' | 'warning' | 'critical';

interface Zone {
  id: number;
  name: string;
  shortName: string;
  lat: number;
  lng: number;
  alertLevel: ZoneAlertLevel;
  alertMessage: string | null;
  workerCount: number;
}

interface Telemetry {
  altitude: number;
  speed: number;
  battery: number;
  lat: number;
  lng: number;
  heading: number;
  signal: number;
}

const defaultZones: Zone[] = [
  { id: 1, name: 'Temel Kazi', shortName: 'B1', lat: 41.0082, lng: 28.9784, alertLevel: 'normal', alertMessage: null, workerCount: 4 },
  { id: 2, name: 'Ana Giris', shortName: 'B2', lat: 41.0085, lng: 28.9788, alertLevel: 'normal', alertMessage: null, workerCount: 2 },
  { id: 3, name: 'KB Kule', shortName: 'B3', lat: 41.0079, lng: 28.978, alertLevel: 'normal', alertMessage: null, workerCount: 7 },
  { id: 4, name: 'Iskele', shortName: 'B4', lat: 41.0076, lng: 28.9778, alertLevel: 'warning', alertMessage: 'Baret Yok - 2 isci', workerCount: 5 },
  { id: 5, name: 'Dogu Sektoru', shortName: 'B5', lat: 41.0088, lng: 28.9792, alertLevel: 'normal', alertMessage: null, workerCount: 3 },
  { id: 6, name: 'Vinc Merkezi', shortName: 'B6', lat: 41.0072, lng: 28.9774, alertLevel: 'normal', alertMessage: null, workerCount: 6 },
  { id: 7, name: 'Depo', shortName: 'B7', lat: 41.0093, lng: 28.9796, alertLevel: 'critical', alertMessage: 'Yetkisiz Erisim', workerCount: 1 },
  { id: 8, name: 'Cevre', shortName: 'B8', lat: 41.0068, lng: 28.977, alertLevel: 'normal', alertMessage: null, workerCount: 0 },
];

const C = {
  bg0: '#060A0D', bg1: '#0A1018', bg2: '#0E161F', bg3: '#131E2A', bg4: '#1A2535',
  cyan: '#00BFFF', green: '#00FF9D', amber: '#FFB400', red: '#FF3355', orange: '#FF6B35',
  text1: '#E0F0FF', text2: '#B0C8E6', text3: '#647896', text4: '#46738C',
  border1: 'rgba(0,180,255,0.10)', border2: 'rgba(0,180,255,0.22)',
} as const;

// ═══════════════════════════════════════════════════════════════
//  DEMO PAGE — iPhone frame with app inside
// ═══════════════════════════════════════════════════════════════

export default function SahinGozDemo() {
  const [activeZoneId, setActiveZoneId] = useState(3);
  const [activeTab, setActiveTab] = useState(0);
  const [zones] = useState<Zone[]>(defaultZones);
  const [telemetry, setTelemetry] = useState<Telemetry>({
    altitude: 45.2, speed: 12.5, battery: 78,
    lat: 41.0079, lng: 28.978, heading: 270, signal: 87,
  });
  const [time, setTime] = useState(() => formatTime());

  useEffect(() => {
    const interval = setInterval(() => {
      setTelemetry((prev) => ({
        altitude: Math.max(10, prev.altitude + (Math.random() - 0.5) * 2),
        speed: Math.max(0, 8 + Math.random() * 5),
        battery: Math.max(5, prev.battery - (Math.random() > 0.8 ? 1 : 0)),
        lat: prev.lat + (Math.random() - 0.5) * 0.00002,
        lng: prev.lng + (Math.random() - 0.5) * 0.00002,
        heading: (prev.heading + 2) % 360,
        signal: Math.min(100, Math.max(60, 85 + Math.floor(Math.random() * 10))),
      }));
    }, 2000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const interval = setInterval(() => setTime(formatTime()), 10000);
    return () => clearInterval(interval);
  }, []);

  const activeZone = zones.find((z) => z.id === activeZoneId) || zones[0];
  const alertCount = zones.filter((z) => z.alertLevel !== 'normal').length;

  return (
    <div style={{
      height: '100vh',
      background: '#0a0a0a',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: "'Inter', sans-serif",
      position: 'relative',
      overflow: 'hidden',
    }}>
      {/* Fonts */}
      <link href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Share+Tech+Mono&family=Barlow:wght@300;400;500;600;700&family=Barlow+Condensed:wght@400;500;600;700&display=swap" rel="stylesheet" />

      <style>{`
        @keyframes pulse{0%,100%{transform:scale(1);opacity:.8}50%{transform:scale(1.8);opacity:0}}
        @keyframes flash{0%,100%{opacity:1}50%{opacity:.15}}
        @keyframes rec-blink{0%,100%{opacity:1}50%{opacity:.15}}
        @keyframes drift{0%{background-position:0 0}50%{background-position:3px -2px}100%{background-position:0 0}}
        .font-rajdhani{font-family:'Rajdhani',sans-serif}
        .font-mono{font-family:'Share Tech Mono',monospace}
        .font-condensed{font-family:'Barlow Condensed',sans-serif}
        .phone-screen::-webkit-scrollbar{display:none}
        .phone-screen{-ms-overflow-style:none;scrollbar-width:none}
        .iphone-frame{
          width:375px;height:812px;
          scale: min(calc(92vh / 812), 1);
        }
      `}</style>

      {/* Back to main site */}
      <Link to="/" style={{
        position: 'fixed', top: 24, left: 24, zIndex: 200,
        display: 'flex', alignItems: 'center', gap: 6,
        padding: '8px 16px 8px 10px',
        background: 'rgba(255,255,255,0.06)',
        border: '1px solid rgba(255,255,255,0.10)',
        borderRadius: 10,
        color: '#fff', textDecoration: 'none',
        fontSize: 14, fontWeight: 500,
        backdropFilter: 'blur(12px)',
        transition: 'background 200ms',
      }}
        onMouseEnter={(e) => (e.currentTarget.style.background = 'rgba(255,255,255,0.12)')}
        onMouseLeave={(e) => (e.currentTarget.style.background = 'rgba(255,255,255,0.06)')}
      >
        <ChevronLeft size={16} />
        major.
      </Link>

      {/* Left side — title */}
      <motion.div
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.6 }}
        style={{ position: 'absolute', left: 60, textAlign: 'left' }}
      >
        <h1 className="font-rajdhani" style={{
          fontSize: 42, fontWeight: 700, color: C.cyan,
          letterSpacing: 4, margin: 0, lineHeight: 1,
        }}>
          SAHIN GOZ
        </h1>
        <p style={{ fontSize: 14, color: 'rgba(255,255,255,0.35)', letterSpacing: 1.5, marginTop: 10 }}>
          Drone Monitoring System
        </p>
        <p style={{ fontSize: 12, color: 'rgba(255,255,255,0.2)', letterSpacing: 0.5, marginTop: 4 }}>
          Construction Site AI Surveillance
        </p>
        <div style={{ marginTop: 20, width: 40, height: 2, background: C.cyan, opacity: 0.3, borderRadius: 1 }} />
        <p style={{ fontSize: 11, color: 'rgba(255,255,255,0.15)', marginTop: 14, letterSpacing: 0.5 }}>
          Built by major.
        </p>
      </motion.div>

      {/* iPhone Frame — scales to fit viewport */}
      <motion.div
        className="iphone-frame"
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.5, delay: 0.15 }}
        style={{
          borderRadius: 50,
          background: '#1c1c1e',
          padding: 10,
          boxShadow: `
            0 0 0 1px rgba(255,255,255,0.08),
            0 30px 100px rgba(0,0,0,0.7),
            0 0 60px rgba(0,191,255,0.04),
            inset 0 1px 0 rgba(255,255,255,0.06)
          `,
          position: 'relative',
          flexShrink: 0,
        }}
      >
        {/* Dynamic Island */}
        <div style={{
          position: 'absolute', top: 10, left: '50%', transform: 'translateX(-50%)',
          width: 120, height: 32,
          background: '#000', borderRadius: 20, zIndex: 50,
        }}>
          <div style={{
            position: 'absolute', top: 10, right: 20,
            width: 10, height: 10, borderRadius: '50%',
            background: 'radial-gradient(circle, #1a1a2e 30%, #0a0a0a 70%)',
            border: '1px solid #2a2a3e',
          }} />
        </div>

        {/* Screen */}
        <div className="phone-screen" style={{
          width: '100%', height: '100%',
          borderRadius: 40, overflow: 'hidden',
          background: C.bg0,
          display: 'flex', flexDirection: 'column',
          color: C.text1,
        }}>
          {/* Safe area top */}
          <div style={{ height: 50, background: C.bg0 }} />

          {/* App Content */}
          <StatusBar time={time} />

          {activeTab === 0 ? (
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
              <div style={{ flex: '38 1 0', padding: '4px 10px 0', minHeight: 0 }}>
                <VideoPlayer zone={activeZone} telemetry={telemetry} />
              </div>
              <TelemetryBar telemetry={telemetry} />
              <ControlBar battery={telemetry.battery} />
              <SystemStatusBar signal={telemetry.signal} alertCount={alertCount} />
              <div style={{ flex: '44 1 0', margin: '4px 10px 0', minHeight: 0 }}>
                <ZoneGrid zones={zones} activeZoneId={activeZoneId} onSelectZone={setActiveZoneId} />
              </div>
            </div>
          ) : (
            <PlaceholderTab label={activeTab === 1 ? 'Guvenlik Kayitlari' : activeTab === 2 ? 'Ayarlar' : 'Profil'} />
          )}

          {/* Bottom Navigation */}
          <BottomNav alertCount={alertCount} activeTab={activeTab} onTabChange={setActiveTab} />

          {/* Home indicator */}
          <div style={{ display: 'flex', justifyContent: 'center', padding: '4px 0 6px', background: C.bg1 }}>
            <div style={{ width: 120, height: 4, borderRadius: 2, background: 'rgba(255,255,255,0.15)' }} />
          </div>
        </div>
      </motion.div>
    </div>
  );
}

function formatTime() {
  const n = new Date();
  return `${String(n.getHours()).padStart(2, '0')}:${String(n.getMinutes()).padStart(2, '0')}`;
}

// ═══════════════════════════════════════════════════════════════
//  BOTTOM NAVIGATION (4 tabs: CANLI, GUVENLIK, AYARLAR, PROFIL)
// ═══════════════════════════════════════════════════════════════

function PlaceholderTab({ label }: { label: string }) {
  return (
    <div style={{
      flex: 1, display: 'flex', flexDirection: 'column',
      alignItems: 'center', justifyContent: 'center', gap: 10,
    }}>
      <Settings size={28} color={C.text4} />
      <span className="font-rajdhani" style={{ fontSize: 16, color: C.text3, letterSpacing: 1 }}>{label}</span>
      <span className="font-mono" style={{ fontSize: 8, color: C.text4 }}>Yakin zamanda eklenecek</span>
    </div>
  );
}

function BottomNav({ alertCount, activeTab, onTabChange }: { alertCount: number; activeTab: number; onTabChange: (i: number) => void }) {
  const tabs = [
    { icon: <Video size={18} />, activeIcon: <Video size={18} strokeWidth={2.5} />, label: 'CANLI' },
    { icon: <Shield size={18} />, activeIcon: <Shield size={18} strokeWidth={2.5} />, label: 'GUVENLIK', badge: alertCount > 0 },
    { icon: <Settings size={18} />, activeIcon: <Settings size={18} strokeWidth={2.5} />, label: 'AYARLAR' },
    { icon: <UserCircle size={18} />, activeIcon: <UserCircle size={18} strokeWidth={2.5} />, label: 'PROFIL' },
  ];

  return (
    <div style={{
      background: C.bg1,
      borderTop: `1px solid ${C.border2}`,
      display: 'flex',
      padding: '6px 0 2px',
    }}>
      {tabs.map((tab, i) => (
        <div
          key={tab.label}
          onClick={() => onTabChange(i)}
          style={{
            flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            cursor: 'pointer', padding: '4px 0',
            color: i === activeTab ? C.cyan : C.text3,
            transition: 'color 200ms',
          }}
        >
          <div style={{ position: 'relative' }}>
            {i === activeTab ? tab.activeIcon : tab.icon}
            {tab.badge && (
              <div style={{
                position: 'absolute', top: -2, right: -4,
                width: 8, height: 8, borderRadius: '50%',
                background: C.red, border: `1.5px solid ${C.bg1}`,
              }} />
            )}
          </div>
          <span className="font-mono" style={{ fontSize: 7, letterSpacing: 0.3 }}>{tab.label}</span>
        </div>
      ))}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
//  STATUS BAR
// ═══════════════════════════════════════════════════════════════

function StatusBar({ time }: { time: string }) {
  return (
    <div style={{
      padding: '4px 10px 6px',
      background: 'linear-gradient(to bottom, rgba(6,10,13,0.97), transparent)',
      display: 'flex', alignItems: 'center', gap: 8,
    }}>
      <svg width="24" height="24" viewBox="0 0 28 28">
        <defs>
          <linearGradient id="hexGrad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor={C.cyan} />
            <stop offset="100%" stopColor="rgba(0,191,255,0.3)" />
          </linearGradient>
        </defs>
        <polygon points="14,1 25.5,7.5 25.5,20.5 14,27 2.5,20.5 2.5,7.5" fill="url(#hexGrad)" style={{ filter: `drop-shadow(0 0 6px ${C.cyan})` }} />
      </svg>
      <Video size={10} color={C.cyan} style={{ marginLeft: -20, marginTop: 1 }} />
      <div style={{ marginLeft: 4 }}>
        <div className="font-rajdhani" style={{ fontSize: 14, fontWeight: 700, color: C.cyan, letterSpacing: 2.5, lineHeight: 1 }}>SAHIN GOZ</div>
        <div className="font-mono" style={{ fontSize: 6, color: C.text3, letterSpacing: 2, lineHeight: 1.2 }}>DRONE IZLEME</div>
      </div>
      <div style={{ flex: 1 }} />
      <div style={{ padding: '2px 5px', background: 'rgba(0,255,157,0.08)', border: '1px solid rgba(0,255,157,0.25)', borderRadius: 3 }}>
        <span className="font-mono" style={{ fontSize: 7, color: C.green }}>GPS · AKTIF</span>
      </div>
      <div style={{ display: 'flex', alignItems: 'flex-end', gap: 2 }}>
        {[0,1,2,3].map((i) => (
          <div key={i} style={{ width: 3, height: 5 + i * 2.5, background: C.cyan, borderRadius: 1, boxShadow: `0 0 4px ${C.cyan}` }} />
        ))}
      </div>
      <span className="font-mono" style={{ fontSize: 10, color: C.text2 }}>{time}</span>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
//  VIDEO PLAYER — simulated drone feed
// ═══════════════════════════════════════════════════════════════

function VideoPlayer({ zone, telemetry }: { zone: Zone; telemetry: Telemetry }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Animated noise + construction site simulation
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    canvas.width = 355;
    canvas.height = 200;
    let frame = 0;
    let animId: number;

    const draw = () => {
      const w = canvas.width, h = canvas.height;
      frame++;

      // Dark base with slight green/blue tint (night vision feel)
      ctx.fillStyle = '#0a1218';
      ctx.fillRect(0, 0, w, h);

      // Ground plane (brownish construction site)
      const groundY = h * 0.55;
      const grd = ctx.createLinearGradient(0, groundY, 0, h);
      grd.addColorStop(0, '#141e14');
      grd.addColorStop(1, '#0e160e');
      ctx.fillStyle = grd;
      ctx.fillRect(0, groundY, w, h - groundY);

      // Sky gradient
      const sky = ctx.createLinearGradient(0, 0, 0, groundY);
      sky.addColorStop(0, '#0a1520');
      sky.addColorStop(1, '#101a22');
      ctx.fillStyle = sky;
      ctx.fillRect(0, 0, w, groundY);

      // Buildings / structures
      const buildings = [
        { x: 40, w: 50, h: 90 },
        { x: 110, w: 35, h: 60 },
        { x: 160, w: 65, h: 110 },
        { x: 245, w: 45, h: 75 },
        { x: 300, w: 40, h: 55 },
      ];
      buildings.forEach(b => {
        const bx = b.x + Math.sin(frame * 0.003 + b.x) * 0.3; // slight drift
        ctx.fillStyle = '#151f1a';
        ctx.fillRect(bx, groundY - b.h, b.w, b.h);
        ctx.strokeStyle = 'rgba(0,255,157,0.08)';
        ctx.lineWidth = 0.5;
        ctx.strokeRect(bx, groundY - b.h, b.w, b.h);
        // Windows
        for (let wy = groundY - b.h + 8; wy < groundY - 4; wy += 12) {
          for (let wx = bx + 5; wx < bx + b.w - 5; wx += 10) {
            const lit = Math.sin(frame * 0.01 + wx + wy) > 0.3;
            ctx.fillStyle = lit ? 'rgba(255,180,50,0.15)' : 'rgba(0,191,255,0.03)';
            ctx.fillRect(wx, wy, 5, 6);
          }
        }
      });

      // Crane
      ctx.strokeStyle = 'rgba(255,107,53,0.25)';
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(180, groundY);
      ctx.lineTo(180, groundY - 140);
      ctx.lineTo(280, groundY - 140);
      ctx.stroke();
      // Crane cable
      const cableX = 230 + Math.sin(frame * 0.02) * 5;
      ctx.strokeStyle = 'rgba(255,107,53,0.15)';
      ctx.lineWidth = 0.5;
      ctx.beginPath();
      ctx.moveTo(cableX, groundY - 140);
      ctx.lineTo(cableX, groundY - 80);
      ctx.stroke();

      // Moving dots (workers / vehicles on ground)
      for (let i = 0; i < 5; i++) {
        const wx = ((frame * 0.3 + i * 70) % (w + 20)) - 10;
        const wy = groundY + 10 + i * 8;
        ctx.fillStyle = i < 2 ? 'rgba(255,180,0,0.4)' : 'rgba(0,255,157,0.3)';
        ctx.beginPath();
        ctx.arc(wx, wy, 1.5, 0, Math.PI * 2);
        ctx.fill();
      }

      // Noise overlay
      const imageData = ctx.getImageData(0, 0, w, h);
      const data = imageData.data;
      for (let i = 0; i < data.length; i += 16) {
        const noise = (Math.random() - 0.5) * 12;
        data[i] += noise;
        data[i + 1] += noise;
        data[i + 2] += noise;
      }
      ctx.putImageData(imageData, 0, 0);

      // Slight vignette
      const vig = ctx.createRadialGradient(w/2, h/2, w*0.3, w/2, h/2, w*0.7);
      vig.addColorStop(0, 'transparent');
      vig.addColorStop(1, 'rgba(0,0,0,0.4)');
      ctx.fillStyle = vig;
      ctx.fillRect(0, 0, w, h);

      animId = requestAnimationFrame(draw);
    };
    draw();
    return () => cancelAnimationFrame(animId);
  }, []);

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', borderRadius: 10, overflow: 'hidden', background: C.bg0 }}>
      {/* Canvas drone feed */}
      <canvas ref={canvasRef} style={{ width: '100%', height: '100%', display: 'block', objectFit: 'cover' }} />

      {/* CRT scanlines */}
      <div style={{ position: 'absolute', inset: 0, background: 'repeating-linear-gradient(to bottom, transparent 0px, transparent 2px, rgba(0,0,0,0.04) 2px, rgba(0,0,0,0.04) 4px)', pointerEvents: 'none' }} />

      {/* Corner brackets */}
      <CornerBrackets />

      {/* Top HUD */}
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, padding: '6px 8px', background: 'linear-gradient(to bottom, rgba(6,10,13,0.87), transparent)', display: 'flex', alignItems: 'center' }}>
        <div style={{ padding: '2px 5px', background: 'rgba(255,51,85,0.15)', border: '1px solid rgba(255,51,85,0.5)', borderRadius: 3, display: 'flex', alignItems: 'center', gap: 4 }}>
          <div style={{ width: 5, height: 5, borderRadius: '50%', background: C.red, boxShadow: `0 0 6px ${C.red}`, animation: 'rec-blink 900ms ease-in-out infinite' }} />
          <span className="font-mono" style={{ fontSize: 7, color: C.red, letterSpacing: 2 }}>CANLI</span>
        </div>
        <span className="font-rajdhani" style={{ marginLeft: 6, fontSize: 9, fontWeight: 600, color: C.cyan, letterSpacing: 1.5 }}>
          {zone.shortName} · {zone.name}
        </span>
        <div style={{ flex: 1 }} />
        <div style={{ textAlign: 'right' }}>
          <div className="font-mono" style={{ fontSize: 7, color: C.green }}>{telemetry.lat.toFixed(4)}°K</div>
          <div className="font-mono" style={{ fontSize: 7, color: C.green }}>{telemetry.lng.toFixed(4)}°D</div>
        </div>
      </div>

      {/* Bottom HUD */}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '5px 8px', background: 'linear-gradient(to top, rgba(6,10,13,0.93), transparent)', display: 'flex', alignItems: 'center' }}>
        {zone.alertMessage && (
          <div style={{ padding: '2px 5px', background: zone.alertLevel === 'critical' ? 'rgba(255,51,85,0.2)' : 'rgba(255,180,0,0.15)', border: `0.8px solid ${zone.alertLevel === 'critical' ? C.red : C.amber}`, borderRadius: 3, animation: 'flash 1.2s ease-in-out infinite' }}>
            <span className="font-mono" style={{ fontSize: 6, color: zone.alertLevel === 'critical' ? C.red : C.amber }}>
              {zone.alertLevel === 'critical' ? '!!' : '!'} {zone.alertMessage}
            </span>
          </div>
        )}
        <div style={{ flex: 1 }} />
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <div style={{ width: 5, height: 5, borderRadius: '50%', background: C.green, boxShadow: `0 0 6px ${C.green}` }} />
          <span className="font-mono" style={{ fontSize: 6, color: C.green, letterSpacing: 1.5 }}>BAGLI</span>
        </div>
      </div>
    </div>
  );
}

function CornerBrackets() {
  const color = 'rgba(0,191,255,0.55)';
  const s = (extra: React.CSSProperties): React.CSSProperties => ({ position: 'absolute', width: 14, height: 14, pointerEvents: 'none', ...extra });
  return <>
    <div style={s({ top: 6, left: 6, borderTop: `1.8px solid ${color}`, borderLeft: `1.8px solid ${color}` })} />
    <div style={s({ top: 6, right: 6, borderTop: `1.8px solid ${color}`, borderRight: `1.8px solid ${color}` })} />
    <div style={s({ bottom: 6, left: 6, borderBottom: `1.8px solid ${color}`, borderLeft: `1.8px solid ${color}` })} />
    <div style={s({ bottom: 6, right: 6, borderBottom: `1.8px solid ${color}`, borderRight: `1.8px solid ${color}` })} />
  </>;
}

// ═══════════════════════════════════════════════════════════════
//  TELEMETRY BAR
// ═══════════════════════════════════════════════════════════════

function TelemetryBar({ telemetry }: { telemetry: Telemetry }) {
  const batteryColor = telemetry.battery > 50 ? C.green : telemetry.battery > 20 ? C.amber : C.red;
  const signalColor = telemetry.signal >= 80 ? C.green : telemetry.signal >= 40 ? C.amber : C.red;

  const cells = [
    { label: 'PIL', icon: <Battery size={8} color={batteryColor} />, value: `${telemetry.battery}%`, color: batteryColor,
      suffix: <div style={{ width: 18, height: 6, border: `1px solid ${batteryColor}60`, borderRadius: 1.5, overflow: 'hidden' }}><div style={{ width: `${telemetry.battery}%`, height: '100%', background: batteryColor, transition: 'width 600ms' }} /></div> },
    { label: 'IRTIFA', icon: <ArrowUp size={8} color={C.cyan} />, value: `${telemetry.altitude.toFixed(1)}m`, color: C.text1 },
    { label: 'HIZ', icon: <Gauge size={8} color={C.cyan} />, value: `${telemetry.speed.toFixed(1)}km/s`, color: C.text1 },
    { label: 'SINYAL', icon: <Signal size={8} color={signalColor} />, value: `${telemetry.signal}%`, color: signalColor,
      suffix: <div style={{ display: 'flex', alignItems: 'flex-end', gap: 1 }}>{[0,1,2,3].map(i => <div key={i} style={{ width: 2.5, height: 3 + i * 2.5, background: i < Math.ceil(telemetry.signal/25) ? signalColor : C.border2, borderRadius: 1 }} />)}</div> },
    { label: 'DURUM', icon: <Wifi size={8} color={C.green} />, value: 'BAGLI', color: C.green },
  ];

  return (
    <div style={{ padding: '6px 10px', background: C.bg1, borderTop: `1px solid ${C.border2}`, borderBottom: `1px solid ${C.border1}`, display: 'flex', alignItems: 'center' }}>
      {cells.map((cell, i) => (
        <React.Fragment key={cell.label}>
          {i > 0 && <div style={{ width: 1, height: 22, background: C.border1, margin: '0 3px' }} />}
          <div style={{ flex: 1, textAlign: 'center' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 2, marginBottom: 2 }}>
              {cell.icon}
              <span className="font-mono" style={{ fontSize: 6, color: C.text3, letterSpacing: 1.5 }}>{cell.label}</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'center', gap: 3 }}>
              <span className="font-mono" style={{ fontSize: 9, color: cell.color, letterSpacing: 0.5 }}>{cell.value}</span>
              {cell.suffix}
            </div>
          </div>
        </React.Fragment>
      ))}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
//  CONTROL BAR
// ═══════════════════════════════════════════════════════════════

function ControlBar({ battery }: { battery: number }) {
  const color = battery > 50 ? C.green : battery > 20 ? C.amber : C.red;
  return (
    <div style={{ padding: '3px 10px', background: C.bg0, display: 'flex', alignItems: 'center' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 3 }}>
        <Battery size={12} color={color} />
        <span className="font-mono" style={{ fontSize: 8, color }}>{battery}%</span>
      </div>
      <div style={{ flex: 1 }} />
      <div style={{
        width: 38, height: 38, borderRadius: '50%',
        background: 'rgba(255,107,53,0.10)', border: `1.5px solid ${C.orange}`,
        boxShadow: '0 0 18px rgba(255,107,53,0.30)',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
      }}>
        <Home size={13} color={C.orange} />
        <span className="font-mono" style={{ fontSize: 5, color: C.orange, letterSpacing: 1 }}>EVE</span>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
//  SYSTEM STATUS BAR
// ═══════════════════════════════════════════════════════════════

function SystemStatusBar({ signal, alertCount }: { signal: number; alertCount: number }) {
  const signalColor = signal >= 70 ? C.green : signal >= 40 ? C.amber : C.red;
  return (
    <div style={{ padding: '3px 10px', background: C.bg1, borderTop: `1px solid ${C.border1}`, borderBottom: `1px solid ${C.border1}`, display: 'flex', alignItems: 'center', gap: 6 }}>
      <StatusChip icon={<Brain size={8} color={C.text4} />} label="YZ" value="AKTIF" valueColor={C.green} />
      <StatusChip icon={<Lock size={8} color={C.text4} />} label="SIFRE" value="AES-256" valueColor={C.cyan} />
      <StatusChip icon={<Signal size={8} color={C.text4} />} label="SINYAL" value={`${signal}%`} valueColor={signalColor} />
      <div style={{ flex: 1 }} />
      {alertCount > 0 ? (
        <div style={{ padding: '2px 6px', background: 'rgba(255,51,85,0.12)', border: '0.8px solid rgba(255,51,85,0.45)', borderRadius: 3, display: 'flex', alignItems: 'center', gap: 3 }}>
          <AlertTriangle size={8} color={C.red} />
          <span className="font-mono" style={{ fontSize: 6, color: C.red }}>{alertCount} UYARI</span>
        </div>
      ) : (
        <div style={{ padding: '2px 6px', background: 'rgba(0,255,157,0.06)', border: '0.8px solid rgba(0,255,157,0.25)', borderRadius: 3 }}>
          <span className="font-mono" style={{ fontSize: 6, color: C.green }}>UYARI YOK</span>
        </div>
      )}
    </div>
  );
}

function StatusChip({ icon, label, value, valueColor }: { icon: React.ReactNode; label: string; value: string; valueColor: string }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 2 }}>
      {icon}
      <span className="font-mono" style={{ fontSize: 6, color: C.text4 }}>{label}: </span>
      <span className="font-mono" style={{ fontSize: 6, color: valueColor }}>{value}</span>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
//  ZONE GRID
// ═══════════════════════════════════════════════════════════════

function ZoneGrid({ zones, activeZoneId, onSelectZone }: { zones: Zone[]; activeZoneId: number; onSelectZone: (id: number) => void }) {
  const criticalCount = zones.filter((z) => z.alertLevel === 'critical').length;
  const warningCount = zones.filter((z) => z.alertLevel === 'warning').length;

  return (
    <div style={{ height: '100%', background: C.bg1, borderRadius: 10, border: `1px solid ${C.border1}`, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <div style={{ padding: '6px 8px 5px', display: 'flex', alignItems: 'center' }}>
        <span className="font-condensed" style={{ fontSize: 8, color: C.text3, letterSpacing: 2 }}>BOLGELER</span>
        <span className="font-mono" style={{ fontSize: 6, color: C.text4, marginLeft: 5 }}>{zones.length} NOKTA</span>
        <div style={{ flex: 1 }} />
        {criticalCount > 0 && <AlertBadge count={criticalCount} color={C.red} label="KRITIK" />}
        {warningCount > 0 && <AlertBadge count={warningCount} color={C.amber} label="UYARI" />}
        <div style={{ marginLeft: 4, padding: '2px 5px', background: 'rgba(0,255,157,0.08)', border: '0.8px solid rgba(0,255,157,0.3)', borderRadius: 3, display: 'flex', alignItems: 'center', gap: 3 }}>
          <div style={{ width: 4, height: 4, borderRadius: '50%', background: C.green }} />
          <span className="font-mono" style={{ fontSize: 6, color: C.green, letterSpacing: 1 }}>CANLI</span>
        </div>
      </div>
      <div style={{ height: 1, background: C.border1 }} />
      <div style={{ flex: 1, display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gridTemplateRows: 'repeat(2, 1fr)', gap: 4, padding: '5px 6px 6px', minHeight: 0 }}>
        {zones.map((zone) => (
          <ZoneCard key={zone.id} zone={zone} isActive={zone.id === activeZoneId} onClick={() => onSelectZone(zone.id)} />
        ))}
      </div>
    </div>
  );
}

function AlertBadge({ count, color, label }: { count: number; color: string; label: string }) {
  return (
    <div style={{ padding: '2px 4px', background: `${color}1F`, border: `0.8px solid ${color}73`, borderRadius: 3, marginLeft: 4 }}>
      <span className="font-mono" style={{ fontSize: 6, color, letterSpacing: 0.5 }}>{count} {label}</span>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
//  ZONE CARD
// ═══════════════════════════════════════════════════════════════

function ZoneCard({ zone, isActive, onClick }: { zone: Zone; isActive: boolean; onClick: () => void }) {
  const borderColor = isActive ? C.orange : zone.alertLevel === 'critical' ? C.red : zone.alertLevel === 'warning' ? C.amber : C.border2;
  const bgColor = isActive ? 'rgba(255,107,53,0.07)' : zone.alertLevel === 'critical' ? 'rgba(255,51,85,0.05)' : zone.alertLevel === 'warning' ? 'rgba(255,180,0,0.04)' : C.bg2;
  const indicatorColor = isActive ? C.orange : zone.alertLevel === 'critical' ? C.red : zone.alertLevel === 'warning' ? C.amber : C.green;
  const glowShadow = isActive ? '0 0 18px rgba(255,107,53,0.30)' : zone.alertLevel === 'critical' ? '0 0 14px rgba(255,51,85,0.30)' : zone.alertLevel === 'warning' ? '0 0 14px rgba(255,180,0,0.30)' : 'none';

  return (
    <div onClick={onClick} style={{
      position: 'relative', background: bgColor, borderRadius: 6,
      border: `${isActive ? 1.8 : 1}px solid ${borderColor}`,
      boxShadow: glowShadow, cursor: 'pointer', transition: 'all 220ms ease-out',
      display: 'flex', flexDirection: 'column', padding: '4px 4px 3px', overflow: 'hidden', minHeight: 0,
    }}>
      {/* Grid texture */}
      <div style={{ position: 'absolute', inset: 0, backgroundImage: `linear-gradient(${C.border1} 0.5px, transparent 0.5px), linear-gradient(90deg, ${C.border1} 0.5px, transparent 0.5px)`, backgroundSize: '10px 10px', pointerEvents: 'none' }} />

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', position: 'relative', zIndex: 1 }}>
        <span className="font-rajdhani" style={{ fontSize: 12, fontWeight: 700, color: isActive ? C.orange : C.text1, letterSpacing: 0.5, lineHeight: 1 }}>{zone.shortName}</span>
        <div style={{ position: 'relative', width: 12, height: 12, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          {(isActive || zone.alertLevel !== 'normal') && (
            <div style={{ position: 'absolute', width: isActive ? 8 : 10, height: isActive ? 8 : 10, borderRadius: '50%', background: `${indicatorColor}40`, animation: isActive ? 'pulse 1.6s ease-out infinite' : 'flash 1.2s ease-in-out infinite' }} />
          )}
          <div style={{ width: 4, height: 4, borderRadius: '50%', background: indicatorColor, boxShadow: `0 0 4px ${indicatorColor}80`, position: 'relative' }} />
        </div>
      </div>
      <div style={{ flex: 1 }} />
      <div style={{ position: 'relative', zIndex: 1 }}>
        <div className="font-condensed" style={{ fontSize: 7, color: isActive ? C.text1 : C.text2, letterSpacing: 0.3, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{zone.name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 2 }}>
          <User size={6} color={C.text4} />
          <span className="font-mono" style={{ fontSize: 6, color: C.text3 }}>{zone.workerCount}</span>
        </div>
      </div>

      {isActive && (
        <div style={{ position: 'absolute', top: 3, right: 3, padding: '1px 3px', background: 'rgba(255,51,85,0.85)', borderRadius: 2, zIndex: 2 }}>
          <span className="font-mono" style={{ fontSize: 4.5, color: '#fff', letterSpacing: 1 }}>CANLI</span>
        </div>
      )}

      {zone.alertMessage && (
        <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '2px 3px', background: zone.alertLevel === 'critical' ? 'rgba(255,51,85,0.18)' : 'rgba(255,180,0,0.18)', borderRadius: '0 0 6px 6px', textAlign: 'center', animation: isActive ? 'none' : 'flash 1.2s ease-in-out infinite', zIndex: 2 }}>
          <span className="font-mono" style={{ fontSize: 5, color: zone.alertLevel === 'critical' ? C.red : C.amber }}>{zone.alertMessage}</span>
        </div>
      )}
    </div>
  );
}
