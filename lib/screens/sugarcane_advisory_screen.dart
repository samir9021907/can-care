import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_localizations.dart';
import '../services/advisory_service.dart';
import '../widgets/primary_button.dart';
import 'ask_question_screen.dart';
import 'advisory_category_detail_screen.dart';

/// Screen 2: Sugarcane Advisory matching the reference image (Phone 2)
class SugarcaneAdvisoryScreen extends StatefulWidget {
  const SugarcaneAdvisoryScreen({super.key});

  @override
  State<SugarcaneAdvisoryScreen> createState() => _SugarcaneAdvisoryScreenState();
}

class _SugarcaneAdvisoryScreenState extends State<SugarcaneAdvisoryScreen> {
  int _selectedTabIndex = 0; // 0: 'माझे प्रश्न', 1: 'सर्व प्रश्न'
  final AdvisoryService _advisoryService = AdvisoryService();

  @override
  void initState() {
    super.initState();
    _advisoryService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _advisoryService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _openAskQuestion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AskQuestionScreen()),
    );
    if (result == true && mounted) {
      setState(() => _selectedTabIndex = 0); // Switch to My Questions
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.translate('advisory_screen_title'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14451D),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Category Tab Switcher Pill matching Right Phone in Image 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF5E5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCE8D4)),
                ),
                child: Row(
                  children: [
                    // Tab 1: "माझे प्रश्न" (My Questions)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? const Color(0xFF14532D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedTabIndex == 0
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF14532D)
                                          .withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            loc.translate('tab_my_questions'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _selectedTabIndex == 0
                                  ? Colors.white
                                  : const Color(0xFF2C3E30),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tab 2: "सर्व प्रश्न" (All Questions)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? const Color(0xFF14532D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedTabIndex == 1
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF14532D)
                                          .withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            loc.translate('tab_all_questions'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _selectedTabIndex == 1
                                  ? Colors.white
                                  : const Color(0xFF2C3E30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content Area
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildMyQuestionsTab(loc)
                  : _buildAllQuestionsTab(loc),
            ),

            // Bottom Green Button: "नवीन प्रश्न विचारा" (Ask a New Question)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: PrimaryButton(
                text: loc.translate('ask_new_question'),
                onPressed: _openAskQuestion,
                backgroundColor: const Color(0xFF14532D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. My Questions Tab
  Widget _buildMyQuestionsTab(AppLocalizations loc) {
    final myQuestions = _advisoryService.myQuestions;

    if (myQuestions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_answer_rounded,
                  color: AppColors.primary,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                loc.translate('no_questions_yet'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                loc.translate('ask_first_prompt'),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A7262),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      itemCount: myQuestions.length,
      itemBuilder: (context, index) {
        final q = myQuestions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      q.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    '${q.createdAt.day}/${q.createdAt.month}/${q.createdAt.year}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8FA395),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                q.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                q.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A7262),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFFF57F17)),
                  const SizedBox(width: 6),
                  Text(
                    q.status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF57F17),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. All Questions & Categories Tab matching Right Phone in Image 1
  Widget _buildAllQuestionsTab(AppLocalizations loc) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      children: [
        // 4 Advisory Category Cards
        ..._advisoryService.categories.map((cat) {
          return _buildAdvisoryCategoryCard(cat, loc);
        }),

        const SizedBox(height: 16),

        // Community Farmer Questions
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'शेतकऱ्यांनी विचारलेले प्रश्न (Farmer Queries & Answers)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14451D),
            ),
          ),
        ),

        ..._advisoryService.allQuestions.map((q) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2EBE0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        q.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      q.status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  q.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  q.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5A7262),
                  ),
                ),
                if (q.expertAnswer != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            q.expertAnswer!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF14532D),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAdvisoryCategoryCard(
      AdvisoryCategory cat, AppLocalizations loc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2EBE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdvisoryCategoryDetailScreen(category: cat),
              ),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Circular mint-green badge with icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC8E6C9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      cat.icon,
                      color: const Color(0xFF14532D),
                      size: 26,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.translate(cat.titleKey),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        loc.translate(cat.subtitleKey),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5A7262),
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing green arrow matching reference image
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF1E88E5),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
