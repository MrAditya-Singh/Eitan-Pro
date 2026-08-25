import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cook_app/services/auth_service.dart';
import 'package:cook_app/screens/login_screen.dart';
import 'package:cook_app/screens/profile_screen.dart';
import 'package:cook_app/screens/community_screen.dart';
import 'package:cook_app/screens/notification_screen.dart';

import 'package:cook_app/services/ai_service.dart';
 // Kept for future use or referenced logic

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _auth = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _handleSignOut() async {
    await _auth.signOut();
    setState(() {
      _user = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed Out Successfully'), backgroundColor: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 2.0
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUpgradeCard(isDark),
            const SizedBox(height: 30),
            
            Text(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isDark ? const Color(0xFF72CFCF) : const Color(0xFF3A9E9E),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            
            if (_user != null) ...[
              _buildSettingTile(
                icon: Icons.person_outline, 
                title: 'My Profile', 
                subtitle: _user?.email ?? 'Member',
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                },
                isDark: isDark
              ),
              _buildSettingTile(
                icon: Icons.logout, 
                title: 'Sign Out', 
                subtitle: 'See you soon',
                onTap: _handleSignOut,
                isDark: isDark,
                isDestructive: true
              ),
            ] else ...[
              _buildSettingTile(
                icon: Icons.login, 
                title: 'Member Access', 
                subtitle: 'Log in to your account',
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  _checkCurrentUser();
                },
                isDark: isDark
              ),
              _buildSettingTile(
                icon: Icons.person_add_alt_1_outlined, 
                title: 'Join Community', 
                subtitle: 'Register as a new member',
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityScreen()));
                  _checkCurrentUser();
                },
                isDark: isDark
              ),
            ],

            const SizedBox(height: 30),

            Text(
              'PREFERENCES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isDark ? const Color(0xFF72CFCF) : const Color(0xFF3A9E9E),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
             _buildSettingTile(
                icon: Icons.notifications_none_rounded, 
                title: 'Notifications', 
                subtitle: 'Updates & new recipes',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                },
                isDark: isDark
              ),
              _buildSettingTile(
                icon: Icons.language, 
                title: 'Language', 
                subtitle: 'English (US)',
                onTap: () {},
                isDark: isDark
              ),
              _buildSettingTile(
                icon: Icons.help_outline_rounded, 
                title: 'Support', 
                subtitle: 'Get help & feedback',
                onTap: () {},
                isDark: isDark
              ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: Text('Scan to Pay', style: TextStyle(fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[50],
              ),
              child: const Center(
                child: Icon(Icons.qr_code_2_rounded, size: 150, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 15),
            const Text('Accepting all major UPI apps', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            const Text('₹ 499 / year', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF4A00E0))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel', style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A00E0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A00E0).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'LIMITED TIME OFFER',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                ),
              ),
              Icon(Icons.verified, color: Colors.amberAccent, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Unlock Premium\nCulinary Access',
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.w900, 
              fontSize: 24, 
              height: 1.2
            ),
          ),
          const SizedBox(height: 20),
          _buildFeatureRow('Cook Mode Pro', 'Hands-free voice control'),
          _buildFeatureRow('Personal Sessions', '1-on-1 with Chef Eitan'),
          _buildFeatureRow('AI Chef Assistant', 'Unlimited smart queries'),
          _buildFeatureRow('Exclusive Masterclasses', 'Advanced technique videos'),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showUpgradeDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4A00E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text('UPGRADE NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242428) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive 
              ? Colors.redAccent.withValues(alpha: 0.1) 
              : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon, 
            color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black), 
            size: 20
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black),
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDestructive ? Colors.redAccent.withValues(alpha: 0.6) : (isDark ? Colors.white38 : Colors.grey[500]),
            fontSize: 12,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: isDark ? Colors.white24 : Colors.grey[300], size: 14),
      ),
    );
  }
}
