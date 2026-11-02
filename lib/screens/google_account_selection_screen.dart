import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/google_sign_in_button.dart';
import 'google_verifying_screen.dart';

/// Screen 4: Google Account Selection matching Screen 4 in the reference specification.
/// Displays accounts available on device (e.g. Samir Rahane, Rahane Farm, Samir) + "Use another account".
class GoogleAccountSelectionScreen extends StatefulWidget {
  final bool isSignUp;

  const GoogleAccountSelectionScreen({
    super.key,
    this.isSignUp = true,
  });

  @override
  State<GoogleAccountSelectionScreen> createState() =>
      _GoogleAccountSelectionScreenState();
}

class _GoogleAccountSelectionScreenState
    extends State<GoogleAccountSelectionScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _accounts = [
    {
      'name': 'Samir Rahane',
      'email': 'samir@gmail.com',
      'avatarColor': const Color(0xFF1E3A5F),
      'letter': 'S',
    },
    {
      'name': 'Rahane Farm',
      'email': 'rahane@gmail.com',
      'avatarColor': const Color(0xFF5D5338),
      'letter': 'R',
    },
    {
      'name': 'Samir',
      'email': 'samir123@gmail.com',
      'avatarColor': const Color(0xFF558B58),
      'letter': 'S',
    },
  ];

  void _selectAccount(int index) {
    setState(() => _selectedIndex = index);
    final account = _accounts[index];

    // Smooth transition to Screen 5: Google Verifying Account
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GoogleVerifyingScreen(
          userName: account['name'] as String,
          userEmail: account['email'] as String,
          isSignUp: widget.isSignUp,
        ),
      ),
    );
  }

  void _onUseAnotherAccount() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CustomPaint(painter: GoogleLogoPainter()),
              ),
              SizedBox(width: 10),
              Text(
                'Add Google Account',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter your Google email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoogleVerifyingScreen(
                        userName: email.split('@').first,
                        userEmail: email,
                        isSignUp: widget.isSignUp,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Continue',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF263238)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Official 4-color Google 'G' Mark
              const SizedBox(
                width: 44,
                height: 44,
                child: CustomPaint(
                  painter: GoogleLogoPainter(),
                ),
              ),

              const SizedBox(height: 18),

              // Title: Choose an account
              const Text(
                'Choose an account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E3A24),
                  letterSpacing: -0.3,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              // Subtitle: to continue to CaneCare AI
              const Text(
                'to continue to CaneCare AI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // White Account Card containing multiple accounts
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2ECE0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _accounts.length; i++) ...[
                      _buildAccountTile(
                        index: i,
                        name: _accounts[i]['name'] as String,
                        email: _accounts[i]['email'] as String,
                        avatarColor: _accounts[i]['avatarColor'] as Color,
                        letter: _accounts[i]['letter'] as String,
                        isSelected: _selectedIndex == i,
                      ),
                      const Divider(height: 1, color: Color(0xFFEEF3EC), indent: 64),
                    ],

                    // Option 4: Use another account
                    InkWell(
                      onTap: _onUseAnotherAccount,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF1F6F0),
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1_outlined,
                                color: Color(0xFF4A6B53),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Use another account',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E3A24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Disclaimer text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'To continue, Google will share your name, email address and profile picture with CaneCare AI.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B8A73),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 48),

              // Authentic Google wordmark logo at bottom
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    fontFamily: 'Poppins',
                  ),
                  children: [
                    TextSpan(
                        text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                    TextSpan(
                        text: 'o', style: TextStyle(color: Color(0xFFEA4335))),
                    TextSpan(
                        text: 'o', style: TextStyle(color: Color(0xFFFBBC05))),
                    TextSpan(
                        text: 'g', style: TextStyle(color: Color(0xFF4285F4))),
                    TextSpan(
                        text: 'l', style: TextStyle(color: Color(0xFF34A853))),
                    TextSpan(
                        text: 'e', style: TextStyle(color: Color(0xFFEA4335))),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required int index,
    required String name,
    required String email,
    required Color avatarColor,
    required String letter,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _selectAccount(index),
      borderRadius: index == 0
          ? const BorderRadius.vertical(top: Radius.circular(18))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Circular Avatar with initial
            CircleAvatar(
              radius: 19,
              backgroundColor: avatarColor,
              child: Text(
                letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Account details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A24),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B8A73),
                    ),
                  ),
                ],
              ),
            ),

            // Custom radio circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFB0C4B4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
