import { ArrowLeft } from "lucide-react";
import "./nura.css";

const PrivacyPolicy = () => (
  <div className="nura-page min-h-screen">
    <div className="nura-container max-w-3xl py-16 px-6">
      <a href="/nura" className="inline-flex items-center gap-1.5 text-sm text-[hsl(200_10%_46%)] hover:text-[hsl(200_19%_18%)] transition-colors mb-8">
        <ArrowLeft className="w-4 h-4" />
        Back to Nura
      </a>

      <h1 className="text-4xl font-bold mb-2" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>
        Privacy Policy
      </h1>
      <p className="text-[hsl(200_10%_46%)] mb-12">Last updated: March 22, 2026</p>

      <div className="space-y-10 text-[hsl(200_19%_18%)] leading-relaxed">
        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>1. Introduction</h2>
          <p>
            Nura ("we", "our", or "the app") is an Islamic spiritual companion app developed by major. group. This privacy policy explains how we collect, use, and protect your personal data when you use Nura on iOS or Android.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>2. Data We Collect</h2>
          <p className="mb-3">We collect the following data to provide and improve our services:</p>
          <ul className="list-disc pl-6 space-y-2">
            <li><strong>Device ID</strong> — A unique anonymous identifier for your device. We do not require account creation or personal information such as name or email.</li>
            <li><strong>Platform</strong> — Whether you use iOS or Android.</li>
            <li><strong>Language preference</strong> — Your selected language within the app.</li>
            <li><strong>Location data</strong> — GPS coordinates or manually entered city, used solely to calculate accurate prayer times. Location data is not stored on our servers; it is processed in real time.</li>
            <li><strong>Prayer tracking data</strong> — Your daily prayer check-ins and history.</li>
            <li><strong>Saved duas</strong> — Supplications you save within the app.</li>
            <li><strong>AI usage count</strong> — The number of AI-powered queries you make (for managing usage limits).</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>3. How We Use Your Data</h2>
          <ul className="list-disc pl-6 space-y-2">
            <li>To calculate and display accurate prayer times based on your location.</li>
            <li>To save your prayer tracking history and saved duas across sessions.</li>
            <li>To process AI-powered queries (Ask about Islam, Dua for Your Mood) via our server.</li>
            <li>To manage subscription status and AI usage limits.</li>
            <li>To provide the app in your preferred language.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>4. Third-Party Services</h2>
          <p className="mb-3">We use the following third-party services:</p>
          <ul className="list-disc pl-6 space-y-2">
            <li><strong>Google Gemini AI</strong> — Used for generating personalized duas and answering Islamic questions. Your queries are sent to Google's Gemini API through our server (not directly from your device). Google's privacy policy applies to their processing of this data.</li>
            <li><strong>Aladhan API</strong> — Used for calculating prayer times based on your location. Only your coordinates or city name are sent to this service.</li>
          </ul>
          <p className="mt-3">We do not use any analytics, advertising, or tracking services.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>5. Data Storage & Security</h2>
          <p>
            Your data is stored securely on Supabase (PostgreSQL) hosted in the AWS EU region. We implement appropriate technical and organizational measures to protect your data against unauthorized access, alteration, or destruction. All data transmission between the app and our servers is encrypted via HTTPS/TLS.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>6. Data Retention</h2>
          <p>
            Your data is retained as long as you use the app. Since accounts are anonymous (device ID only), you can reset your data by reinstalling the app. If you wish to request deletion of your data, please contact us at the email below.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>7. Children's Privacy</h2>
          <p>
            Nura does not knowingly collect personal data from children under the age of 13. The app does not require any personal information for use, as all accounts are anonymous.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>8. Subscriptions</h2>
          <p>
            Nura offers premium features through in-app subscriptions. Payment processing is handled entirely by Apple (App Store) or Google (Play Store). We do not collect or store any payment information.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>9. Your Rights</h2>
          <p className="mb-3">You have the right to:</p>
          <ul className="list-disc pl-6 space-y-2">
            <li>Request access to the data we hold about your device.</li>
            <li>Request deletion of your data.</li>
            <li>Withdraw consent for location access at any time via your device settings.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>10. Changes to This Policy</h2>
          <p>
            We may update this privacy policy from time to time. Any changes will be reflected on this page with an updated revision date. Continued use of the app after changes constitutes acceptance of the updated policy.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-3" style={{ fontFamily: "'Playfair Display', Georgia, serif" }}>11. Contact</h2>
          <p>
            If you have any questions about this privacy policy or wish to request data deletion, please contact us at:
          </p>
          <p className="mt-2">
            <a href="mailto:admin@majorgrup.tc" className="text-[hsl(123_54%_24%)] font-medium hover:underline">admin@majorgrup.tc</a>
          </p>
        </section>
      </div>
    </div>
  </div>
);

export default PrivacyPolicy;
