import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/history_provider.dart';
import '../models/scan_report.dart';
import '../widgets/history_card.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/error_state_view.dart';
import 'saved_report_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback onNavigateToScan;

  const HistoryScreen({super.key, required this.onNavigateToScan});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadReports();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    context.read<HistoryProvider>().setSearchQuery(val);
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final messenger = ScaffoldMessenger.of(context);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: now,
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF165228),
              onPrimary: Colors.white,
              onSurface: Color(0xFF14451D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!mounted) return;
      setState(() {
        _selectedDateRange = picked;
      });
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Filtered scans from ${picked.start.day}/${picked.start.month} to ${picked.end.day}/${picked.end.month}',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF165228),
        ),
      );
    }
  }

  void _showReportsSummaryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F8EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assessment_outlined,
                    color: Color(0xFF165228),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Monthly Scans Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '• Total Scans Conducted: 12\n'
              '• Healthy Crop Rate: 75% (9 plots safe)\n'
              '• Detected Concerns: Red Rot (1 plot), Rust (1 plot), Yellow Leaf (1 plot)\n'
              '• Trend: Treatment in Plot #2 showing improvement.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF165228),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadPdfReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Sugarcane_Health_Report_April.pdf downloaded!'),
          ],
        ),
        backgroundColor: Color(0xFF165228),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _shareWithExpert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.share_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Share link generated for CaneCare Agronomist!'),
          ],
        ),
        backgroundColor: Color(0xFF165228),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _setFollowUpReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.alarm_on_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Reminder set: Recheck Yellow Leaf Plot #2 in 3 days!'),
          ],
        ),
        backgroundColor: Color(0xFF165228),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final history = context.watch<HistoryProvider>();

    // Calculate dynamic stats
    final totalCount = history.reports.length;
    final healthyCount = history.reports.where((r) => r.isHealthy).length;
    final diseasedCount = history.reports.where((r) => !r.isHealthy).length;

    // Filter reports according to selected date range if any
    List<ScanReport> displayedReports = history.filteredReports;
    if (_selectedDateRange != null) {
      displayedReports = displayedReports.where((r) {
        return r.scanDate.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            r.scanDate.isBefore(
                _selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leadingWidth: 46,
        leading: const Padding(
          padding: EdgeInsets.only(left: 18),
          child: Icon(
            Icons.article_outlined,
            color: Color(0xFF14451D),
            size: 24,
          ),
        ),
        title: Text(
          loc.language == AppLanguage.marathi
              ? 'स्कॅन इतिहास'
              : (loc.language == AppLanguage.hindi
                  ? 'स्कैन इतिहास'
                  : 'Scan History'),
          style: const TextStyle(
            color: Color(0xFF14451D),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF14451D)),
            tooltip: 'Options',
            onSelected: (val) {
              if (val == 'clear') {
                history.clearReports();
              } else if (val == 'restore') {
                history.restoreDemoReports();
              } else if (val == 'download') {
                _downloadPdfReport(context);
              }
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                value: 'restore',
                child: Text('Reload All 12 Scans'),
              ),
              PopupMenuItem(
                value: 'download',
                child: Text('Export PDF Report'),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text('Clear History'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. FILTER PILLS: All (12) | Healthy (9) | Diseased (3)
              // ==========================================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildTopFilterPill(
                      label: 'All ($totalCount)',
                      isSelected: history.currentFilter == HistoryFilter.all,
                      dotColor: null,
                      onTap: () => history.setFilter(HistoryFilter.all),
                    ),
                    const SizedBox(width: 10),
                    _buildTopFilterPill(
                      label: 'Healthy ($healthyCount)',
                      isSelected: history.currentFilter == HistoryFilter.healthy,
                      dotColor: const Color(0xFF009647),
                      onTap: () => history.setFilter(HistoryFilter.healthy),
                    ),
                    const SizedBox(width: 10),
                    _buildTopFilterPill(
                      label: 'Diseased ($diseasedCount)',
                      isSelected: history.currentFilter == HistoryFilter.diseased,
                      dotColor: const Color(0xFFEF4444),
                      onTap: () => history.setFilter(HistoryFilter.diseased),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 2. SUMMARY STAT CARDS (Total | Healthy | Needs Care)
              // ==========================================
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryStatCard(
                      icon: Icons.description_outlined,
                      iconBg: const Color(0xFFE2EBE2),
                      iconColor: const Color(0xFF334155),
                      value: '$totalCount',
                      label: 'Total Scans',
                      valueColor: const Color(0xFF14451D),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSummaryStatCard(
                      icon: Icons.check_rounded,
                      iconBg: const Color(0xFFE8F8EE),
                      iconColor: const Color(0xFF15803D),
                      value: '$healthyCount',
                      label: 'Healthy',
                      valueColor: const Color(0xFF15803D),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSummaryStatCard(
                      icon: Icons.warning_amber_rounded,
                      iconBg: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFEF4444),
                      value: '$diseasedCount',
                      label: 'Needs Care',
                      valueColor: const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 3. SEARCH BAR
              // ==========================================
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2EBE2), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF8FA196),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Search disease or scan date...',
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF8FA196),
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF14451D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF8FA196),
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ==========================================
              // 4. FILTER BY DATE BUTTON & RECENT COUNT
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => _pickDateRange(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF86EFAC),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 13.5,
                                color: Color(0xFF165228),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _selectedDateRange == null
                                    ? 'Filter by date'
                                    : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF165228),
                                ),
                              ),
                              if (_selectedDateRange != null) ...[
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDateRange = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: Color(0xFF165228),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Showing ${displayedReports.length.clamp(0, 4)} recent',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B8074),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ==========================================
              // 5. SCAN HISTORY LIST ITEMS (TOP 4 RECENT)
              // ==========================================
              if (history.isLoading) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF165228)),
                    ),
                  ),
                ),
              ] else if (history.errorMessage != null) ...[
                ErrorStateView(
                  category: ErrorCategory.unexpected,
                  customMessage: history.errorMessage,
                  onRetry: () => history.loadReports(),
                ),
              ] else if (displayedReports.isEmpty) ...[
                EmptyStateView(
                  customIllustration:
                      const LeafMagnifierIllustration(size: 100),
                  title: loc.translate('no_history'),
                  message: loc.translate('no_history_desc'),
                  buttonText: loc.translate('scan_first_leaf'),
                  onButtonPressed: widget.onNavigateToScan,
                ),
              ] else ...[
                // Render the first 4 recent scans matching Image 2
                ...displayedReports.take(4).map(
                  (report) => HistoryCard(
                    report: report,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SavedReportDetailScreen(report: report),
                        ),
                      );
                    },
                    onDelete: () => history.deleteReport(report.id),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // ==========================================
              // 6. CROP HEALTH TREND (साप्ताहिक कल) CARD
              // ==========================================
              _buildCropHealthTrendCard(),
              const SizedBox(height: 16),

              // ==========================================
              // 7. FOLLOW-UP REMINDERS CARD
              // ==========================================
              _buildFollowUpRemindersCard(context),
              const SizedBox(height: 16),

              // ==========================================
              // 8. REPORTS & AGRONOMIST SHARING CARD
              // ==========================================
              _buildReportsSharingCard(context),
              const SizedBox(height: 16),

              // ==========================================
              // 9. DASHED BOX: FIELD ARCHIVE
              // ==========================================
              _buildFieldArchiveDashedBox(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopFilterPill({
    required String label,
    required bool isSelected,
    required Color? dotColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF165228) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF165228)
                : (dotColor != null
                    ? dotColor.withValues(alpha: 0.35)
                    : const Color(0xFFD4DEC9)),
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF165228).withValues(alpha: 0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null && !isSelected) ...[
              Container(
                width: 6.5,
                height: 6.5,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (dotColor == const Color(0xFFEF4444)
                        ? const Color(0xFFB91C1C)
                        : const Color(0xFF14451D)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.0),
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
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B8074),
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropHealthTrendCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: 'Crop Health Trend ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                        letterSpacing: -0.2,
                      ),
                      children: [
                        TextSpan(
                          text: '(साप्ताहिक कल)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B8074),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.access_time_rounded,
                size: 18,
                color: Color(0xFF8FA196),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Weekly scans overview (Last 4 weeks)',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B8074),
            ),
          ),
          const SizedBox(height: 14),

          // 4 Weekly Segmented Progress Bars matching Image 3
          _buildWeeklyBar(
            weekLabel: 'Week 1 (24 Mar – 30 Mar)',
            scanCount: '4 scans',
            greenRatio: 1.0,
            amberRatio: 0.0,
            redRatio: 0.0,
          ),
          const SizedBox(height: 12),
          _buildWeeklyBar(
            weekLabel: 'Week 2 (31 Mar – 06 Apr)',
            scanCount: '3 scans',
            greenRatio: 0.65,
            amberRatio: 0.35,
            redRatio: 0.0,
          ),
          const SizedBox(height: 12),
          _buildWeeklyBar(
            weekLabel: 'Week 3 (07 Apr – 13 Apr)',
            scanCount: '2 scans',
            greenRatio: 0.50,
            amberRatio: 0.50,
            redRatio: 0.0,
          ),
          const SizedBox(height: 12),
          _buildWeeklyBar(
            weekLabel: 'Week 4 (14 Apr – 20 Apr)',
            scanCount: '3 scans',
            greenRatio: 0.35,
            amberRatio: 0.0,
            redRatio: 0.65,
          ),
          const SizedBox(height: 16),

          // Legend
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF15803D),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Healthy Crop',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Needs Attention',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBar({
    required String weekLabel,
    required String scanCount,
    required double greenRatio,
    required double amberRatio,
    required double redRatio,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  weekLabel,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              scanCount,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B8074),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 8,
            width: double.infinity,
            color: const Color(0xFFE5EDE7),
            child: Row(
              children: [
                if (greenRatio > 0)
                  Expanded(
                    flex: (greenRatio * 100).toInt(),
                    child: Container(color: const Color(0xFF15803D)),
                  ),
                if (amberRatio > 0)
                  Expanded(
                    flex: (amberRatio * 100).toInt(),
                    child: Container(color: const Color(0xFFF59E0B)),
                  ),
                if (redRatio > 0)
                  Expanded(
                    flex: (redRatio * 100).toInt(),
                    child: Container(color: const Color(0xFFEF4444)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowUpRemindersCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBEAD7), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF14532D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.alarm_on_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Follow-up Reminders',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: 'Recheck ',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF334155),
                          height: 1.35,
                        ),
                        children: [
                          TextSpan(
                            text: 'Yellow Leaf Plot #2',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF14532D),
                            ),
                          ),
                          TextSpan(
                            text:
                                ' in 3 days to monitor treatment progress.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => _setFollowUpReminder(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF165228),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Set Reminder',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSharingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reports & Agronomist Sharing',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14451D),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'View Summary',
                  onTap: () => _showReportsSummaryModal(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.file_download_outlined,
                  label: 'Download PDF',
                  onTap: () => _downloadPdfReport(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share Expert',
                  onTap: () => _shareWithExpert(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0EAE2), width: 1.0),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00796B),
              size: 20,
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14451D),
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldArchiveDashedBox(BuildContext context) {
    return CustomPaint(
      painter: const DashedBorderPainter(
        color: Color(0xFFBCE3C9),
        radius: 18,
        strokeWidth: 1.2,
        dashLength: 6,
        dashGap: 4,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF7),
          borderRadius: BorderRadius.circular(18),
        ),
        child: InkWell(
          onTap: () {
            // Restore all scans and clear filter
            context.read<HistoryProvider>().setFilter(HistoryFilter.all);
            context.read<HistoryProvider>().setSearchQuery('');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Displaying full field archive (12 scans total).'),
                backgroundColor: Color(0xFF165228),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text.rich(
            TextSpan(
              text:
                  'Looking for older scans? Filter by custom date range or visit the ',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF5A7265),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'field archive.',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF15803D),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the dashed rounded border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double dashGap;

  const DashedBorderPainter({
    this.color = const Color(0xFFBCE3C9),
    this.strokeWidth = 1.2,
    this.radius = 16.0,
    this.dashLength = 6.0,
    this.dashGap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashLength < metric.length)
            ? dashLength
            : metric.length - distance;
        dashPath.addPath(
            metric.extractPath(distance, distance + length), Offset.zero);
        distance += dashLength + dashGap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius;
}
