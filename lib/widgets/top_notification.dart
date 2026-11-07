import 'dart:async';
import 'package:flutter/material.dart';

/// Modern top floating in-app notification banner matching top-tier mobile apps.
/// Slides smoothly down from the top status area and auto-dismisses or swipes away.
class TopNotification {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(
    BuildContext context, {
    required String title,
    String? subtitle,
    IconData icon = Icons.check_circle_rounded,
    Color iconBg = const Color(0xFFE8F8EE),
    Color iconColor = const Color(0xFF165228),
    Color backgroundColor = const Color(0xFF14451D),
    Color textColor = Colors.white,
    Color subtitleColor = const Color(0xFFC8E6C9),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
    Duration duration = const Duration(milliseconds: 3600),
  }) {
    dismiss();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _TopNotificationWidget(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconBg: iconBg,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
        subtitleColor: subtitleColor,
        actionLabel: actionLabel,
        onAction: onAction,
        onTap: onTap,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_currentEntry != null) {
      try {
        _currentEntry?.remove();
      } catch (_) {}
      _currentEntry = null;
    }
  }

  /// Convenience for successful downloads
  static void showDownload(
    BuildContext context, {
    required String fileName,
    String? fileSize = '2.4 MB',
    VoidCallback? onOpen,
  }) {
    show(
      context,
      title: fileName,
      subtitle: 'अहवाल डाऊनलोड झाला${fileSize != null ? ' • $fileSize' : ''}',
      icon: Icons.file_download_done_rounded,
      iconBg: const Color(0xFFE8F8EE),
      iconColor: const Color(0xFF165228),
      backgroundColor: const Color(0xFF14451D),
      actionLabel: 'पहा',
      onAction: onOpen,
      onTap: onOpen,
    );
  }

  /// Convenience for sharing with experts
  static void showShare(
    BuildContext context, {
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      subtitle: subtitle ?? 'कृषी तज्ज्ञांसाठी शेअर लिंक क्लिपबोर्डवर कॉपी झाली',
      icon: Icons.share_rounded,
      iconBg: const Color(0xFFE0F2FE),
      iconColor: const Color(0xFF0369A1),
      backgroundColor: const Color(0xFF0F3A22),
      actionLabel: 'शेअर',
      onAction: onTap,
      onTap: onTap,
    );
  }

  /// Convenience for reminders
  static void showReminder(
    BuildContext context, {
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      subtitle: subtitle,
      icon: Icons.alarm_on_rounded,
      iconBg: const Color(0xFFFEF3C7),
      iconColor: const Color(0xFFD97706),
      backgroundColor: const Color(0xFF14451D),
      actionLabel: 'तपासा',
      onAction: onTap,
      onTap: onTap,
    );
  }
}

class _TopNotificationWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color backgroundColor;
  final Color textColor;
  final Color subtitleColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopNotificationWidget({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.subtitleColor,
    this.actionLabel,
    this.onAction,
    this.onTap,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_TopNotificationWidget> createState() => _TopNotificationWidgetState();
}

class _TopNotificationWidgetState extends State<_TopNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    _timer = Timer(widget.duration, () {
      _dismissAnimated();
    });
  }

  void _dismissAnimated() {
    if (!mounted) return;
    _timer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top > 0 ? mediaQuery.padding.top + 6 : 14.0;

    return Positioned(
      top: topPadding,
      left: 14,
      right: 14,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (_) {
              widget.onDismiss();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    if (widget.onTap != null) {
                      _dismissAnimated();
                      widget.onTap!();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Icon Badge
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: widget.iconBg,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  color: widget.textColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.subtitle != null &&
                                  widget.subtitle!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.subtitle!,
                                  style: TextStyle(
                                    color: widget.subtitleColor,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Action Button (if provided)
                        if (widget.actionLabel != null) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              _dismissAnimated();
                              widget.onAction?.call();
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF81C784),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                widget.actionLabel!,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(width: 6),
                        // Close Icon Button
                        GestureDetector(
                          onTap: _dismissAnimated,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

