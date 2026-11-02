import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../services/image_service.dart';
import '../services/permission_service.dart';
import '../widgets/error_state_view.dart';
import '../localization/app_localizations.dart';
import 'image_preview_screen.dart';

class ScanCameraScreen extends StatefulWidget {
  final bool openGalleryDirectly;

  const ScanCameraScreen({super.key, this.openGalleryDirectly = false});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitializing = true;
  bool _isCameraReady = false;
  bool _isCapturing = false;
  String? _cameraErrorMessage;

  // Scanning laser animation that moves up and down the viewfinder frame
  late AnimationController _laserAnimController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _laserAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _laserAnimController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.openGalleryDirectly) {
        _handleGalleryPick();
      } else {
        _initCamera();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      _cameraController = null;
      if (mounted) {
        setState(() {
          _isCameraReady = false;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _laserAnimController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    if (!mounted) return;
    setState(() {
      _isCameraInitializing = true;
      _cameraErrorMessage = null;
    });

    try {
      final isGranted = await PermissionService.instance.isCameraGranted();
      if (!mounted) return;
      if (!isGranted) {
        final granted =
            await PermissionService.instance.askCameraPermissionAtStart(context);
        if (!mounted) return;
        final scan = context.read<ScanProvider>();
        scan.setCameraPermission(
          granted
              ? CameraPermissionStatus.granted
              : CameraPermissionStatus.denied,
        );
        if (!granted) {
          setState(() {
            _isCameraInitializing = false;
            _isCameraReady = false;
          });
          return;
        }
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isCameraInitializing = false;
          _isCameraReady = false;
          _cameraErrorMessage = 'No camera hardware detected on device';
        });
        return;
      }

      // Default to rear-facing camera for crop disease scanning
      int rearIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      _selectedCameraIndex = (rearIndex != -1) ? rearIndex : 0;

      await _setupCameraController(_cameras[_selectedCameraIndex]);
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (!mounted) return;
      setState(() {
        _isCameraInitializing = false;
        _isCameraReady = false;
        _cameraErrorMessage = e.toString();
      });
    }
  }

  Future<void> _setupCameraController(CameraDescription camera) async {
    final previousController = _cameraController;
    if (previousController != null) {
      _cameraController = null;
      await previousController.dispose();
    }

    final newController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await newController.initialize();
      if (!mounted) {
        await newController.dispose();
        return;
      }

      final scan = context.read<ScanProvider>();
      try {
        if (scan.isFlashOn) {
          await newController.setFlashMode(FlashMode.torch);
        } else {
          await newController.setFlashMode(FlashMode.off);
        }
      } catch (_) {}

      setState(() {
        _cameraController = newController;
        _isCameraReady = true;
        _isCameraInitializing = false;
        _cameraErrorMessage = null;
      });
    } catch (e) {
      debugPrint('Error starting camera controller: $e');
      if (!mounted) return;
      setState(() {
        _isCameraInitializing = false;
        _isCameraReady = false;
        _cameraErrorMessage = e.toString();
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isCameraInitializing) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _setupCameraController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _toggleFlash() async {
    final scan = context.read<ScanProvider>();
    scan.toggleFlash();
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.setFlashMode(
          scan.isFlashOn ? FlashMode.torch : FlashMode.off,
        );
      } catch (e) {
        debugPrint('Flash toggle error: $e');
      }
    }
  }

  Future<void> _handleCapture() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final scan = context.read<ScanProvider>();

      if (_cameraController != null && _cameraController!.value.isInitialized) {
        final XFile file = await _cameraController!.takePicture();
        if (mounted) {
          await scan.onImageCaptured(file);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImagePreviewScreen()),
            );
          }
        }
      } else {
        // Fallback to native system camera app via ImagePicker
        await scan.captureImage();
        if (scan.selectedImage != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImagePreviewScreen()),
          );
        }
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      // Secondary fallback to standard image capture pipeline
      if (mounted) {
        final scan = context.read<ScanProvider>();
        await scan.captureImage();
        if (scan.selectedImage != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImagePreviewScreen()),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  void _handleGalleryPick() async {
    final scan = context.read<ScanProvider>();
    await scan.pickFromGallery();

    if (scan.selectedImage != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ImagePreviewScreen()),
      );
    }
  }

  void _handleDemoState(ImageValidationResult result) async {
    final scan = context.read<ScanProvider>();
    await scan.setDemoLeafImage(
      'assets/images/leaf_in_viewfinder.png',
      validation: result,
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ImagePreviewScreen()),
      );
    }
  }

  Future<void> _handleTapToFocus(
      TapUpDetails details, BoxConstraints constraints) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final offset = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight,
      );
      await _cameraController!.setFocusPoint(offset);
      await _cameraController!.setExposurePoint(offset);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<ScanProvider>();
    final loc = AppLocalizations.of(context);

    if (scan.cameraPermission == CameraPermissionStatus.denied) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7FAF5),
        appBar: AppBar(
          title: const Text('Camera Access'),
          backgroundColor: const Color(0xFFF7FAF5),
          elevation: 0,
        ),
        body: ErrorStateView(
          category: ErrorCategory.permissionDenied,
          onRetry: () async {
            final granted =
                await PermissionService.instance.requestCameraPermission();
            if (granted) {
              scan.setCameraPermission(CameraPermissionStatus.granted);
              _initCamera();
            } else {
              try {
                await openAppSettings();
              } catch (_) {}
            }
          },
          retryButtonText: 'Grant Permission',
        ),
      );
    }

    if (scan.cameraPermission == CameraPermissionStatus.initializationFailed) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7FAF5),
        appBar: AppBar(
          title: const Text('Camera Error'),
          backgroundColor: const Color(0xFFF7FAF5),
          elevation: 0,
        ),
        body: ErrorStateView(
          category: ErrorCategory.unexpected,
          customTitle: 'Camera Initialization Failed',
          customMessage:
              'Camera hardware was busy or unavailable. You can use gallery selection instead.',
          onRetry: () {
            scan.setCameraPermission(CameraPermissionStatus.granted);
            _handleGalleryPick();
          },
          retryButtonText: 'Upload from Gallery',
        ),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final reticleWidth = math.min(290.0, size.width * 0.78);
    final reticleHeight = math.min(380.0, size.height * 0.48);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Live Camera Feed OR Clean Dark Viewfinder (No fake leaf photo)
          if (_isCameraReady &&
              _cameraController != null &&
              _cameraController!.value.isInitialized)
            GestureDetector(
              onTapUp: (details) => _handleTapToFocus(
                details,
                BoxConstraints(maxWidth: size.width, maxHeight: size.height),
              ),
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController!.value.previewSize?.height ??
                        size.width,
                    height: _cameraController!.value.previewSize?.width ??
                        size.height,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _handleCapture,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.15,
                    colors: [
                      Color(0xFF142417),
                      Color(0xFF0B140D),
                      Color(0xFF050806),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isCameraInitializing) ...[
                        const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFF81C784)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Starting Live Camera...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFF2E7D32), width: 1.2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera_alt_rounded,
                                  color: Color(0xFF81C784), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _cameraErrorMessage ??
                                    loc.translate('tap_shutter_hint'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // 2. Subtle Dark Translucent Vignette for control readability
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  stops: const [0.0, 0.22, 0.72, 1.0],
                ),
              ),
            ),
          ),

          // 3. Center Viewfinder Reticle with Scanning Laser Line
          Center(
            child: Container(
              width: reticleWidth,
              height: reticleHeight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.85),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Animated Scanning Laser Bar
                    AnimatedBuilder(
                      animation: _laserAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: reticleHeight * _laserAnimation.value,
                          left: 6,
                          right: 6,
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4CAF50)
                                      .withValues(alpha: 0.85),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF81C784),
                                  Colors.white,
                                  Color(0xFF81C784),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Viewfinder 4 Corner Bracket Icons
                    const Positioned(
                      top: 10,
                      left: 10,
                      child:
                          Icon(Icons.crop_free, color: Colors.white, size: 28),
                    ),
                    const Positioned(
                      top: 10,
                      right: 10,
                      child:
                          Icon(Icons.crop_free, color: Colors.white, size: 28),
                    ),
                    const Positioned(
                      bottom: 10,
                      left: 10,
                      child:
                          Icon(Icons.crop_free, color: Colors.white, size: 28),
                    ),
                    const Positioned(
                      bottom: 10,
                      right: 10,
                      child:
                          Icon(Icons.crop_free, color: Colors.white, size: 28),
                    ),

                    // Subtle Leaf Alignment Guide in Center
                    Center(
                      child: Icon(
                        Icons.eco_outlined,
                        size: 46,
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Top Instruction Banner matching Screen 5
          Positioned(
            top: 75,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEDC8).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco_rounded, color: Color(0xFF1B5E20), size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        loc.translate('camera_instruction'),
                        style: const TextStyle(
                          color: Color(0xFF1B5E20),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 5. Safe Top Back Button, Flash Button, and Camera Flip
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // Top Action Icons
                    Row(
                      children: [
                        // Camera switch if front and back exist
                        if (_cameras.length > 1) ...[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.flip_camera_ios_rounded,
                                  color: Colors.white, size: 20),
                              tooltip: 'Switch Camera',
                              onPressed: _switchCamera,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Flash Toggle Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.bolt_rounded,
                              color: scan.isFlashOn
                                  ? const Color(0xFFFFD600)
                                  : Colors.white,
                              size: 22,
                            ),
                            onPressed: _toggleFlash,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Simulation mode triggers dropdown
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.tune_rounded,
                                color: Colors.white, size: 20),
                            tooltip: 'Simulate Leaf Errors',
                            onSelected: (val) {
                              if (val == 'blurry') {
                                _handleDemoState(
                                    ImageValidationResult.blurryImage);
                              } else if (val == 'wrong_crop') {
                                _handleDemoState(
                                    ImageValidationResult.wrongCropNotSugarcane);
                              } else if (val == 'no_leaf') {
                                _handleDemoState(
                                    ImageValidationResult.noLeafDetected);
                              } else if (val == 'too_large') {
                                _handleDemoState(
                                    ImageValidationResult.imageTooLarge);
                              } else {
                                _handleDemoState(ImageValidationResult.valid);
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                  value: 'normal', child: Text('Normal Leaf')),
                              const PopupMenuItem(
                                  value: 'blurry',
                                  child: Text('Blurry Image Warning')),
                              const PopupMenuItem(
                                  value: 'wrong_crop',
                                  child: Text('Wrong Crop (Not Sugarcane)')),
                              const PopupMenuItem(
                                  value: 'no_leaf',
                                  child: Text('No Leaf Detected')),
                              const PopupMenuItem(
                                  value: 'too_large',
                                  child: Text('File Too Large (>10MB)')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 6. White Flash Shutter Feedback Overlay
          if (_isCapturing)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),

          // 7. Bottom Controls matching Screen 5: Gallery on Left, Shutter in Middle, Flash on Right
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 36, 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gallery Button with icon and label "Gallery"
                    GestureDetector(
                      onTap: _handleGalleryPick,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white38),
                            ),
                            child: const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            loc.translate('gallery'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // White Circular Shutter Button
                    GestureDetector(
                      onTap: _handleCapture,
                      child: Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4.5),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isCapturing
                                ? const Color(0xFFC8E6C9)
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _isCapturing
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Color(0xFF2E7D32)),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),

                    // Flash Toggle Bolt Icon
                    GestureDetector(
                      onTap: _toggleFlash,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: scan.isFlashOn
                                  ? const Color(0xFFF9A825)
                                      .withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scan.isFlashOn
                                    ? const Color(0xFFF9A825)
                                    : Colors.white38,
                              ),
                            ),
                            child: Icon(
                              scan.isFlashOn
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                              color: scan.isFlashOn
                                  ? const Color(0xFFF9A825)
                                  : Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            scan.isFlashOn
                                ? loc.translate('flash_on')
                                : loc.translate('flash'),
                            style: TextStyle(
                              color: scan.isFlashOn
                                  ? const Color(0xFFF9A825)
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
