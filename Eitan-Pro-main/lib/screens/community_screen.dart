import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFE91E63);
    final Color secondaryColor = const Color(0xFF2E3192);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'JOIN THE FAMILY',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [secondaryColor, primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_n44Fz_aYd5E8S_n_a5f2v424_f345_f2_34f=s900-c-k-c0x00ffffff-no-rj'), // Placeholder for Eitan
                      onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Hey, I'm Eitan!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Join millions of foodies, aspiring chefs, and kitchen adventurers. Let's cook something amazing together!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Social Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FOLLOW THE JOURNEY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isDark ? const Color(0xFF72CFCF) : secondaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.5,
                    children: [
                      _buildSocialCard(
                        context,
                        icon: FontAwesomeIcons.tiktok,
                        name: 'TikTok',
                        handle: '@eitan',
                        color: Colors.black,
                        url: 'https://www.tiktok.com/@eitan',
                        isDark: isDark,
                      ),
                      _buildSocialCard(
                        context,
                        icon: FontAwesomeIcons.instagram,
                        name: 'Instagram',
                        handle: '@eitan',
                        color: const Color(0xFFE1306C),
                        url: 'https://www.instagram.com/eitan',
                        isDark: isDark,
                      ),
                      _buildSocialCard(
                        context,
                        icon: FontAwesomeIcons.youtube,
                        name: 'YouTube',
                        handle: 'Eitan Bernath',
                        color: const Color(0xFFFF0000),
                        url: 'https://www.youtube.com/c/EitanBernath',
                        isDark: isDark,
                      ),
                      _buildSocialCard(
                        context,
                        icon: FontAwesomeIcons.globe,
                        name: 'Website',
                        handle: 'eitanbernath.com',
                        color: Colors.blue,
                        url: 'https://www.eitanbernath.com',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Newsletter Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242428) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mark_email_unread_outlined, color: primaryColor, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'VIP Newsletter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Get exclusive recipes, behind-the-scenes content, and event invites directly to your inbox.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thanks for subscribing!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('SUBSCRIBE', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialCard(BuildContext context, {
    required IconData icon,
    required String name,
    required String handle,
    required Color color,
    required String url,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open link')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isDark ? Colors.white12 : Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            Text(
              handle,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
