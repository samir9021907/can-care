import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _photoTip = true;
  bool _confidenceScore = true;
  bool _diseaseLibrary = true;
  bool _consultExpert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF14451D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Switches Container (Figma Screen 17)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EFE5), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      title: 'How to take a good photo\n(leaf image)',
                      value: _photoTip,
                      onChanged: (v) => setState(() => _photoTip = v),
                    ),
                    _buildDivider(),
                    _buildSwitchRow(
                      title: 'Understanding confidence score',
                      value: _confidenceScore,
                      onChanged: (v) => setState(() => _confidenceScore = v),
                    ),
                    _buildDivider(),
                    _buildSwitchRow(
                      title: 'Using disease library',
                      value: _diseaseLibrary,
                      onChanged: (v) => setState(() => _diseaseLibrary = v),
                    ),
                    _buildDivider(),
                    _buildSwitchRow(
                      title: 'When to consult an expert',
                      value: _consultExpert,
                      onChanged: (v) => setState(() => _consultExpert = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Contact Support Card (Figma Screen 17)
              const Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EFE5), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
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
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+91 1800 123 456',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF14451D),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'support@canecare.ai',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF7A9280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFA5B8A8), width: 1.5),
            ),
            child: const Icon(Icons.info_outline, size: 14, color: Color(0xFF7A9280)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF14451D),
                height: 1.3,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF2E7D32),
            activeTrackColor: const Color(0xFFA5D6A7),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD4DEC9),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0F4ED),
      indent: 52,
    );
  }
}
