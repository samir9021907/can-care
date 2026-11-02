# CaneCare AI (केनकेअर एआय / केनकेयर एआई)
### AI-Based Sugarcane Disease Detection Using Leaf Image Analysis

**Target Users:** Sugarcane Farmers in Maharashtra, India (Kolhapur, Sangli, Satara, Pune, Solapur, Ahmednagar, etc.)  
**Current Phase:** Frontend Only (Phase 1)  
**Future Phases:** Python AI/ML model training, FastAPI backend, and PostgreSQL database integration.

---

## 🌾 Project Overview

CaneCare AI is a mobile application built exclusively in **Flutter & Dart** designed to help sugarcane growers identify foliar diseases (such as Rust, Red Rot, Smut, Mosaic, and Yellow Leaf Disease) using smartphone camera analysis.

### Visual Design System
- **Primary Deep Green:** `#2E7D32`
- **Dark Green:** `#14532D`
- **Light Green:** `#A5D6A7`
- **Background:** `#F7FAF5`
- **Cream Accent:** `#FFFDF2`
- **Warm Yellow:** `#F9A825`
- **Main Text:** `#153B28`
- **Secondary Text:** `#607568`
- **Error / Warning:** `#C62828` / `#EF6C00`
- **Layout:** Mobile-first, responsive for Samsung Galaxy S25 Ultra (~393 × 852 px) and smaller Android devices.
- **Card & Button Radii:** 16px rounded cards, 12px rounded buttons, 48px minimum touch targets.

---

## 📱 Complete Screen & State Checklist (1–95)

- **A. Splash & Onboarding:**
  - `SplashScreen`: Logo with stalk/leaf vector mark, tagline, subtitle, and Get Started action.
  - `LanguageSelectionScreen`: English, मराठी, हिंदी with checkmark and persistent storage.
  - `OnboardingScreen`: 3 interactive slides with visual previews, Skip & Continue actions.
- **B. Authentication (Local Demo Flow):**
  - `SignInScreen` & `SignUpScreen`: Form validation, show/hide password, Google and Apple sign-in demo states (loading, success, cancelled, failure).
  - `ForgotPasswordScreen`: Email reset flow and confirmation state.
  - Error states for invalid email, missing fields, weak password, and password mismatch.
- **C. Home Dashboard:**
  - `HomeScreen`: Greeting ("Namaste, Farmer!"), Hero green card ("Is your sugarcane healthy?"), Scan Leaf and Gallery buttons, Recent Scans preview, Common Diseases preview, Crop tips, and quick help.
  - Interactive toggles to preview Loading and Empty dashboard states.
- **D. Scan & Image Upload:**
  - `ScanCameraScreen`: Framing reticle, lighting instruction, shutter, flash toggle, and gallery picker.
  - Edge cases: Camera permission denied, initialization failure, blurry warning, wrong crop, no leaf detected, and file too large.
- **E. Preview & Analysis:**
  - `ImagePreviewScreen`: Selected leaf photo, retake, choose another, analyze button, and validation alert banners.
  - `AiAnalyzingScreen`: Real-time vertical laser sweep animation, status progress messages, and simulation menu (Rust, Red Rot, Smut, Mosaic, YLD, Healthy, Low Confidence, Unsupported Crop, No Internet, Server Offline).
- **F. Disease Results:**
  - `DiseaseResultScreen`: Leaf photo, predicted disease name, sample confidence meter (demo), severity badge, symptoms, possible causes, treatment guidance, simulated affected-area heatmap toggle, save report, share report, and scan another leaf.
- **G. History & Reports:**
  - `HistoryScreen`: Search bar, filter chips (All, Healthy, Diseased), and report cards.
  - `SavedReportDetailScreen`: Offline saved report details, farmer field notes, delete confirmation dialog, and export.
- **H. Disease Encyclopedia:**
  - `DiseaseLibraryScreen`: Search and category filter (All, Fungal, Viral, Healthy).
  - `DiseaseDetailScreen`: Comprehensive agronomic profiles for Rust, Red Rot, Smut, Mosaic, Yellow Leaf, and Healthy sugarcane.
- **I. Healthy Crop Tips:**
  - `CropTipsScreen` & `CropTipDetailScreen`: Field monitoring, irrigation, certified clean planting material, field sanitation, disease prevention, and expert consultation.
- **J. Profile & Settings:**
  - `ProfileScreen`: Farmer initials avatar, demo credentials, Account & Profile, Language switcher, Notification preferences, Help & Support, Contact Support (KVK & VSI Pune), Feedback form, About CaneCare AI, Privacy Policy, Terms of Service, and Logout confirmation.

---

## 🛠️ Project Structure

```
canecare/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_dimensions.dart
│   │   └── app_typography.dart
│   ├── localization/
│   │   └── app_localizations.dart
│   ├── models/
│   │   ├── user_profile.dart
│   │   ├── disease_info.dart
│   │   ├── prediction_result.dart
│   │   ├── scan_report.dart
│   │   ├── treatment_guidance.dart
│   │   └── crop_tip.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── image_service.dart
│   │   ├── prediction_service.dart
│   │   ├── report_service.dart
│   │   ├── disease_service.dart
│   │   └── settings_service.dart
│   ├── providers/
│   │   ├── locale_provider.dart
│   │   ├── auth_provider.dart
│   │   ├── scan_provider.dart
│   │   ├── history_provider.dart
│   │   ├── disease_library_provider.dart
│   │   ├── tips_provider.dart
│   │   └── settings_provider.dart
│   ├── widgets/
│   │   ├── cane_logo.dart
│   │   ├── app_buttons.dart
│   │   ├── google_sign_in_button.dart
│   │   ├── apple_sign_in_button.dart
│   │   ├── app_text_field.dart
│   │   ├── language_card.dart
│   │   ├── severity_badge.dart
│   │   ├── confidence_meter.dart
│   │   ├── disease_card.dart
│   │   ├── history_card.dart
│   │   ├── scanning_indicator.dart
│   │   ├── treatment_section.dart
│   │   ├── confirm_dialog.dart
│   │   ├── empty_state_view.dart
│   │   ├── error_state_view.dart
│   │   ├── app_bottom_nav.dart
│   │   └── app_snackbar.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── language_selection_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── signin_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   ├── main_navigation_shell.dart
│   │   ├── home_screen.dart
│   │   ├── scan_camera_screen.dart
│   │   ├── image_preview_screen.dart
│   │   ├── ai_analyzing_screen.dart
│   │   ├── disease_result_screen.dart
│   │   ├── history_screen.dart
│   │   ├── saved_report_detail_screen.dart
│   │   ├── disease_library_screen.dart
│   │   ├── disease_detail_screen.dart
│   │   ├── crop_tips_screen.dart
│   │   ├── crop_tip_detail_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── notifications_screen.dart
│   │   ├── help_support_screen.dart
│   │   ├── contact_support_screen.dart
│   │   ├── feedback_screen.dart
│   │   ├── about_screen.dart
│   │   ├── privacy_policy_screen.dart
│   │   └── terms_screen.dart
│   └── utils/
│       └── app_helpers.dart
├── assets/
│   ├── images/
│   └── icons/
└── test/
    ├── models_test.dart
    └── widget_test.dart
```

---

## 🚀 Running the Application

### 1. Prerequisites
- Flutter SDK (version 3.19+ or higher)
- Android Studio / VS Code with Flutter extension
- Connected Android device or Android Emulator

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Code Quality & Tests
```bash
flutter analyze
flutter test
```

### 4. Run Locally
```bash
flutter run
```

---

## 🔮 Future Phases (Roadmap)
1. **AI/ML Model Training:** Train PyTorch/TensorFlow Vision Transformer (ViT) & EfficientNet models on sugarcane foliar disease datasets.
2. **Backend API Microservice:** Expose FastAPI prediction endpoints with ONNX runtime or TensorRT.
3. **Database Integration:** Connect PostgreSQL with PostGIS for geo-tagged field disease mapping across Maharashtra districts.
