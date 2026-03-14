╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ███████╗ █████╗ ██╗  ██╗██╗███╗  ██╗     ██████╗  ██████╗ ███████╗      ║
║    ██╔════╝██╔══██╗██║  ██║██║████╗ ██║    ██╔════╝ ██╔═══██╗╚════██║      ║
║    ███████╗███████║███████║██║██╔██╗██║    ██║  ███╗██║   ██║    ██╔╝      ║
║    ╚════██║██╔══██║██╔══██║██║██║╚████║    ██║   ██║██║   ██║   ██╔╝       ║
║    ███████║██║  ██║██║  ██║██║██║ ╚███║    ╚██████╔╝╚██████╔╝  ██║         ║
║    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚══╝    ╚═════╝  ╚═════╝   ╚═╝         ║
║                                                                              ║
║              DRONE İZLEME SİSTEMİ  ·  Flutter Mobil Uygulaması             ║
║                    iOS & Android  ·  Türkçe  ·  v1.0.0                     ║
╚══════════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
İÇİNDEKİLER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1.  Proje Özeti
  2.  Mimari Genel Bakış
  3.  Klasör Hiyerarşisi
  4.  Dosya ve Sınıf Rehberi
  5.  Bağımlılıklar (Kütüphane Dokümantasyonu)
  6.  Kurulum ve İlk Çalıştırma
  7.  RTSP / Drone Stream Entegrasyonu
  8.  Gerçek YZ Backend Entegrasyonu
  9.  APK ve IPA Build Talimatları
  10. Platform Özel Ayarlar (iOS & Android)
  11. Simülasyon Modu
  12. Geliştirici Notları


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. PROJE ÖZETİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Şahin Göz, endüstriyel inşaat sahalarını drone kamerasıyla uzaktan izlemek
ve YZ tabanlı iş güvenliği analizi yapmak için geliştirilmiş profesyonel
bir Flutter mobil uygulamasıdır.

Temel Özellikler:
  ◆ Drone'dan RTSP/HLS canlı video akışı (flutter_vlc_player)
  ◆ 8 bölge izleme noktası — tek dokunuşla drone yönlendirme
  ◆ WebSocket üzerinden anlık telemetri (irtifa, hız, pil, GPS)
  ◆ YZ güvenlik uyarıları: Baret Yok, Yetkisiz Erişim, Hareketsizlik
  ◆ HUD overlay: GPS koordinatları, kayıt göstergesi, bağlantı durumu
  ◆ Sistem durumu paneli: YZ modeli, AES-256 şifreleme, sinyal kalitesi
  ◆ Eve Dön komutu (RTH) tek buton
  ◆ WakeLock: aktif izleme sırasında ekran açık kalır
  ◆ Tam Türkçe arayüz

Platform Desteği:
  iOS 15+     — iPhone 17 Pro Max optimize (Dynamic Island uyumlu)
  Android 7+  — API Level 24+


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2. MİMARİ GENEL BAKIŞ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ┌─────────────────────────────────────────────────────────────┐
  │                     Flutter UI Katmanı                      │
  │  screens/          widgets/          theme/                 │
  │  SplashScreen      DroneVideoPlayer  AppColors              │
  │  MainShellScreen   TelemetryBar      AppTextStyles          │
  │  DashboardScreen   ZoneGrid          AppShadows             │
  │                    ZoneCard          AppTheme               │
  └───────────────────────┬─────────────────────────────────────┘
                          │ ref.watch() / ref.read()
  ┌───────────────────────▼─────────────────────────────────────┐
  │               State Yönetimi (Riverpod)                     │
  │  providers/drone_provider.dart                              │
  │  DroneNotifier (AsyncNotifier<DroneState>)                  │
  │  + 7 granüler selector Provider                             │
  └──────────┬────────────────────────┬────────────────────────┘
             │                        │
  ┌──────────▼──────────┐   ┌─────────▼──────────────┐
  │  WebSocket Servisi  │   │   REST API Servisi      │
  │  (telemetri akışı)  │   │   (komutlar, config)    │
  │  websocket_service  │   │   drone_api_service     │
  └──────────┬──────────┘   └─────────┬──────────────┘
             │                        │
  ┌──────────▼────────────────────────▼──────────────────────┐
  │              Drone Backend / IoT Katmanı                  │
  │  ws://drone.majorgrup.local:8765/telemetry               │
  │  http://drone.majorgrup.local:8080/api/v1                │
  │  rtsp://drone.majorgrup.local:8554/zone[1-8]             │
  └───────────────────────────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3. KLASÖR HİYERARŞİSİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

sahin_goz/
│
├── pubspec.yaml                   # Bağımlılıklar, asset bildirimleri
├── README.txt                     # Bu dosya
│
├── lib/
│   ├── main.dart                  # Giriş noktası: orientation, wakelock, ProviderScope
│   ├── app.dart                   # MaterialApp, tema, SplashScreen
│   │
│   ├── theme/
│   │   └── app_theme.dart         # AppColors, AppTextStyles, AppShadows,
│   │                              # AppSizes, AppTheme (Material 3)
│   │
│   ├── models/                    # Saf veri sınıfları — Flutter bağımlılığı yok
│   │   ├── drone_telemetry.dart   # Anlık irtifa/hız/pil/GPS/uydu/sinyal
│   │   ├── zone_model.dart        # Bölge: id, name, streamUrl, alertLevel
│   │   └── ai_alert.dart          # YZ tespiti: tip, zone, güven, bbox
│   │
│   ├── services/                  # Ağ katmanı — UI bağımlılığı yok
│   │   ├── websocket_service.dart # WS bağlantısı, yeniden bağlanma, mesaj parse
│   │   └── drone_api_service.dart # HTTP REST istemcisi, ApiResult<T> sarmalayıcı
│   │
│   ├── providers/                 # Riverpod state yönetimi
│   │   └── drone_provider.dart    # DroneState + DroneNotifier +
│   │                              # 7 selector provider
│   │
│   ├── screens/                   # Tam ekran görünümler
│   │   ├── splash_screen.dart     # Açılış: logo animasyonu, yükleniyor
│   │   ├── main_shell_screen.dart # Alt nav çubuğu + IndexedStack (4 sekme)
│   │   └── dashboard_screen.dart  # Canlı izleme: video + telemetri + grid
│   │
│   ├── widgets/                   # Yeniden kullanılabilir UI bileşenleri
│   │   ├── drone_video_player.dart # VLC oynatıcı + HUD + YZ overlay
│   │   ├── telemetry_bar.dart     # Pil/irtifa/hız/sinyal yatay çubuğu
│   │   ├── zone_card.dart         # Tek bölge kartı: pulse/flash animasyon
│   │   └── zone_grid.dart         # 4×2 bölge seçici grid
│   │
│   └── utils/
│       └── constants.dart         # URL'ler, eşikler, dart-define sabitleri
│
└── assets/
    ├── icons/                     # Uygulama ikonu dosyaları (bkz. bölüm 10)
    └── images/                    # Splash arkaplan görseli (opsiyonel)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
4. DOSYA VE SINIF REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── main.dart ─────────────────────────────────────────────────────────────────

  Giriş noktası. WidgetsFlutterBinding, portrait kilit,
  SystemUiOverlayStyle (şeffaf status bar), WakelockPlus.enable(),
  ProviderScope ← Riverpod kök widget'ı.

── app.dart ──────────────────────────────────────────────────────────────────

  MaterialApp: AppTheme.dark, Türkçe locale, SplashScreen giriş.
  ConsumerWidget: ileride tema değişikliği için provider hazır.

── theme/app_theme.dart ──────────────────────────────────────────────────────

  AppColors        12 renk sabiti (bg0-bg4, cyan, green, amber, red, orange,
                   text1-text4, border1-3, glowCyan/Green/Red/Amber/Orange)

  AppTextStyles    4 font ailesi:
                   · display()   → Rajdhani (başlık, HUD)
                   · mono()      → Share Tech Mono (telemetri, koordinat)
                   · body()      → Barlow (genel metin)
                   · condensed() → Barlow Condensed (kompakt etiket)
                   + 9 hazır stil sabiti (brandName, hudValue, alertText vb.)

  AppShadows       Glow BoxShadow üretici: cyanGlow, greenGlow, redGlow,
                   amberGlow, orangeGlow

  AppSizes         radius/padding sabitleri + dikey flex oranları
                   (cameraFlex:38, controlFlex:10, mapFlex:8, zoneFlex:44)

  AppTheme.dark    Material 3 koyu tema: ColorScheme, AppBarTheme,
                   BottomNavigationBarTheme, CardTheme, SwitchTheme,
                   TextTheme (Google Fonts ile), PageTransitionsTheme

── models/drone_telemetry.dart ───────────────────────────────────────────────

  DroneTelemetry   WebSocket JSON'ından gelen anlık ölçüm verisi.
  Alanlar: altitude(double), speed(double), battery(int), lat(double),
           lng(double), heading(int), satellites(int), signal(int),
           timestamp(DateTime)
  Özellikler: batteryStatus, signalLabel, headingLabel, coordsFormatted
  Fabrika: fromJson(Map), empty()
  Equatable: aynı veri gelince provider gereksiz rebuild tetiklemez.

── models/zone_model.dart ────────────────────────────────────────────────────

  ZoneModel        Tek izleme bölgesi.
  Alanlar: id(1-8), name, shortName(B1-B8), streamUrl(RTSP), lat, lng,
           alertLevel(ZoneAlertLevel), alertMessage, isActive, workerCount
  Hesaplanan: hasAlert, indicatorColor, borderColor

  ZoneAlertLevel   Enum: normal | warning | critical

  kDefaultZones    8 bölgelik varsayılan liste — geliştirme/demo için.
                   Üretimde DroneApiService.fetchZones() ile değiştirilir.

── models/ai_alert.dart ──────────────────────────────────────────────────────

  AiAlert          YZ güvenlik tespiti.
  Alanlar: id, type(AiAlertType), zoneId, confidence(0-1), message,
           timestamp, boundingBox(BoundingBox?), acknowledged
  Metod: acknowledge() → yeni kopya döner (acknowledged: true)

  AiAlertType      Enum: noHelmet | trespassing | inactivity | safetyViolation
                   Her biri: labelTr(Türkçe), icon(emoji) içerir

  BoundingBox      Normalize koordinatlar (0.0-1.0): x, y, width, height

── services/websocket_service.dart ───────────────────────────────────────────

  WebSocketService  Drone backend'ine ws:// bağlantısı.

  connect()         Bağlantı kur, event listener başlat
  sendCommand(Map)  JSON komut gönder (zone switch, RTH vb.)
  dispose()         Kanal kapat, stream controller temizle

  Streams:
    messages          Stream<WsMessage> — telemetri ve uyarılar
    connectionState   Stream<WsConnectionState> — bağlantı durumu

  Yeniden bağlanma: üstel geri çekilme (reconnectDelay * attempt)
                   Maksimum 10 deneme.

  WsMessage:   telemetry(DroneTelemetry) | alert(AiAlert) | unknown(Map)
  WsConnectionState: disconnected|connecting|connected|reconnecting|error

── services/drone_api_service.dart ───────────────────────────────────────────

  DroneApiService  HTTP REST istemcisi.

  switchZone(int)    POST /drone/switch-zone { zone_id: N }
  fetchStatus()      GET  /drone/status → DroneTelemetry
  fetchZones()       GET  /zones → List<ZoneModel>
  fetchAlerts()      GET  /alerts?limit=&offset= → List<AiAlert>
  returnToHome()     POST /drone/return-to-home

  ApiResult<T>: success(data) | failure(errorString)
  Exception yerine Result pattern kullanılır; UI always Türkçe mesaj görür.

── providers/drone_provider.dart ─────────────────────────────────────────────

  DroneState (immutable)
    zones, activeZoneId, telemetry, connectionState,
    alerts, isSwitchingZone, lastError
    Hesaplanan: activeZone, isConnected, hasAlerts,
                criticalAlertCount, activeZoneAlerts

  DroneNotifier (AsyncNotifier<DroneState>)
    build()                   WS init, listener kurulumu
    switchZone(int)           Optimistic update + WS komut + REST API
    returnToHome()            WS komut + REST
    acknowledgeAlert(String)  Uyarı onayla
    clearAcknowledgedAlerts() Onaylananları sil
    reconnect()               Manuel yeniden bağlanma
    startSimulation()         Drone olmadan test modu

  Granüler Provider'lar (gereksiz rebuild önleme):
    droneProvider             Ana provider
    activeZoneProvider        Sadece aktif bölge
    telemetryProvider         Sadece telemetri
    connectionStateProvider   Sadece bağlantı
    alertsProvider            Sadece uyarılar
    zonesProvider             Bölge listesi
    batteryProvider           Sadece pil
    isConnectedProvider       Boolean

── screens/splash_screen.dart ────────────────────────────────────────────────

  SplashScreen     2.2s açılış animasyonu.
  - Dönen hexagonal halka (AnimationController, linear, sürekli)
  - Logo scale+fade giriş (easeOutBack, 700ms)
  - Marka adı slideY+fadeIn (delay 300ms)
  - LinearProgressIndicator (yükleniyor çubuğu)
  - 2200ms sonra MainShellScreen'e fade geçiş

── screens/main_shell_screen.dart ────────────────────────────────────────────

  MainShellScreen  Alt navigasyon kabuğu.
  IndexedStack: 4 sekme bellekte, state korunur.
  Tab 0: DashboardScreen (canlı izleme)
  Tab 1-3: Placeholder (ileriki adımlar için)
  Alt nav uyarı rozeti: hasAlerts → kırmızı nokta

── screens/dashboard_screen.dart ─────────────────────────────────────────────

  DashboardScreen  Ana canlı izleme ekranı.

  _StatusBar       Marka logosu + GPS + sinyal + saat (10s timer)
  _ControlBar      Pil göstergesi + geçiş yükleyici + RTH butonu
  _SystemStatusBar YZ modeli durumu + şifreleme + sinyal + uyarı sayısı
  DroneVideoPlayer (widget)
  TelemetryBar     (widget)
  ZoneGrid         (widget — Step 3'te eklendi)

  PopScope.canPop: false — geri tuşu RTH onay dialog'u açar
  didChangeAppLifecycleState: resume → reconnect()
  Hata snackbar: droneProvider.lastError izlenir

── widgets/drone_video_player.dart ───────────────────────────────────────────

  DroneVideoPlayer (ConsumerStatefulWidget)
  RepaintBoundary ile sarılı → video yeniden çizimi izole.
  AspectRatio: 16/9

  Stack katmanları:
    _VideoLayer        VlcPlayer + AnimatedSwitcher (fade, 400ms)
    _CrtScanlines      repeating-linear-gradient (IgnorePointer)
    _CornerBrackets    CustomPaint bracket çizgisi
    _TopHudBar         CANLI badge + REC (AnimationController 900ms) + GPS
    _BottomHudBar      Uyarı etiketi + bağlantı durumu
    AiAlertOverlay     YZ bbox + aFlash (AnimationController 1500ms)

  Stream geçişi: ref.listen(activeZoneProvider) → _initPlayer(url)
  Hata durumu: _ErrorPlaceholder (Türkçe mesaj)
  Yükleniyor: _LoadingPlaceholder (CircularProgressIndicator)

  AiAlertOverlay     aFlash: Tween(1.0→0.25) + CurvedAnimation(easeInOut)
                     Bounding box: LayoutBuilder ile normalize → piksel
                     _AlertBanner: alt şerit uyarı mesajı

── widgets/telemetry_bar.dart ────────────────────────────────────────────────

  TelemetryBar (ConsumerWidget)
  5 bağımsız hücre, her biri kendi granüler provider'ını izler:

  _BatteryCell       batteryProvider → renk (>50 yeşil, >20 amber, kırmızı)
                     AnimatedContainer doluluk çubuğu (600ms)
  _AltitudeCell      telemetryProvider.select(t.altitude)
  _SpeedCell         telemetryProvider.select(t.speed)
  _SignalCell        telemetryProvider.select(t.signal)
                     4 çubuklu _SignalBars göstergesi
  _ConnectionCell    connectionStateProvider → Türkçe durum etiketi

  _AnimatedValue     SlideTransition(Offset(0,-0.4)→0) + FadeTransition
                     Sayı değişiminde yukarıdan kayarak giriş

── widgets/zone_card.dart ────────────────────────────────────────────────────

  ZoneCard (ConsumerStatefulWidget)
  ValueKey('zone_card_${zone.id}') → state korunur, rebuild sıfırlamaz.

  Animasyonlar:
    _pulseCtrl (1600ms, repeat)    Aktif nokta: scale(1.0→1.8) + opacity(0.8→0)
    _flashCtrl (1200ms, reverse)   Uyarı nokta: opacity(1.0→0.15) aFlash

  Görsel:
    _GridTexture      CustomPaint ızgara dokusu
    _CardTopRow       Bölge kodu + durum noktası (pulse veya flash)
    _CardBottomRow    Bölge adı + işçi sayısı (YZ çıktısı)
    _LiveBadge        Aktif kart sağ üst: kırmızı CANLI rozeti
    _AlertStripe      Alt uyarı şeridi (flash animasyonlu)

  Dokunma: GestureDetector → AnimatedScale(0.93) basma efekti
  Sınır rengi: aktif=orange | kritik=red | uyarı=amber | normal=border2
  Glow: AppShadows.orangeGlow (aktif), redGlow/amberGlow (uyarı)

── widgets/zone_grid.dart ────────────────────────────────────────────────────

  ZoneGrid (ConsumerWidget)
  GridView.builder: 4 sütun, NeverScrollableScrollPhysics
  SliverGridDelegateWithFixedCrossAxisCount: crossAxis=4, aspect=1.0
  8 ZoneCard, ValueKey ile.

  _GridHeader: Bölge sayısı + kritik/uyarı rozetleri + aktif göstergesi
  Giriş animasyonu: slideY(0.12→0) + fadeIn (flutter_animate)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5. BAĞIMLILIKLAR (KÜTÜPHANe DOKÜMANTASYONU)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌──────────────────────────┬──────────┬─────────────────────────────────────┐
│ Paket                    │ Sürüm    │ Kullanım Amacı                      │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ flutter_riverpod         │ ^2.5.1   │ State yönetimi. AsyncNotifier ile  │
│                          │          │ async init (WS), granüler selector  │
│                          │          │ provider'lar ile rebuild izolasyonu. │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ flutter_vlc_player       │ ^7.4.1   │ RTSP/HLS video oynatıcı. Drone      │
│                          │          │ firmware'inin kullandığı RTSP        │
│                          │          │ protokolünü natifte destekler.       │
│                          │          │ VlcPlayerController ile stream URL   │
│                          │          │ çalışma zamanında değiştirilebilir.  │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ wakelock_plus            │ ^1.2.8   │ Drone izleme sırasında ekranın       │
│                          │          │ kararmasını engeller. Saha           │
│                          │          │ kullanımında operatörün ekrandan     │
│                          │          │ kopmaması için kritik.               │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ google_fonts             │ ^6.2.1   │ Rajdhani + Share Tech Mono.          │
│                          │          │ Web prototipinin tipografisini        │
│                          │          │ Flutter'a taşır.                     │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ http                     │ ^1.2.1   │ Zone switch, RTH, config REST         │
│                          │          │ çağrıları. Hafif, test edilebilir.   │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ web_socket_channel       │ ^2.4.5   │ dart:io WebSocket'ini Stream         │
│                          │          │ wrapper'a sarar. Telemetri için       │
│                          │          │ sürekli bağlantı.                    │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ equatable                │ ^2.0.5   │ Model sınıflarında == ve hashCode.   │
│                          │          │ Aynı değer gelince Riverpod           │
│                          │          │ yeniden rebuild tetiklemez.          │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ shared_preferences       │ ^2.2.3   │ Seçili bölge, son stream URL gibi    │
│                          │          │ hafif ayarların yerel saklanması.    │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ permission_handler       │ ^11.3.1  │ Kamera ve ağ runtime izinleri.       │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ connectivity_plus        │ ^6.0.3   │ WiFi/mobil/çevrimdışı durum tespiti. │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ flutter_animate          │ ^4.5.0   │ ZoneGrid giriş animasyonu, splash    │
│                          │          │ geçişleri. Deklaratif, performanslı. │
├──────────────────────────┼──────────┼─────────────────────────────────────┤
│ intl                     │ ^0.19.0  │ Türkçe tarih/saat/sayı formatı.     │
└──────────────────────────┴──────────┴─────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
6. KURULUM VE İLK ÇALIŞTIRMA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Gereksinimler:
  Flutter SDK  ≥ 3.19.0    (flutter --version)
  Dart SDK     ≥ 3.3.0     (dart --version)
  Xcode        ≥ 15        (iOS için)
  Android SDK  API 24+     (Android için)

Adımlar:
  1. flutter pub get
  2. flutter analyze          # Sıfır hata/uyarı hedefi
  3. flutter run              # Simülasyon modu (drone bağlantısı gereksiz)

Simülasyon modunu kapatmak için:
  flutter run --dart-define=SIMULATE=false


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
7. RTSP / DRONE STREAM ENTEGRASYONU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ADIM 1 — URL Güncelleme (Statik)
  lib/models/zone_model.dart içindeki kDefaultZones listesini düzenleyin:

    const ZoneModel(
      id: 1,
      name: 'Temel Kazı',
      shortName: 'B1',
      streamUrl: 'rtsp://192.168.1.100:8554/zone1',   ← burayı değiştirin
      ...
    )

ADIM 2 — URL Güncelleme (Dinamik, Önerilen)
  lib/utils/constants.dart dosyasını düzenleyerek build-time flag kullanın:

    flutter run \
      --dart-define=WS_URL=ws://192.168.1.100:8765/telemetry \
      --dart-define=API_BASE_URL=http://192.168.1.100:8080/api/v1

  Ardından DroneNotifier.build() içinde API'den zone listesi çekin:

    final result = await _api.fetchZones();
    if (result.isSuccess) {
      return DroneState.initial().copyWith(zones: result.data!);
    }

ADIM 3 — VLC Player Ayarları
  drone_video_player.dart → _initPlayer() içinde RTSP parametrelerini
  kendi firmware'inize göre ayarlayın:

    VlcPlayerController.network(
      url,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(300),   // Gecikme için küçük tut
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),          // DJI drone'lar için
        ]),
      ),
    )

ADIM 4 — WebSocket Telemetri Backend Formatı
  Drone'dan gelen mesajlar şu formatta olmalıdır:

  Telemetri mesajı:
    {
      "type": "telemetry",
      "altitude": 45.2,
      "speed": 12.5,
      "battery": 74,
      "lat": 41.0082,
      "lng": 28.9784,
      "heading": 270,
      "satellites": 12,
      "signal": 87,
      "timestamp": "2024-01-01T12:00:00Z"
    }

  YZ uyarı mesajı:
    {
      "type": "alert",
      "id": "uuid-here",
      "alert_type": "no_helmet",
      "zone_id": 4,
      "confidence": 0.94,
      "message": "Baret Yok — İşçi #3",
      "bbox": { "x": 0.3, "y": 0.4, "w": 0.1, "h": 0.2 },
      "timestamp": "2024-01-01T12:05:30Z"
    }


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
8. GERÇEK YZ BACKEND ENTEGRASYONU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Önerilen YZ Stack:
  Model:   YOLOv8 (ultralytics) — baret, insan, tehlikeli bölge tespiti
  Çerçeve: Python + FastAPI
  Veritabanı: PostgreSQL (kayıt), Redis (anlık alert pub/sub)
  Mesajlaşma: Firebase Cloud Messaging (acil bildirim) veya doğrudan WS

Backend YZ İş Akışı:
  1. Kamera frame'i al (RTSP veya drone SDK üzerinden)
  2. YOLOv8 modelini çalıştır → bounding box + sınıf tahminleri
  3. Güven eşiğini kontrol et (önerilen: 0.85+)
  4. Tespit varsa WebSocket üzerinden AiAlert JSON gönder
  5. PostgreSQL'e kayıt et

Mevcut AiAlertType'larla eşleşen sınıflar:
  no_helmet        → YOLOv8 class "hard-hat" eksik, insan var
  trespassing      → Tanımlı güvenli bölge dışına giriş (iou check)
  inactivity       → Kalman filtresi ile 15 dk hareketsizlik
  safety_violation → Diğer güvenlik ihlalleri

Flutter tarafında yeni bir tespit türü eklemek için:
  1. models/ai_alert.dart → AiAlertType enum'una yeni değer ekle
  2. WebSocketService._onData() switch case'ine ekle
  3. AiAlertOverlay'de görsel özelleştir


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
9. APK VE IPA BUILD TALİMATLARI
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── Android APK ───────────────────────────────────────────────────────────────

  # Debug APK (geliştirme)
  flutter build apk --debug

  # Release APK (üretim — imzalı)
  flutter build apk --release \
    --dart-define=SIMULATE=false \
    --dart-define=WS_URL=ws://drone.majorgrup.local:8765/telemetry \
    --dart-define=API_BASE_URL=http://drone.majorgrup.local:8080/api/v1

  # App Bundle (Google Play Store için)
  flutter build appbundle --release

  Çıktı: build/app/outputs/flutter-apk/app-release.apk

  İmzalama için android/key.properties dosyası gereklidir:
    storePassword=YOUR_STORE_PASSWORD
    keyPassword=YOUR_KEY_PASSWORD
    keyAlias=YOUR_KEY_ALIAS
    storeFile=../keystore.jks

── iOS IPA ───────────────────────────────────────────────────────────────────

  # Release build (Xcode gerekli)
  flutter build ios --release \
    --dart-define=SIMULATE=false \
    --dart-define=WS_URL=ws://drone.majorgrup.local:8765/telemetry

  Ardından Xcode'da:
    Product → Archive → Distribute App → Ad Hoc veya App Store Connect


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
10. PLATFORM ÖZEL AYARLAR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── iOS (ios/Runner/Info.plist) ───────────────────────────────────────────────

  Şu key'leri ekleyin:

  <key>NSCameraUsageDescription</key>
  <string>Drone kamera akışı için kamera erişimi gereklidir.</string>

  <key>NSLocalNetworkUsageDescription</key>
  <string>Yerel ağdaki drone cihazına bağlanmak için gereklidir.</string>

  <key>NSBonjourServices</key>
  <array>
    <string>_rtsp._tcp</string>
  </array>

  <key>io.flutter.embedded_views_preview</key>
  <true/>

  iPhone 17 Pro Max (Dynamic Island) için safe-area main.dart'ta
  SystemUiOverlayStyle ile ayarlanmıştır.

── Android (android/app/src/main/AndroidManifest.xml) ────────────────────────

  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.WAKE_LOCK" />
  <uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />

  android/app/build.gradle:
    minSdkVersion 24
    targetSdkVersion 34

── flutter_vlc_player Platform Ayarları ──────────────────────────────────────

  Android: android/app/build.gradle
    dependencies {
      implementation 'org.videolan.android:libvlc-all:3.6.0'
    }

  iOS: ios/Podfile
    platform :ios, '12.0'
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
      end
    end

── Uygulama İkonu ────────────────────────────────────────────────────────────

  1. assets/icons/icon_1024.png dosyası oluşturun (1024×1024 PNG)
  2. Paketi ekleyin: flutter pub add dev:flutter_launcher_icons
  3. pubspec.yaml'a ekleyin:
       flutter_launcher_icons:
         android: true
         ios: true
         image_path: "assets/icons/icon_1024.png"
         adaptive_icon_background: "#060A0D"
         adaptive_icon_foreground: "assets/icons/icon_fg.png"
  4. Çalıştırın: flutter pub run flutter_launcher_icons


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
11. SİMÜLASYON MODU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Gerçek bir drone bağlantısı olmadan uygulamayı test etmek için:

  flutter run   (varsayılan: SIMULATE=true)

Bu modda:
  - DroneNotifier.startSimulation() otomatik çağrılır
  - Her 2 saniyede sahte telemetri verisi üretilir
  - WS bağlantısı beklenmez; simüle edilmiş DroneState kullanılır
  - Video oynatıcı "AKIŞ BEKLENIYOR..." placeholder gösterir

Test uyarısı eklemek için (geliştirme konsolu):
  ref.read(droneProvider.notifier)  (DroneNotifier)
  _onMessage(WsMessage.alert(AiAlert.fromJson({
    "type": "alert", "id": "test-1",
    "alert_type": "no_helmet", "zone_id": 4,
    "confidence": 0.95, "message": "Test: Baret Yok",
    "timestamp": "..."
  })));


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
12. GELİŞTİRİCİ NOTLARI
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Performans:
  ◆ RepaintBoundary: DroneVideoPlayer içine sarılıdır. Video frame'leri
    yeniden çizildiğinde TelemetryBar ve ZoneGrid etkilenmez.
  ◆ Granüler provider selector'lar: telemetryProvider.select(t.altitude)
    ile sadece irtifa değiştiğinde _AltitudeCell rebuild olur.
  ◆ ZoneCard ValueKey: zone.id const key ile ZoneCard animasyon
    controller'ları grid rebuild'inde sıfırlanmaz.
  ◆ NeverScrollableScrollPhysics: ZoneGrid sürükleme yoksa scroll
    hesaplaması yapılmaz.

Yeni Ekran Eklemek (Güvenlik, Ayarlar, Profil):
  1. lib/screens/ altında yeni dosya oluşturun
  2. main_shell_screen.dart → IndexedStack'e ekleyin
  3. _PlaceholderTab satırını yeni Screen() ile değiştirin
  4. İlgili sekmeyi alt navigasyon çubuğunda aktif edin

Hata Ayıklama:
  WebSocket mesajlarını görmek için websocket_service.dart içindeki
  dev.log() çağrıları etkindir. Flutter DevTools'ta 'sahin_goz' loglarını
  filtreleyin.

Birim Test (Önerilen):
  test/drone_provider_test.dart:
    - DroneNotifier.switchZone() optimistic update testi
    - WsMessage.fromJson() parse testi
    - ApiResult failure propagation testi

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
© 2025 Major Grup — Şahin Göz Drone İzleme Sistemi
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
