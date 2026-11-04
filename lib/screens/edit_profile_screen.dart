import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/farmer_avatar_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _villageController;
  late TextEditingController _farmSizeController;

  String? _selectedAvatarPath;
  String _selectedDistrict = 'अहिल्यानगर';
  String _selectedVariety = 'Co 86032 (निरा)';
  String _selectedIrrigation = 'ठिबक सिंचन (Drip)';
  String _selectedSeason = 'सुरू हंगाम (Suru)';
  bool _isSaving = false;

  static const List<String> maharashtraDistricts = [
    'अहिल्यानगर',
    'कोल्हापूर',
    'सांगली',
    'सातारा',
    'पुणे',
    'सोलापूर',
    'नाशिक',
    'बीड',
    'धाराशिव (उस्मानाबाद)',
    'जालना',
    'छत्रपती संभाजीनगर',
    'नांदेड',
    'परभणी',
    'लातूर',
    'इतर (Other)',
  ];

  static const List<String> sugarcaneVarieties = [
    'Co 86032 (निरा / नयना)',
    'CoM 0265 (फुले २६५)',
    'Co 92005',
    'VSI 08005',
    'Co 09037',
    'MS 10001',
    'इतर जात (Other)',
  ];

  static const List<String> irrigationMethods = [
    'ठिबक सिंचन (Drip)',
    'पाटपाणी (Flood)',
    'तुषार सिंचन (Sprinkler)',
  ];

  static const List<String> plantingSeasons = [
    'सुरू हंगाम (Suru)',
    'पूर्व हंगामी (Pre-seasonal)',
    'अडसाली (Adsali)',
    'खोडवा (Ratoon)',
  ];

  static const List<String> quickFarmSizes = [
    '१ एकर',
    '२.५ एकर',
    '३.५ एकर',
    '५ एकर',
    '१० एकर',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(
      text: (user?.phone ?? '').replaceAll('+91', '').trim(),
    );
    _emailController = TextEditingController(text: user?.email ?? '');
    _villageController = TextEditingController(text: user?.village ?? 'कोपरगाव');
    _farmSizeController = TextEditingController(text: user?.farmSize ?? '३.५ एकर');

    _selectedAvatarPath = user?.avatarPath ?? 'avatar_farmer_pheta';

    // Match district
    final currentRegion = user?.region ?? '';
    for (final dist in maharashtraDistricts) {
      if (currentRegion.contains(dist) || dist.contains(currentRegion)) {
        _selectedDistrict = dist;
        break;
      }
    }

    if (user?.sugarcaneVariety != null && user!.sugarcaneVariety!.isNotEmpty) {
      _selectedVariety = user.sugarcaneVariety!;
    }
    if (user?.irrigationType != null && user!.irrigationType!.isNotEmpty) {
      _selectedIrrigation = user.irrigationType!;
    }
    if (user?.plantingSeason != null && user!.plantingSeason!.isNotEmpty) {
      _selectedSeason = user.plantingSeason!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _villageController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedAvatarPath = picked.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('फोटो निवडण्यात त्रुटी: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _showAvatarPresetPicker() {
    Navigator.pop(context);
    final loc = AppLocalizations.of(context);
    final langCode = context.read<LocaleProvider>().currentLanguage.code;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.translate('source_avatar'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: FarmerAvatarWidget.presets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final preset = FarmerAvatarWidget.presets[index];
                    final isSelected = _selectedAvatarPath == preset.key;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAvatarPath = preset.key;
                        });
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFDCFCE7) : const Color(0xFFF8FAF7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF16A34A) : const Color(0xFFE2EBE0),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: preset.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                preset.icon,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              preset.displayName(langCode),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? const Color(0xFF14532D) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPhotoPickerSheet() {
    final loc = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pill handle
                Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  loc.translate('choose_photo_source'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.translate('choose_photo_source_sub'),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 18),

                // Option 1: Camera
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  color: const Color(0xFF16A34A),
                  title: loc.translate('source_camera'),
                  onTap: () => _pickImage(ImageSource.camera),
                ),

                // Option 2: Gallery
                _buildPickerOption(
                  icon: Icons.photo_library_rounded,
                  color: const Color(0xFF0288D1),
                  title: loc.translate('source_gallery'),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),

                // Option 3: Farmer Avatars
                _buildPickerOption(
                  icon: Icons.face_retouching_natural_rounded,
                  color: const Color(0xFFE65100),
                  title: loc.translate('source_avatar'),
                  onTap: _showAvatarPresetPicker,
                ),

                // Option 4: Remove photo if exists
                if (_selectedAvatarPath != null)
                  _buildPickerOption(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFDC2626),
                    title: loc.translate('remove_photo'),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _selectedAvatarPath = null;
                      });
                    },
                  ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF94A3B8),
        size: 20,
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final fullName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final village = _villageController.text.trim();
    final farmSize = _farmSizeController.text.trim();
    final region = '$_selectedDistrict, महाराष्ट्र';

    context.read<AuthProvider>().updateFarmerProfile(
          fullName: fullName,
          email: email,
          phone: phone,
          region: region,
          village: village,
          avatarPath: _selectedAvatarPath,
          farmSize: farmSize,
          sugarcaneVariety: _selectedVariety,
          irrigationType: _selectedIrrigation,
          plantingSeason: _selectedSeason,
        );

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                loc.translate('profile_saved_success'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1B5E20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        title: Text(
          loc.translate('edit_profile_title'),
          style: const TextStyle(
            color: Color(0xFF14532D),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAF7),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14532D)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: _isSaving ? null : _handleSave,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF16A34A),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(
                loc.translate('save_profile_changes'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Interactive Farmer Avatar Header
                Center(
                  child: Column(
                    children: [
                      FarmerAvatarWidget(
                        avatarPath: _selectedAvatarPath,
                        fullName: _nameController.text,
                        size: 96,
                        showCameraBadge: true,
                        onTap: _showPhotoPickerSheet,
                        onCameraTap: _showPhotoPickerSheet,
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: _showPhotoPickerSheet,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo_camera_rounded,
                                size: 15,
                                color: Color(0xFF16A34A),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                loc.translate('change_photo_prompt'),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Personal Information Card
                _buildSectionCard(
                  title: loc.translate('personal_info_section'),
                  icon: Icons.badge_outlined,
                  children: [
                    // Full Name
                    _buildInputField(
                      label: loc.translate('field_full_name'),
                      hint: 'उदा. समीर रहाणे',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? loc.translate('name_required_error') : null,
                    ),
                    const SizedBox(height: 14),

                    // Mobile Number
                    _buildInputField(
                      label: loc.translate('field_mobile_number'),
                      hint: '9021590368',
                      controller: _phoneController,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      prefixText: '+91 ',
                      suffixWidget: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 13, color: Color(0xFF16A34A)),
                            SizedBox(width: 3),
                            Text(
                              'सत्यापित',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().length < 10) {
                          return loc.translate('phone_invalid_error');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Email Address
                    _buildInputField(
                      label: loc.translate('field_email_address'),
                      hint: 'samir.farmer@gmail.com',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v != null && v.isNotEmpty && !v.contains('@')) {
                          return 'योग्य ईमेल आयडी टाका';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Farm & Location Details Card
                _buildSectionCard(
                  title: loc.translate('farming_info_section'),
                  icon: Icons.location_on_outlined,
                  children: [
                    // District Dropdown
                    _buildDropdownField<String>(
                      label: loc.translate('field_district_region'),
                      prefixIcon: Icons.map_outlined,
                      value: _selectedDistrict,
                      items: maharashtraDistricts,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedDistrict = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Village / Taluka
                    _buildInputField(
                      label: loc.translate('field_village_taluka'),
                      hint: 'उदा. कोपरगाव / शिर्डी / संगमनेर',
                      controller: _villageController,
                      prefixIcon: Icons.home_work_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Sugarcane Crop Details Card
                _buildSectionCard(
                  title: loc.translate('crop_info_section'),
                  icon: Icons.eco_outlined,
                  children: [
                    // Farm Size / Sugarcane Area
                    _buildInputField(
                      label: loc.translate('field_sugarcane_area'),
                      hint: 'उदा. ३.५ एकर',
                      controller: _farmSizeController,
                      prefixIcon: Icons.landscape_outlined,
                    ),
                    const SizedBox(height: 8),

                    // Quick Area Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: quickFarmSizes.map((chipText) {
                          final isSelected = _farmSizeController.text == chipText;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(chipText),
                              selected: isSelected,
                              selectedColor: const Color(0xFFDCFCE7),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? const Color(0xFF15803D) : const Color(0xFF475569),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1),
                                ),
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _farmSizeController.text = chipText;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Sugarcane Variety Dropdown
                    _buildDropdownField<String>(
                      label: loc.translate('field_cane_variety'),
                      prefixIcon: Icons.grass_rounded,
                      value: _selectedVariety,
                      items: sugarcaneVarieties,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedVariety = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Irrigation Method Dropdown
                    _buildDropdownField<String>(
                      label: loc.translate('field_irrigation_type'),
                      prefixIcon: Icons.water_drop_outlined,
                      value: _selectedIrrigation,
                      items: irrigationMethods,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedIrrigation = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Planting Season Dropdown
                    _buildDropdownField<String>(
                      label: loc.translate('field_planting_season'),
                      prefixIcon: Icons.calendar_month_outlined,
                      value: _selectedSeason,
                      items: plantingSeasons,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedSeason = val);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // Fixed Bottom Save Button
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF15803D),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_rounded, size: 22),
              label: Text(
                _isSaving ? 'जतन करत आहे...' : loc.translate('save_profile_changes'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2EBE0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF16A34A)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14532D),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    Widget? suffixWidget,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF16A34A), size: 20),
            suffixIcon: suffixWidget != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [suffixWidget],
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF8FAF7),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2EBE0), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData prefixIcon,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2EBE0), width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF16A34A)),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(prefixIcon, color: const Color(0xFF16A34A), size: 19),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          item.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

