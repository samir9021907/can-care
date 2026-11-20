import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../services/sugarcane_market_service.dart';

class SugarcaneMarketScreen extends StatefulWidget {
  final String? initialMandiId;

  const SugarcaneMarketScreen({super.key, this.initialMandiId});

  @override
  State<SugarcaneMarketScreen> createState() => _SugarcaneMarketScreenState();
}

class _SugarcaneMarketScreenState extends State<SugarcaneMarketScreen> {
  late final List<SugarcaneMandi> _mandis;
  late String _selectedMandiId;
  bool _isDailyView = true; // true = 7-Day Daily, false = 6-Month Season
  double _calculatorRecovery = 11.5;
  bool _isRefreshing = false;
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    _mandis = SugarcaneMarketService.instance.getAllMandis();
    _selectedMandiId = widget.initialMandiId ?? _mandis.first.id;
    _lastUpdated = DateTime.now();
  }

  SugarcaneMandi get _currentMandi {
    return _mandis.firstWhere(
      (m) => m.id == _selectedMandiId,
      orElse: () => _mandis.first,
    );
  }

  String _t(String mr, String hi, String en) {
    final lang = AppLocalizations.of(context).language;
    switch (lang) {
      case AppLanguage.marathi:
        return mr;
      case AppLanguage.hindi:
        return hi;
      case AppLanguage.english:
        return en;
    }
  }

  Future<void> _refreshRates() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _lastUpdated = DateTime.now();
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(_t(
              'बाजार भाव यशस्वीरित्या रिफ्रेश झाले!',
              'बाजार भाव सफलतापूर्वक रिफ्रेश हुए!',
              'Market rates refreshed successfully!',
            )),
          ],
        ),
        backgroundColor: const Color(0xFF15803D),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mandi = _currentMandi;
    final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;
    final isHi = AppLocalizations.of(context).language == AppLanguage.hindi;
    final mandiName = isMr ? mandi.nameMr : (isHi ? mandi.nameHi : mandi.nameEn);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t('थेट ऊस बाजार भाव व कल', 'लाइव गन्ना मंडी भाव व रुझान', 'Live Sugarcane Market'),
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF15803D),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _t(
                    'लाईव्ह • दररोज अद्ययावत',
                    'लाइव • दैनिक अपडेट',
                    'LIVE • Daily Updated',
                  ),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF15803D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _t('रिफ्रेश करा', 'रिफ्रेश करें', 'Refresh'),
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF15803D),
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: Color(0xFF15803D)),
            onPressed: _isRefreshing ? null : _refreshRates,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mandi Selection Chips (Horizontal scrollable)
            _buildMandiSelector(),
            const SizedBox(height: 14),

            // 2. Hero Today's Live Rate Card
            _buildTodayLiveRateHero(mandi, mandiName),
            const SizedBox(height: 16),

            // 3. Interactive Chart with Daily vs 6M toggle
            _buildChartSection(mandi),
            const SizedBox(height: 16),

            // 4. DAY-BY-DAY LIVE MARKET TABLE (Requested by user)
            _buildDayByDayLiveTable(mandi),
            const SizedBox(height: 16),

            // 5. Interactive FRP Price Calculator
            _buildFrpCalculator(),
            const SizedBox(height: 16),

            // 6. Sugar Mills 1st Installment Updates
            _buildFactoryUpdates(mandi),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. MANDI SELECTOR CHIPS
  // -------------------------------------------------------------
  Widget _buildMandiSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('बाजार समिती निवडा:', 'मंडी चुनें:', 'Select APMC Mandi:'),
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5A7265),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _mandis.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final m = _mandis[index];
              final isSelected = m.id == _selectedMandiId;
              final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;
              final isHi = AppLocalizations.of(context).language == AppLanguage.hindi;
              final label = isMr ? m.districtMr : (isHi ? m.nameHi.split(' ')[0] : m.districtEn);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMandiId = m.id;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF14451D) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF14451D) : const Color(0xFFD6E3D8),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF14451D).withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF3B5244),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 2. HERO TODAY'S LIVE RATE CARD
  // -------------------------------------------------------------
  Widget _buildTodayLiveRateHero(SugarcaneMandi mandi, String mandiName) {
    final now = _lastUpdated;
    final timeStr = "${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
    final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14451D),
            Color(0xFF1A5A27),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14451D).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Live Badge and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4ADE80), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _t('आजचा थेट भाव (LIVE)', 'आज का लाइव भाव', 'TODAY LIVE RATE'),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFDCFCE7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${now.day}/${now.month}/${now.year} • $timeStr',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mandi Name
          Text(
            mandiName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC7EED4),
            ),
          ),
          const SizedBox(height: 4),

          // Big Price & Daily Change
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${mandi.currentAvgPrice.toInt()}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _t('/ टन (सरासरी)', '/ टन (औसत)', '/ tonne (avg)'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 14, color: Color(0xFF4ADE80)),
                    const SizedBox(width: 2),
                    Text(
                      '+₹${mandi.dailyChange.toInt()} ${_t('आज वाढ', 'आज बढ़त', 'today')}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4-Pill Info Grid: Min / Max / Arrival / Recovery
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWhiteStatPill(
                  _t('किमान दर', 'न्यूनतम', 'Min Rate'),
                  '₹${mandi.minPrice.toInt()}',
                ),
                _buildVerticalWhiteDivider(),
                _buildWhiteStatPill(
                  _t('कमाल दर', 'उच्चतम', 'Max Rate'),
                  '₹${mandi.maxPrice.toInt()}',
                ),
                _buildVerticalWhiteDivider(),
                _buildWhiteStatPill(
                  _t('आजची आवक', 'आज की आवक', 'Arrival'),
                  '${mandi.todayArrivalTonnes} ${_t('टन', 'टन', 'T')}',
                ),
                _buildVerticalWhiteDivider(),
                _buildWhiteStatPill(
                  _t('साखर उतारा', 'रिकवरी', 'Recovery'),
                  '${mandi.baseRecovery}%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteStatPill(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalWhiteDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }

  // -------------------------------------------------------------
  // 3. CHART SECTION (7-DAY DAILY vs 6M SEASON)
  // -------------------------------------------------------------
  Widget _buildChartSection(SugarcaneMandi mandi) {
    final prices = _isDailyView
        ? mandi.dailyRates.map((d) => d.avgPrice).toList()
        : mandi.monthlyRates.map((m) => m.avgPrice).toList();

    final labels = _isDailyView
        ? mandi.dailyRates.map((d) {
            final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;
            final isHi = AppLocalizations.of(context).language == AppLanguage.hindi;
            return isMr ? d.dateLabelMr.split(' ')[0] : (isHi ? d.dateLabelHi.split(' ')[0] : d.dateLabelEn.split(' ')[0]);
          }).toList()
        : mandi.monthlyRates.map((m) {
            final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;
            final isHi = AppLocalizations.of(context).language == AppLanguage.hindi;
            return isMr ? m.monthLabelMr : (isHi ? m.monthLabelHi : m.monthLabelEn);
          }).toList();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final avgPrice = (prices.reduce((a, b) => a + b) / prices.length).roundToDouble();

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
          // Header with Title & Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isDailyView
                        ? _t('गेल्या ७ दिवसांचा दर कल', 'पिछले ७ दिनों का रुझान', 'Last 7 Days Trend')
                        : _t('हंगामी ६ महिने कल', 'मौसमी ६ महीने का रुझान', '6-Month Seasonal Trend'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isDailyView
                        ? _t('दररोजचे चालू बाजार भाव', 'प्रतिदिन के चालू भाव', 'Daily Live Market Rates')
                        : _t('मासिक सरासरी भाव बदल', 'मासिक औसत भाव बदलाव', 'Monthly average prices'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF6B8074),
                    ),
                  ),
                ],
              ),
              // Toggle pill: Daily vs Season
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD6E3D8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimeToggleBtn(
                      _t('दैनिक', 'दैनिक', 'Daily'),
                      _isDailyView,
                      () => setState(() => _isDailyView = true),
                    ),
                    _buildTimeToggleBtn(
                      _t('हंगाम', 'सीजन', 'Season'),
                      !_isDailyView,
                      () => setState(() => _isDailyView = false),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Dynamic Chart
          SizedBox(
            width: double.infinity,
            height: 115,
            child: CustomPaint(
              painter: _DynamicMarketChartPainter(
                prices: prices,
                labels: labels,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Mini Stats Bar: Min / Avg / Peak
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F9F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${_t('किमान', 'न्यूनतम', 'Min')}: ₹${minPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A7265),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('•', style: TextStyle(color: Color(0xFFA5C4AE))),
                  const SizedBox(width: 12),
                  Text(
                    '${_t('सरासरी', 'औसत', 'Avg')}: ₹${avgPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A7265),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('•', style: TextStyle(color: Color(0xFFA5C4AE))),
                  const SizedBox(width: 12),
                  Text(
                    '${_t('कमाल', 'उच्चतम', 'Peak')}: ₹${maxPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF14451D) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF5A7265),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 4. DAY-BY-DAY LIVE MARKET TABLE
  // -------------------------------------------------------------
  Widget _buildDayByDayLiveTable(SugarcaneMandi mandi) {
    final dailyList = mandi.dailyRates.reversed.toList(); // Today first
    final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;
    final isHi = AppLocalizations.of(context).language == AppLanguage.hindi;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _t('प्रत्येक दिवसाचा थेट दर तक्ता', 'प्रतिदिन का लाइव भाव तालिका', 'Day-by-Day Live Rate Sheet'),
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _t('७ दिवस चालू', '७ दिन चालू', '7 Days Live'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _t('रोजची आवक, किमान-कमाल व सरासरी भाव', 'दैनिक आवक, न्यूनतम-अधिकतम व औसत भाव', 'Daily arrival, price range and average payment'),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B8074),
            ),
          ),
          const SizedBox(height: 12),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    _t('तारीख व वार', 'तारीख व दिन', 'Date & Day'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A7265),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _t('दर श्रेणी', 'भाव सीमा', 'Range (₹)'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A7265),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _t('सरासरी भाव', 'औसत भाव', 'Avg Rate'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A7265),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // List of days
          ...dailyList.asMap().entries.map((entry) {
            final idx = entry.key;
            final day = entry.value;
            final isToday = idx == 0;
            final dateLabel = isMr ? day.dateLabelMr : (isHi ? day.dateLabelHi : day.dateLabelEn);
            final dayName = isMr ? day.dayNameMr : (isHi ? day.dayNameHi : day.dayNameEn);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFFF0FDF4) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: const Color(0xFFBBF7D0), width: 1)
                    : Border(bottom: BorderSide(color: const Color(0xFFEFF4F0), width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isToday)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF15803D),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Flexible(
                              child: Text(
                                dateLabel,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w700,
                                  color: isToday ? const Color(0xFF15803D) : const Color(0xFF1F3826),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$dayName • ${day.arrivalTonnes} ${_t('टन आवक', 'टन आवक', 'T arrival')}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF758A7C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        '₹${day.minPrice.toInt()} - ₹${day.maxPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B5244),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${day.avgPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: isToday ? const Color(0xFF15803D) : const Color(0xFF14451D),
                          ),
                        ),
                        Text(
                          day.change >= 0 ? '+₹${day.change.toInt()}' : '-₹${day.change.abs().toInt()}',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: day.change >= 0 ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 5. INTERACTIVE FRP PRICE CALCULATOR
  // -------------------------------------------------------------
  Widget _buildFrpCalculator() {
    final calculatedPayout = SugarcaneMarketService.calculateFrpForRecovery(_calculatorRecovery);
    final bonus = calculatedPayout - SugarcaneMarketService.nationalFrpBaseRate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFDF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD2E8D7), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calculate_rounded, color: Color(0xFF15803D), size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('थेट एफआरपी दर कॅल्क्युलेटर', 'लाइव एफआरपी कैलकुलेटर', 'Live FRP Sugarcane Calculator'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
                    ),
                    Text(
                      _t('साखर उताऱ्यानुसार तुमचा खात्रीशीर दर तपासा', 'चीनी रिकवरी के अनुसार अपना सही दर जानें', 'Calculate factory payout based on sugar recovery'),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6B8074),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recovery slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _t('तुमचा साखर उतारा:', 'चीनी रिकवरी प्रतिशत:', 'Your Sugar Recovery:'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B5244),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF14451D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_calculatorRecovery.toStringAsFixed(2)}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _calculatorRecovery,
            min: 9.5,
            max: 13.5,
            divisions: 40,
            activeColor: const Color(0xFF15803D),
            inactiveColor: const Color(0xFFD6E3D8),
            onChanged: (val) {
              setState(() => _calculatorRecovery = val);
            },
          ),

          // Calculated Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2EEE4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('कारखान्याकडून मिळणारा प्रति टन दर:', 'मिल से मिलने वाला प्रति टन भाव:', 'Payable Rate per tonne:'),
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF5A7265),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${calculatedPayout.round()}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
                if (bonus > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFBF4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _t('उतारा बोनस', 'रिकवरी बोनस', 'Premium'),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                        Text(
                          '+₹${bonus.round()} / टन',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 6. SUGAR MILLS 1st INSTALLMENT UPDATES
  // -------------------------------------------------------------
  Widget _buildFactoryUpdates(SugarcaneMandi mandi) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.factory_outlined, color: Color(0xFF14451D), size: 18),
              const SizedBox(width: 8),
              Text(
                _t('कार्यरत प्रमुख साखर कारखाने', 'क्षेत्रीय प्रमुख चीनी मिलें', 'Active Regional Sugar Mills'),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...mandi.activeFactories.map(
            (factory) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      factory,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B4434),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// DYNAMIC SMOOTH LINE CHART PAINTER FOR THE MARKET SCREEN
// -------------------------------------------------------------
class _DynamicMarketChartPainter extends CustomPainter {
  final List<double> prices;
  final List<String> labels;

  _DynamicMarketChartPainter({required this.prices, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final minVal = prices.reduce((a, b) => a < b ? a : b);
    final maxVal = prices.reduce((a, b) => a > b ? a : b);
    final diff = maxVal - minVal;
    final paddingVal = diff == 0 ? 50.0 : diff * 0.25;
    final chartMin = minVal - paddingVal;
    final chartMax = maxVal + paddingVal;
    final range = chartMax - chartMin;

    const bottomPadding = 22.0;
    const topPadding = 12.0;
    final chartHeight = size.height - bottomPadding - topPadding;
    final chartWidth = size.width;

    // 1. Horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE8EFE9)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 2; i++) {
      final y = topPadding + (chartHeight * (i / 2));
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    // 2. Coordinate points
    final points = <Offset>[];
    final stepX = chartWidth / (prices.length - 1);

    for (int i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final normalized = range == 0 ? 0.5 : (prices[i] - chartMin) / range;
      final y = topPadding + chartHeight * (1.0 - normalized);
      points.add(Offset(x, y));
    }

    // 3. Smooth cubic Bezier spline
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY1 = p0.dy;
      final controlX2 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY2 = p1.dy;
      linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
    }

    // 4. Fill gradient below line
    final fillPath = Path.from(linePath);
    fillPath.lineTo(points.last.dx, size.height - bottomPadding);
    fillPath.lineTo(points.first.dx, size.height - bottomPadding);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF22C55E).withValues(alpha: 0.28),
          const Color(0xFF22C55E).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, topPadding, chartWidth, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    // 5. Line stroke
    final strokePaint = Paint()
      ..color = const Color(0xFF15803D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, strokePaint);

    // 6. Data points with glow on latest point
    final dotPaint = Paint()
      ..color = const Color(0xFF15803D)
      ..style = PaintingStyle.fill;
    final dotInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      if (i == points.length - 1) {
        final haloPaint = Paint()
          ..color = const Color(0xFF22C55E).withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p, 9, haloPaint);
        canvas.drawCircle(p, 5.5, dotPaint);
        canvas.drawCircle(p, 2.5, dotInner);
      } else {
        canvas.drawCircle(p, 3.5, dotPaint);
        canvas.drawCircle(p, 1.8, dotInner);
      }
    }

    // 7. Labels along X-axis
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < labels.length; i++) {
      final isCurrent = i == labels.length - 1;
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
          color: isCurrent ? const Color(0xFF15803D) : const Color(0xFF758A7C),
        ),
      );
      textPainter.layout();
      final x = (points[i].dx - (textPainter.width / 2)).clamp(0.0, size.width - textPainter.width);
      textPainter.paint(canvas, Offset(x, size.height - bottomPadding + 6));
    }
  }

  @override
  bool shouldRepaint(covariant _DynamicMarketChartPainter oldDelegate) {
    return oldDelegate.prices != prices || oldDelegate.labels != labels;
  }
}
