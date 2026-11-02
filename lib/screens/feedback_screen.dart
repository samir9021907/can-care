import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_snackbar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _messageController = TextEditingController();
  String _selectedType = 'Sugarcane Disease Feedback';

  final List<String> _types = [
    'Sugarcane Disease Feedback',
    'Camera / Image Upload Suggestion',
    'Report a Bug / Issue',
    'Regional Translation Correction',
    'General Compliment / Question',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController =
        TextEditingController(text: user?.fullName ?? 'Samir Rahane');
    _emailController =
        TextEditingController(text: user?.email ?? 'samir.farmer@gmail.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final settings = context.read<SettingsProvider>();
      final success = await settings.submitFeedback(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        feedbackType: _selectedType,
        message: _messageController.text.trim(),
      );

      if (success && mounted) {
        AppSnackBar.showSuccess(
          context,
          'Thank you for helping improve CaneCare AI! Your feedback has been received.',
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGreen),
        titleTextStyle: AppTypography.heading3,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help Us Improve CaneCare AI',
                  style: AppTypography.heading2.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your feedback as a sugarcane cultivator directly shapes future AI model training and regional features.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 20),

                // Name Field
                AppTextField(
                  label: 'Your Name',
                  hint: 'Farmer Name',
                  controller: _nameController,
                  isRequired: true,
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),

                // Email Field
                AppTextField(
                  label: 'Email Address',
                  hint: 'farmer@example.com',
                  controller: _emailController,
                  isRequired: true,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Valid email required' : null,
                ),
                const SizedBox(height: 16),

                // Feedback Category Dropdown
                Text(
                  'Feedback Category *',
                  style: AppTypography.titleLarge.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusButton),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedType,
                      items: _types
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t, style: AppTypography.bodyMedium),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedType = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Message Text Area
                Text(
                  'Your Message / Suggestion *',
                  style: AppTypography.titleLarge.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  validator: (v) => v == null || v.trim().length < 5
                      ? 'Please write at least a few words'
                      : null,
                  decoration: InputDecoration(
                    hintText:
                        'Tell us what worked well or what sugarcane features you would like added...',
                    hintStyle: AppTypography.bodySmall
                        .copyWith(color: AppColors.textMuted),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                PrimaryButton(
                  text: 'Submit Feedback',
                  icon: Icons.send_rounded,
                  isLoading: settings.isSubmittingFeedback,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
