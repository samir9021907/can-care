import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../localization/app_localizations.dart';
import '../models/app_notification.dart';
import '../services/notification_service.dart';
import 'crop_health_report_screen.dart';
import 'farmer_community_screen.dart';
import 'history_screen.dart';
import 'scan_camera_screen.dart';
import 'sugarcane_care_guide_screen.dart';
import 'weather_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();

  @override
  void initState() {
    super.initState();
    _service.init();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  String _t(String mr, String hi, String en) {
    final loc = AppLocalizations.of(context);
    if (loc.isMarathi) return mr;
    if (loc.isHindi) return hi;
    return en;
  }

  String _formatRelativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final loc = AppLocalizations.of(context);

    if (diff.inMinutes < 60) {
      final mins = diff.inMinutes <= 0 ? 1 : diff.inMinutes;
      if (loc.isMarathi) return '$mins मिनिटांपूर्वी';
      if (loc.isHindi) return '$mins मिनट पहले';
      return '$mins min ago';
    } else if (diff.inHours < 24) {
      final hrs = diff.inHours;
      if (loc.isMarathi) return '$hrs तासांपूर्वी';
      if (loc.isHindi) return '$hrs घंटे पहले';
      return '$hrs hrs ago';
    } else if (diff.inDays == 1) {
      if (loc.isMarathi) return 'काल';
      if (loc.isHindi) return 'कल';
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      final days = diff.inDays;
      if (loc.isMarathi) return '$days दिवसांपूर्वी';
      if (loc.isHindi) return '$days दिन पहले';
      return '$days days ago';
    } else {
      return DateFormat('dd MMM').format(dt);
    }
  }

  void _handleNotificationTap(AppNotification item) {
    _service.markAsRead(item.id);

    final route = item.actionRoute;
    if (route == null) return;

    if (route == 'weather') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen()));
    } else if (route == 'scan') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanCameraScreen()));
    } else if (route == 'history') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
    } else if (route == 'community') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmerCommunityScreen()));
    } else if (route == 'care_guide') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SugarcaneCareGuideScreen()));
    } else if (route == 'report') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CropHealthReportScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _service.notifications;
    final unread = _service.unreadCount;
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
        title: Row(
          children: [
            Text(
              _t('सूचना', 'सूचनाएं', 'Notifications'),
              style: const TextStyle(
                color: Color(0xFF14451D),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF15803D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unread',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () async {
                await _service.markAllAsRead();
              },
              child: Text(
                _t('सर्व वाचले', 'सभी पढ़ें', 'Mark all read'),
                style: const TextStyle(
                  color: Color(0xFF15803D),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (list.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF14451D), size: 22),
              onSelected: (val) async {
                if (val == 'clear') {
                  await _service.clearAll();
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_sweep_outlined, color: Color(0xFFDC2626), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _t('सर्व सूचना हटवा', 'सभी हटाएं', 'Clear all notifications'),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: list.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, index) {
                  final item = list[index];
                  return _buildNotificationCard(item, loc);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification item, AppLocalizations loc) {
    final title = loc.isMarathi
        ? item.titleMarathi
        : (loc.isHindi ? item.titleHindi : item.title);
    final body = loc.isMarathi
        ? item.bodyMarathi
        : (loc.isHindi ? item.bodyHindi : item.body);
    final timeStr = _formatRelativeTime(item.timestamp);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (_) {
        final removed = item;
        _service.deleteNotification(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('सूचना हटवली', 'सूचना हटाई गई', 'Notification removed')),
            action: SnackBarAction(
              label: _t('पूर्ववत करा', 'वापस लें', 'Undo'),
              textColor: const Color(0xFF86EFAC),
              onPressed: () {
                _service.addNotification(removed);
              },
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF1F2937),
          ),
        );
      },
      child: InkWell(
        onTap: () => _handleNotificationTap(item),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : const Color(0xFFF4FBF6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isRead ? const Color(0xFFE5EBE5) : const Color(0xFFA7D7B5),
              width: item.isRead ? 1.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: item.isRead ? 0.02 : 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clean Category Icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.iconData,
                  size: 20,
                  color: const Color(0xFF15803D),
                ),
              ),
              const SizedBox(width: 12),

              // Title, Body, Timestamp
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: item.isRead ? FontWeight.w700 : FontWeight.w800,
                              color: const Color(0xFF14451D),
                              height: 1.25,
                            ),
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF15803D),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B6351),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8BA090),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF2E7D32),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _t('कोणतीही सूचना नाही', 'कोई सूचना नहीं है', 'No Notifications'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _t(
                'तुमच्या ऊस पिकाशी संबंधित नवीन सूचना येथे दिसतील.',
                'आपकी फसल से संबंधित सूचनाएं यहां दिखाई देंगी।',
                'New notifications regarding your sugarcane crop will appear here.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7A9280)),
            ),
          ],
        ),
      ),
    );
  }
}
