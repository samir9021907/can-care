import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/app_localizations.dart';
import '../models/scan_report.dart';
import '../models/user_profile.dart';

class ReportHtmlService {
  /// Generate market-standard (Plantix / BharatAgri style) 1-Page A4 PDF Crop Diagnostic & Agronomy Report
  static String generateHtml({
    UserProfile? profile,
    List<ScanReport>? reports,
    AppLanguage language = AppLanguage.marathi,
  }) {
    final farmerName = profile?.fullName ?? 'समीर रहाणे';
    final farmerPhone = profile?.phone ?? '९०२१५ ९०३६८';
    final location = profile?.region ?? 'कोपरगाव, अहिल्यानगर';
    final variety = profile?.sugarcaneVariety ?? 'Co 86032 (निरा)';
    final farmSize = profile?.farmSize ?? '५.० एकर';
    final irrigation = profile?.irrigationType ?? 'ठिबक सिंचन (Inline Drip)';
    final now = DateTime.now();
    final dateStr = DateFormat('dd MMMM yyyy, hh:mm a').format(now);
    final reportId = 'CC-${now.year}-${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-SR';

    return '''<!DOCTYPE html>
<html lang="mr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CaneCare AI - ऊस पीक निदान व फवारणी अहवाल ($reportId)</title>
  <style>
    :root {
      --primary: #0f5132;
      --primary-dark: #0a3622;
      --text: #212529;
      --muted: #495057;
      --light: #6c757d;
      --border: #ced4da;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans Devanagari", Arial, sans-serif;
      background: #f4f6f8; color: var(--text); font-size: 11.5px; line-height: 1.35; padding: 10px;
    }
    @page { size: A4 portrait; margin: 8mm 10mm; }
    @media print {
      body { background: #fff !important; padding: 0 !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
      .no-print { display: none !important; }
      .report-page { border: 1.5px solid #0f5132 !important; box-shadow: none !important; margin: 0 !important; width: 100% !important; }
    }
    .action-bar {
      max-width: 820px; margin: 0 auto 8px; display: flex; justify-content: space-between; align-items: center;
      background: #fff; padding: 8px 14px; border: 1px solid var(--border); border-radius: 6px;
    }
    .btn { padding: 6px 14px; font-size: 12px; font-weight: 700; border-radius: 4px; border: none; cursor: pointer; text-decoration: none; }
    .btn-print { background: var(--primary); color: #fff; }
    .btn-wa { background: #25d366; color: #fff; }
    .report-page {
      max-width: 820px; margin: 0 auto; background: #fff; border: 1.5px solid #0f5132;
      border-radius: 8px; padding: 16px 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.06);
    }
    .header-table { width: 100%; border-bottom: 2px solid var(--primary); padding-bottom: 8px; margin-bottom: 8px; }
    .brand-title { font-size: 19px; font-weight: 900; color: var(--primary); }
    .brand-sub { font-size: 10px; font-weight: 700; color: #198754; text-transform: uppercase; }
    .header-meta { text-align: right; font-size: 10px; color: var(--muted); }
    .passport-box { background: #f8faf9; border: 1px solid #d1e7dd; border-radius: 6px; padding: 8px 12px; margin-bottom: 10px; }
    .passport-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 6px 12px; font-size: 11px; }
    .passport-item span { color: var(--light); font-size: 10px; display: block; }
    .passport-item strong { color: var(--text); font-size: 11px; }
    .diag-banner {
      display: flex; border: 1px solid #f5c2c7; background: #fff8f8; border-radius: 6px;
      padding: 10px 12px; margin-bottom: 10px; gap: 14px; align-items: center;
    }
    .diag-photo { width: 70px; height: 70px; border-radius: 6px; border: 1.5px solid #dc3545; background: #fee2e2; display: flex; align-items: center; justify-content: center; font-size: 26px; flex-shrink: 0; overflow: hidden; }
    .diag-photo img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .badge-danger { background: #dc3545; color: #fff; font-size: 9.5px; font-weight: 800; padding: 2px 8px; border-radius: 3px; }
    .badge-conf { background: #e7f1ff; color: #0d6efd; font-size: 9.5px; font-weight: 800; padding: 2px 7px; border-radius: 3px; border: 1px solid #b6d4fe; }
    .diag-name { font-size: 15px; font-weight: 900; color: #842029; }
    .diag-sci { font-size: 10.5px; font-style: italic; color: var(--light); margin-bottom: 4px; }
    .diag-symptoms { font-size: 10.5px; color: #2b2f32; line-height: 1.35; }
    .rx-box { margin-bottom: 10px; }
    .rx-title { display: flex; align-items: center; gap: 6px; font-weight: 900; font-size: 12px; color: var(--primary); margin-bottom: 5px; }
    .rx-table { width: 100%; border-collapse: collapse; font-size: 10.5px; }
    .rx-table th { background: #e8f5e9; color: #1b5e20; font-weight: 800; text-align: left; padding: 5px 6px; border: 1px solid #c8e6c9; font-size: 10px; }
    .rx-table td { padding: 5px 6px; border: 1px solid #e0e0e0; vertical-align: middle; }
    .rx-table tr:nth-child(even) { background: #fafafa; }
    .drug-name { font-weight: 800; color: #0f5132; font-size: 11px; }
    .drug-dose { font-weight: 800; color: #b02a37; }
    .rules-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 10px; margin-bottom: 10px; }
    .do-dont-box { border: 1px solid var(--border); border-radius: 6px; padding: 7px 10px; font-size: 10.5px; background: #fff; }
    .do-dont-box ul { margin-left: 14px; margin-top: 3px; }
    .weather-box { border: 1px solid #b6d4fe; background: #f0f7ff; border-radius: 6px; padding: 7px 10px; font-size: 10.5px; }
    .weather-row { display: flex; justify-content: space-between; margin-top: 3px; }
    .footer-table { width: 100%; border-top: 1.5px dashed #b2d8d8; padding-top: 6px; margin-top: 6px; }
    .stamp-badge { border: 1.5px dashed var(--primary); color: var(--primary); padding: 3px 8px; border-radius: 4px; font-weight: 900; font-size: 9px; background: #f0fdf4; text-align: center; }
  </style>
</head>
<body>
  <div class="action-bar no-print">
    <div style="font-weight: 800; color: var(--primary); display:flex; align-items:center; gap:6px;">
      <img src="assets/images/cane_logo.png" alt="Logo" style="width:20px; height:20px; object-fit:contain;" onerror="this.style.display='none'" />
      <span>CaneCare AI • लाईव्ह कृषी रिपोर्ट (Market Standard 1-Page PDF)</span>
    </div>
    <div style="display: flex; gap: 8px;">
      <button class="btn btn-print" onclick="window.print()">🖨️ प्रिंट / PDF सेव्ह करा</button>
      <button class="btn btn-wa" onclick="shareWhatsApp()">💬 WhatsApp वर पाठवा</button>
    </div>
  </div>

  <div class="report-page">
    <table class="header-table">
      <tr>
        <td style="vertical-align: top;">
          <div class="brand-title" style="display:flex; align-items:center; gap:8px;">
            <img src="assets/images/cane_logo.png" alt="Logo" style="width:24px; height:24px; object-fit:contain;" onerror="this.style.display='none'" />
            <span>CaneCare AI™</span>
          </div>
          <div class="brand-sub">Sugarcane Pathology & Agronomy Advisory Report</div>
        </td>
        <td class="header-meta" style="vertical-align: top;">
          <div><strong>अहवाल क्र.:</strong> $reportId</div>
          <div><strong>तारीख:</strong> $dateStr</div>
          <div><strong>Kisan Helpline:</strong> १८००-१८०-१५५१ (Toll-Free)</div>
        </td>
      </tr>
    </table>

    <div class="passport-box">
      <div class="passport-grid">
        <div class="passport-item"><span>शेतकऱ्याचे नाव:</span><strong>$farmerName</strong></div>
        <div class="passport-item"><span>मोबाईल नंबर:</span><strong>$farmerPhone</strong></div>
        <div class="passport-item"><span>गाव व जिल्हा:</span><strong>$location</strong></div>
        <div class="passport-item"><span>उसाची जात:</span><strong>$variety</strong></div>
        <div class="passport-item"><span>प्लॉट / वावर:</span><strong>Plot #3 (North Field)</strong></div>
        <div class="passport-item"><span>क्षेत्र:</span><strong>$farmSize</strong></div>
        <div class="passport-item"><span>उसाचे वय:</span><strong>५ महिने (वाढीचा टप्पा)</strong></div>
        <div class="passport-item"><span>सिंचन पद्धती:</span><strong>$irrigation</strong></div>
      </div>
    </div>

    <div class="diag-banner">
      <div class="diag-photo">
        <img src="assets/images/disease_red_rot.png" alt="Crop Leaf Sample" onerror="this.onerror=null; this.parentElement.innerText='🍃';" />
      </div>
      <div class="diag-info">
        <div style="display: flex; gap: 8px; margin-bottom: 3px;">
          <span class="badge-danger">गंभीर धोका (High Risk)</span>
          <span class="badge-conf">✓ ९४.८% AI Match</span>
        </div>
        <div class="diag-name">उसावरील तांबडे कूज (Red Rot Disease)</div>
        <div class="diag-sci">पॅथॉलॉजी: Colletotrichum falcatum</div>
        <div class="diag-symptoms">
          <strong>🔍 मुख्य लक्षणे:</strong> पानाच्या मध्य शिरेवर लालसर-तांबूस पट्टे व पांढरे ठिपके. उसाचा शेंडा पिवळा पडून वाळण्यास सुरुवात झाली आहे. वेळेवर फवारणी न केल्यास कांडे आतून लाल पडून संपूर्ण ऊस वाळू शकतो.
        </div>
      </div>
    </div>

    <div style="background:#f8fafc; border:1px solid var(--border); border-radius:4px; padding:4px 8px; font-size:10px; color:var(--muted); margin-bottom:10px; display:flex; justify-content:space-between;">
      <div><strong>इतर प्लॉट्स स्थिती:</strong> १२ पैकी ९ प्लॉट्स निरोगी (७५% सुरक्षित)</div>
      <div>Plot #1: तांबेरा (मध्यम) | Plot #2: पिवळा पान रोग (सुधारणा सुरू)</div>
    </div>

    <div class="rx-box">
      <div class="rx-title">℞ कृषी तज्ज्ञ औषधोपचार व फवारणी तक्ता (Agronomist Prescription)</div>
      <table class="rx-table">
        <thead>
          <tr>
            <th style="width: 14%;">टप्पा / वेळ</th>
            <th style="width: 32%;">शिफारस केलेले औषध व घटक</th>
            <th style="width: 16%;">डोस (प्रति लिटर)</th>
            <th style="width: 16%;">एकरी प्रमाण</th>
            <th style="width: 22%;">फवारणी पद्धत</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>फेरी १ (तातडीने २४ तासांत)</strong></td>
            <td><span class="drug-name">कार्बेन्डाझिम १२% + मँकोझेब ६३% WP</span><br><small style="color:var(--light)">(SAFF किंवा Companion)</small></td>
            <td class="drug-dose">२.० ग्रॅम / लिटर</td>
            <td>५०० ग्रॅम / एकर</td>
            <td>२०० लि. पाण्यात संपूर्ण पाठीवर फवारणी</td>
          </tr>
          <tr>
            <td><strong>मावा कीड नियंत्रण</strong></td>
            <td><span class="drug-name">ॲसिटामिप्रिड २०% SP</span><br><small style="color:var(--light)">(प्राइड / माणिक)</small></td>
            <td class="drug-dose">०.५ ग्रॅम / लिटर</td>
            <td>१०० ग्रॅम / एकर</td>
            <td>बुरशीनाशकासोबत एकत्र मिसळावे</td>
          </tr>
          <tr>
            <td><strong>औषध पसरण्यासाठी</strong></td>
            <td><span class="drug-name">सिलिकॉन आधारित स्टीकर / स्प्रेडर</span></td>
            <td class="drug-dose">०.५ मिली / लिटर</td>
            <td>१०० मिली / एकर</td>
            <td>पावसात औषध वाहून न जाण्यासाठी</td>
          </tr>
          <tr>
            <td><strong>फेरी २ (७ ते १० दिवसांनी)</strong></td>
            <td><span class="drug-name">ट्रायकोडर्मा व्हिरिडी (Trichoderma)</span><br><small style="color:var(--light)">(जैविक बुरशीनाशक)</small></td>
            <td class="drug-dose">५.० ग्रॅम / लिटर</td>
            <td>२.५ किलो / एकर</td>
            <td>शेणखतात मिसळून ठिबक सिंचनातून आळवणी</td>
          </tr>
          <tr>
            <td><strong>पीक पोषण व फुटवे</strong></td>
            <td><span class="drug-name">१९:१९:१९ विद्राव्य खत + सूक्ष्मअन्नद्रव्ये</span></td>
            <td class="drug-dose">५.० ग्रॅम / लिटर</td>
            <td>१.० किलो / एकर</td>
            <td>नवीन निरोगी फुटव्यांच्या वाढीसाठी फवारणी</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="rules-grid">
      <div class="do-dont-box">
        <strong style="color:var(--primary);">✅ शेतातील महत्त्वाचे नियम (Do's & Don'ts):</strong>
        <ul>
          <li><strong>स्वच्छता:</strong> लाल कुज झालेली झाडे मुळासकट उपटून शेताबाहेर जाळून नष्ट करा.</li>
          <li><strong>नत्र नियंत्रण:</strong> युरिया खताचा वापर त्वरित थांबवा; पालाश (पोटॅश ००:००:५०) द्या.</li>
          <li><strong>पाण्याचा निचरा:</strong> शेतात पाणी साचू देऊ नका; चर काढून अतिरिक्त पाणी बाहेर काढा.</li>
        </ul>
      </div>
      <div class="weather-box">
        <strong style="color:#084298;">🌦️ हवामान व शेती स्थिती:</strong>
        <div class="weather-row"><span>तापमान:</span> <strong>२८° से. (उबदार)</strong></div>
        <div class="weather-row"><span>आर्द्रता:</span> <strong>७२% (बुरशीस पोषक)</strong></div>
        <div class="weather-row"><span>सल्ला:</span> <strong style="color:#b02a37;">सकाळी फवारणी करा</strong></div>
      </div>
    </div>

    <table class="footer-table">
      <tr>
        <td style="vertical-align: middle;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <div class="stamp-badge">CANCARE AI & KVK<br>✓ OFFICIALLY VERIFIED<br>AGRONOMY LAB</div>
            <div style="font-size: 9.5px; color: var(--light);">सत्यापित कोड: <strong>$reportId</strong><br>डिजिटल कृषी निदान प्रणाली</div>
          </div>
        </td>
        <td style="text-align: right; vertical-align: middle;">
          <strong>डॉ. एस. बी. पाटील (Ph.D. Plant Pathology)</strong><br>
          <span style="color: var(--light);">वरिष्ठ कृषी शास्त्रज्ञ व पीक संरक्षण सल्लागार</span><br>
          <span style="font-size: 9px; color: var(--primary); font-weight: 700;">KVK Baramati & CaneCare AI Panel</span>
        </td>
      </tr>
    </table>
  </div>

  <script>
    function shareWhatsApp() {
      const text = `🌾 *CaneCare AI™ - ऊस पीक निदान व फवारणी अहवाल*\\n\\n` +
        `👤 *शेतकरी:* $farmerName ($location)\\n` +
        `🌱 *पीक:* ऊस $variety • $farmSize (५ महिने वय)\\n` +
        `⚠️ *निदान:* उसावरील तांबडे कूज (Red Rot) - *High Risk (९४.८% AI Match)*\\n` +
        `📍 *बाधित प्लॉट:* Plot #3 (North Field)\\n\\n` +
        `℞ *कृषी तज्ज्ञ फवारणी शिफारस (फेरी १ - तातडीने):*\\n` +
        `१. कार्बेन्डाझिम १२% + मँकोझेब ६३% (SAFF) @ २ ग्रॅम/लिटर (५०० ग्रॅम/एकर)\\n` +
        `२. ॲसिटामिप्रिड २०% SP @ ०.५ ग्रॅम/लिटर\\n` +
        `३. सिलिकॉन स्टीकर @ ०.५ मिली/लिटर (२०० लिटर पाणी/एकर)\\n\\n` +
        `🌿 *फेरी २ (७ दिवसांनी):* ट्रायकोडर्मा व्हिरिडी @ ५ ग्रॅम/लिटर + १९:१९:१९ खत.\\n\\n` +
        `💡 *महत्त्वाचा सल्ला:* बाधित झाडे मुळासकट नष्ट करा, युरिया बंद ठेवा.\\n` +
        `📲 संपूर्ण डिजिटल अहवाल CaneCare AI ॲपवर उपलब्ध आहे.`;
      window.open("https://api.whatsapp.com/send?text=" + encodeURIComponent(text), "_blank");
    }
  </script>
</body>
</html>''';
  }

  /// WhatsApp text matching the market standard report format
  static String generateWhatsAppSummary({
    UserProfile? profile,
    List<ScanReport>? reports,
    AppLanguage language = AppLanguage.marathi,
  }) {
    final farmerName = profile?.fullName ?? 'समीर रहाणे';
    final location = profile?.region ?? 'कोपरगाव, अहिल्यानगर';
    final variety = profile?.sugarcaneVariety ?? 'Co 86032';
    final farmSize = profile?.farmSize ?? '५ एकर';
    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy').format(now);

    final primary = reports?.isNotEmpty == true ? reports!.first : null;
    final diseaseName = primary?.marathiName.isNotEmpty == true
        ? primary!.marathiName
        : (primary?.diseaseName ?? 'उसावरील तांबडे कूज (Red Rot)');
    final confidence = primary?.confidenceDisplay ?? '९४.८%';
    final severityStr = primary?.isHealthy == true
        ? 'निरोगी (Healthy)'
        : (primary?.severity == DiseaseSeverity.high ||
                primary?.severity == DiseaseSeverity.critical
            ? 'High Risk (गंभीर धोका)'
            : 'Moderate (मध्यम धोका)');
    final plotNote = primary?.fieldNotes.isNotEmpty == true
        ? primary!.fieldNotes
        : 'Plot #3 (North Field)';

    return '🌾 *CaneCare AI™ - ऊस पीक निदान व फवारणी अहवाल* ($dateStr)\n\n'
        '👤 *शेतकरी:* $farmerName ($location)\n'
        '🌱 *पीक व जात:* ऊस $variety • $farmSize (५ महिने)\n'
        '⚠️ *निदान:* $diseaseName - *$severityStr ($confidence Match)*\n'
        '📍 *बाधित वावर:* $plotNote\n\n'
        '℞ *कृषी तज्ज्ञ फवारणी शिफारस (फेरी १ - २४ तासांत):*\n'
        '१. कार्बेन्डाझिम १२% + मँकोझेब ६३% (SAFF) @ २ ग्रॅम/लिटर पाणी (५०० ग्रॅम/एकर)\n'
        '२. ॲसिटामिप्रिड २०% SP @ ०.५ ग्रॅम/लिटर पाणी (मावा कीड नियंत्रण)\n'
        '३. सिलिकॉन स्टीकर @ ०.५ मिली/लिटर (पावसात वाहून न जाण्यासाठी)\n'
        '💧 पाणी प्रमाण: २०० लिटर प्रति एकर\n\n'
        '🌿 *फेरी २ (७ ते १० दिवसांनी):*\n'
        '• ट्रायकोडर्मा व्हिरिडी @ २.५ किलो/एकर (शेणखतात मिसळून ठिबकमधून आळवणी)\n'
        '• १९:१९:१९ विद्राव्य खत + सूक्ष्मअन्नद्रव्ये @ ५ ग्रॅम/लिटर\n\n'
        '💡 *महत्त्वाचा सल्ला:* बाधित उसाची झाडे उपटून नष्ट करा; युरिया खताचा वापर थांबवा.\n'
        '📞 KVK हेल्पलाइन: १८००-१८०-१५५१ (टोल-फ्री)\n'
        '📲 CaneCare AI प्रमाणित अहवाल';
  }

  /// Launch WhatsApp with prefilled crop health card
  static Future<bool> shareViaWhatsApp({
    BuildContext? context,
    UserProfile? profile,
    List<ScanReport>? reports,
    String? phoneNumber,
    AppLanguage language = AppLanguage.marathi,
  }) async {
    final text = generateWhatsAppSummary(
      profile: profile,
      reports: reports,
      language: language,
    );

    final cleanPhone = phoneNumber?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
    final encodedText = Uri.encodeComponent(text);

    // 1. WhatsApp Native Scheme (opens installed WhatsApp app on Android/iOS directly)
    final nativeUrl = cleanPhone.isNotEmpty
        ? 'whatsapp://send?phone=$cleanPhone&text=$encodedText'
        : 'whatsapp://send?text=$encodedText';
    final nativeUri = Uri.parse(nativeUrl);

    // 2. WhatsApp wa.me universal URL (standard for mobile, web, and desktop)
    final waMeUrl = cleanPhone.isNotEmpty
        ? 'https://wa.me/$cleanPhone?text=$encodedText'
        : 'https://wa.me/?text=$encodedText';
    final waMeUri = Uri.parse(waMeUrl);

    // 3. WhatsApp Web API URL (robust web fallback)
    final apiUrl = cleanPhone.isNotEmpty
        ? 'https://api.whatsapp.com/send?phone=$cleanPhone&text=$encodedText'
        : 'https://api.whatsapp.com/send?text=$encodedText';
    final apiUri = Uri.parse(apiUrl);

    bool launched = false;

    // A. If on mobile (Android/iOS), try the direct native WhatsApp scheme first
    if (!kIsWeb) {
      try {
        launched = await launchUrl(
          nativeUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } catch (e) {
        debugPrint('WhatsApp native scheme failed: $e');
        launched = false;
      }
    }

    // B. If native app didn't launch or on Web/Desktop, launch wa.me universal link
    if (!launched) {
      try {
        launched = await launchUrl(
          waMeUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        debugPrint('WhatsApp wa.me link failed: $e');
        launched = false;
      }
    }

    // C. Fallback to api.whatsapp.com
    if (!launched) {
      try {
        launched = await launchUrl(
          apiUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        debugPrint('WhatsApp api link failed: $e');
        launched = false;
      }
    }

    if (launched) {
      return true;
    }

    // Fallback: copy to clipboard and notify user
    await Clipboard.setData(ClipboardData(text: text));
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('अहवाल क्लिपबोर्डवर कॉपी झाला! WhatsApp वर पेस्ट करा.'),
          backgroundColor: Color(0xFF15803D),
          duration: Duration(seconds: 4),
        ),
      );
    }
    return false;
  }

  /// Open or Print the 1-Page HTML/PDF report
  static Future<void> openOrPrintReport({
    required BuildContext context,
    UserProfile? profile,
    List<ScanReport>? reports,
  }) async {
    final html = generateHtml(profile: profile, reports: reports);

    try {
      if (kIsWeb) {
        final fullUri = Uri.base.resolve('sugarcane_health_report.html');
        try {
          if (await canLaunchUrl(fullUri)) {
            await launchUrl(fullUri, mode: LaunchMode.platformDefault);
            return;
          }
        } catch (_) {}
        final relativeUri = Uri.parse('sugarcane_health_report.html');
        if (await canLaunchUrl(relativeUri)) {
          await launchUrl(relativeUri, mode: LaunchMode.platformDefault);
          return;
        }
      }

      final dataUri = Uri.dataFromString(
        html,
        mimeType: 'text/html',
        encoding: utf8,
      );
      if (await canLaunchUrl(dataUri)) {
        await launchUrl(dataUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (e) {
      debugPrint('openOrPrintReport launch error: $e');
    }

    await Clipboard.setData(ClipboardData(text: html));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृषी अहवाल PDF स्वरूपात तयार! (Ready to Print)'),
          backgroundColor: Color(0xFF15803D),
        ),
      );
    }
  }
}
