import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/scan_provider.dart';
import '../services/prediction_service.dart';
import '../widgets/scanning_indicator.dart';
import '../widgets/error_state_view.dart';
import 'disease_result_screen.dart';

class AiAnalyzingScreen extends StatefulWidget {
  const AiAnalyzingScreen({super.key});

  @override
  State<AiAnalyzingScreen> createState() => _AiAnalyzingScreenState();
}

class _AiAnalyzingScreenState extends State<AiAnalyzingScreen> {
  double _progress = 0.15;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runAnalysis();
    });
  }

  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) return;
      setState(() {
        if (_progress < 0.65) {
          _progress += 0.05;
        } else if (_progress < 0.95) {
          _progress += 0.02;
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _runAnalysis() async {
    final scan = context.read<ScanProvider>();
    await scan.startAnalysis();

    if (!mounted) return;
    _progressTimer?.cancel();

    if (scan.predictionResult != null) {
      setState(() {
        _progress = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DiseaseResultScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<ScanProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Simulation Selector Menu for testing states
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            tooltip: 'Simulate Prediction Modes',
            onSelected: (val) {
              if (val == 'no_internet') {
                scan.setSimulatedFailure(DemoPredictionFailure.noInternet);
              } else if (val == 'model_offline') {
                scan.setSimulatedFailure(DemoPredictionFailure.modelUnavailable);
              } else if (val == 'low_confidence') {
                scan.setSimulatedFailure(DemoPredictionFailure.lowConfidence);
              } else if (val == 'unsupported_crop') {
                scan.setSimulatedFailure(DemoPredictionFailure.unsupportedCrop);
              } else if (val == 'failed') {
                scan.setSimulatedFailure(DemoPredictionFailure.analysisFailed);
              } else {
                scan.setSimulatedFailure(DemoPredictionFailure.none);
                scan.setSelectedSimulationDisease(val);
              }
              _progress = 0.15;
              _startProgressAnimation();
              _runAnalysis();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'red_rot',
                child: Text('Normal: Red Rot (Figma Screen 8)'),
              ),
              const PopupMenuItem(
                value: 'rust',
                child: Text('Normal: Sugarcane Rust'),
              ),
              const PopupMenuItem(
                value: 'yellow_leaf',
                child: Text('Normal: Yellow Leaf Disease'),
              ),
              const PopupMenuItem(
                value: 'healthy',
                child: Text('Normal: Healthy Sugarcane'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'low_confidence',
                child: Text('Edge State: Low Confidence'),
              ),
              const PopupMenuItem(
                value: 'no_internet',
                child: Text('Edge State: No Internet'),
              ),
              const PopupMenuItem(
                value: 'failed',
                child: Text('Edge State: Analysis Failed'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: scan.analysisError != null
            ? ErrorStateView(
                category: scan.simulatedFailure == DemoPredictionFailure.noInternet
                    ? ErrorCategory.noInternet
                    : scan.simulatedFailure == DemoPredictionFailure.modelUnavailable
                        ? ErrorCategory.serverUnavailable
                        : ErrorCategory.unexpected,
                customMessage: scan.analysisError,
                onRetry: () {
                  scan.setSimulatedFailure(DemoPredictionFailure.none);
                  _progress = 0.15;
                  _startProgressAnimation();
                  _runAnalysis();
                },
                retryButtonText: 'Try Again',
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 24),
                  child: ScanningIndicator(
                    imagePath: scan.imagePath,
                    currentStatusMessage: scan.analysisStatusMessage,
                    progress: _progress,
                  ),
                ),
              ),
      ),
    );
  }
}
