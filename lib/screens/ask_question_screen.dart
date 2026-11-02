import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_localizations.dart';
import '../services/advisory_service.dart';
import '../widgets/primary_button.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'ऊस पिकातील रोग';

  String? _titleError;
  String? _descError;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'ऊस पिकातील रोग',
    'खत व्यवस्थापन',
    'पाणी व्यवस्थापन',
    'सामान्य प्रश्न',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    setState(() {
      _titleError = title.isEmpty ? 'कृपया प्रश्नाचे शीर्षक लिहा' : null;
      _descError = desc.isEmpty ? 'कृपया समस्येचे सविस्तर वर्णन लिहा' : null;
    });

    if (_titleError != null || _descError != null) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    AdvisoryService().addQuestion(
      title: title,
      description: desc,
      category: _selectedCategory,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.translate('question_submitted_success')),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.translate('ask_new_question'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14451D),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Picker
              Text(
                loc.translate('question_cat_label'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF2C3E30),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : const Color(0xFFD4DEC9),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Title Field
              Text(
                loc.translate('question_title_label'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: loc.translate('question_title_hint'),
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A89A)),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _titleError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD4DEC9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD4DEC9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                  ),
                ),
                onChanged: (_) {
                  if (_titleError != null) setState(() => _titleError = null);
                },
              ),

              const SizedBox(height: 20),

              // Description Field
              Text(
                loc.translate('question_desc_label'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 5,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: loc.translate('question_desc_hint'),
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A89A)),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _descError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD4DEC9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD4DEC9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                  ),
                ),
                onChanged: (_) {
                  if (_descError != null) setState(() => _descError = null);
                },
              ),

              const SizedBox(height: 28),

              // Submit Button
              PrimaryButton(
                text: loc.translate('submit_question'),
                onPressed: _onSubmit,
                isLoading: _isSubmitting,
                trailingIcon: Icons.send_rounded,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
