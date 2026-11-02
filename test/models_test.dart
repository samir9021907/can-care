import 'package:flutter_test/flutter_test.dart';
import 'package:canecare/models/disease_info.dart';
import 'package:canecare/models/prediction_result.dart';
import 'package:canecare/models/crop_tip.dart';
import 'package:canecare/localization/app_localizations.dart';

void main() {
  group('CaneCare Models and Localization Tests', () {
    test('Sugarcane disease list contains required conditions', () {
      final diseases = DiseaseInfo.getSugarcaneDiseases();
      expect(diseases.length, greaterThanOrEqualTo(6));

      final names = diseases.map((d) => d.name).toList();
      expect(names, contains('Healthy Sugarcane'));
      expect(names, contains('Red Rot'));
      expect(names, contains('Sugarcane Rust'));
      expect(names, contains('Yellow Leaf Disease (YLD)'));
      expect(names, contains('Sugarcane Mosaic'));
      expect(names, contains('Sugarcane Smut'));
    });

    test('PredictionResult correctly computes confidence percentage', () {
      final diseases = DiseaseInfo.getSugarcaneDiseases();
      final prediction = PredictionResult.fromDisease(
        diseases[1], // Red Rot
        confidence: 0.942,
      );

      expect(prediction.confidencePercentage, '94.2%');
      expect(prediction.isDemo, isTrue);
      expect(prediction.severity, DiseaseSeverity.critical);
    });

    test('Sugarcane crop tips contain essential management topics', () {
      final tips = CropTip.getTips();
      expect(tips.length, 6);

      final categories = tips.map((t) => t.category).toList();
      expect(categories, contains('Surveillance'));
      expect(categories, contains('Water Management'));
      expect(categories, contains('Planting Stock'));
      expect(categories, contains('Sanitation'));
      expect(categories, contains('Integrated Care'));
      expect(categories, contains('Expert Network'));
    });

    test('Localizations support English, Marathi, and Hindi translations', () {
      final en = AppLocalizations(AppLanguage.english);
      final mr = AppLocalizations(AppLanguage.marathi);
      final hi = AppLocalizations(AppLanguage.hindi);

      expect(en.translate('app_name'), 'CaneCare AI');
      expect(mr.translate('app_name'), 'केनकेअर एआय');
      expect(hi.translate('app_name'), 'केनकेयर एआई');

      expect(en.translate('greeting_farmer'), 'Namaste, Farmer!');
      expect(mr.translate('greeting_farmer'), 'नमस्ते, शेतकरी मित्र!');
      expect(hi.translate('greeting_farmer'), 'नमस्ते, किसान भाई!');
    });
  });
}
