import 'package:flutter_test/flutter_test.dart';
import 'package:canecare/localization/app_localizations.dart';
import 'package:canecare/models/disease_info.dart';

void main() {
  group('Multilingual Content & Localization Tests', () {
    test('All 6 sugarcane diseases have comprehensive Marathi, Hindi & English content', () {
      final diseases = DiseaseInfo.getSugarcaneDiseases();
      expect(diseases.length, 6);

      for (final disease in diseases) {
        // English verification
        expect(disease.getLocalizedName(AppLanguage.english).isNotEmpty, isTrue);
        expect(disease.getLocalizedOverview(AppLanguage.english).isNotEmpty, isTrue);
        expect(disease.getLocalizedSymptoms(AppLanguage.english).isNotEmpty, isTrue);
        expect(disease.getLocalizedCauses(AppLanguage.english).isNotEmpty, isTrue);
        expect(disease.treatment.getCulturalPractices(AppLanguage.english).isNotEmpty, isTrue);
        expect(disease.treatment.getOrganicMeasures(AppLanguage.english).isNotEmpty, isTrue);
        expect(disease.treatment.getPreventiveSteps(AppLanguage.english).isNotEmpty, isTrue);

        // Marathi verification
        final marathiName = disease.getLocalizedName(AppLanguage.marathi);
        final marathiOverview = disease.getLocalizedOverview(AppLanguage.marathi);
        final marathiSymptoms = disease.getLocalizedSymptoms(AppLanguage.marathi);
        final marathiCauses = disease.getLocalizedCauses(AppLanguage.marathi);
        final marathiCultural = disease.treatment.getCulturalPractices(AppLanguage.marathi);
        final marathiOrganic = disease.treatment.getOrganicMeasures(AppLanguage.marathi);
        final marathiPreventive = disease.treatment.getPreventiveSteps(AppLanguage.marathi);

        expect(marathiName.isNotEmpty, isTrue, reason: 'Marathi name missing for ${disease.name}');
        expect(marathiOverview.isNotEmpty, isTrue, reason: 'Marathi overview missing for ${disease.name}');
        expect(marathiSymptoms.isNotEmpty, isTrue, reason: 'Marathi symptoms missing for ${disease.name}');
        expect(marathiCauses.isNotEmpty, isTrue, reason: 'Marathi causes missing for ${disease.name}');
        expect(marathiCultural.isNotEmpty, isTrue, reason: 'Marathi cultural practices missing for ${disease.name}');
        expect(marathiOrganic.isNotEmpty, isTrue, reason: 'Marathi organic measures missing for ${disease.name}');
        expect(marathiPreventive.isNotEmpty, isTrue, reason: 'Marathi preventive steps missing for ${disease.name}');

        // Hindi verification
        final hindiName = disease.getLocalizedName(AppLanguage.hindi);
        final hindiOverview = disease.getLocalizedOverview(AppLanguage.hindi);
        final hindiSymptoms = disease.getLocalizedSymptoms(AppLanguage.hindi);
        final hindiCauses = disease.getLocalizedCauses(AppLanguage.hindi);
        final hindiCultural = disease.treatment.getCulturalPractices(AppLanguage.hindi);
        final hindiOrganic = disease.treatment.getOrganicMeasures(AppLanguage.hindi);
        final hindiPreventive = disease.treatment.getPreventiveSteps(AppLanguage.hindi);

        expect(hindiName.isNotEmpty, isTrue, reason: 'Hindi name missing for ${disease.name}');
        expect(hindiOverview.isNotEmpty, isTrue, reason: 'Hindi overview missing for ${disease.name}');
        expect(hindiSymptoms.isNotEmpty, isTrue, reason: 'Hindi symptoms missing for ${disease.name}');
        expect(hindiCauses.isNotEmpty, isTrue, reason: 'Hindi causes missing for ${disease.name}');
        expect(hindiCultural.isNotEmpty, isTrue, reason: 'Hindi cultural practices missing for ${disease.name}');
        expect(hindiOrganic.isNotEmpty, isTrue, reason: 'Hindi organic measures missing for ${disease.name}');
        expect(hindiPreventive.isNotEmpty, isTrue, reason: 'Hindi preventive steps missing for ${disease.name}');
      }
    });

    test('AppLocalizations dictionary translates accurately across English, Marathi, Hindi', () {
      final locEn = AppLocalizations(AppLanguage.english);
      final locMr = AppLocalizations(AppLanguage.marathi);
      final locHi = AppLocalizations(AppLanguage.hindi);

      expect(locEn.translate('section_overview'), 'Overview');
      expect(locMr.translate('section_overview'), 'तपशील आणि ओळख');
      expect(locHi.translate('section_overview'), 'विवरण और पहचान');

      expect(locEn.translate('section_symptoms'), 'Common Symptoms');
      expect(locMr.translate('section_symptoms'), 'मुख्य लक्षणे');
      expect(locHi.translate('section_symptoms'), 'प्रमुख लक्षण');

      expect(locEn.translate('tab_treatment'), 'Treatment');
      expect(locMr.translate('tab_treatment'), 'उपाययोजना');
      expect(locHi.translate('tab_treatment'), 'उपचार');

      expect(locEn.translate('tab_prevention'), 'Prevention');
      expect(locMr.translate('tab_prevention'), 'प्रतिबंध');
      expect(locHi.translate('tab_prevention'), 'रोकथाम');

      expect(locEn.translate('cultural_practices'), 'Cultural Practices');
      expect(locMr.translate('cultural_practices'), 'मशागतीचे उपाय');
      expect(locHi.translate('cultural_practices'), 'कृषि कार्य व प्रबंधन');

      expect(locEn.translate('organic_measures'), 'Organic & Bio-Control');
      expect(locMr.translate('organic_measures'), 'जैविक व सेंद्रिय नियंत्रण');
      expect(locHi.translate('organic_measures'), 'जैविक नियंत्रण');

      expect(locEn.translate('profile_title'), 'Profile');
      expect(locMr.translate('profile_title'), 'प्रोफाइल');
      expect(locHi.translate('profile_title'), 'प्रोफ़ाइल');
    });
  });
}
