import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhatToShareScreen extends StatelessWidget {
  const WhatToShareScreen({super.key});

  final List<Map<String, dynamic>> _socials = const [
    {
      'name': 'Instagram',
      'handle': '@eitan',
      'url': 'https://www.instagram.com/eitan/',
      'color': Color(0xFFE1306C),
      'icon': FontAwesomeIcons.instagram,
    },
    {
      'name': 'TikTok',
      'handle': '@eitan',
      'url': 'https://www.tiktok.com/@eitan',
      'color': Color(0xFF000000),
      'icon': FontAwesomeIcons.tiktok,
    },
    {
      'name': 'YouTube',
      'handle': 'Eitan Bernath',
      'url': 'https://www.youtube.com/@eitan',
      'color': Color(0xFFFF0000),
      'icon': FontAwesomeIcons.youtube,
    },
    {
      'name': 'Twitter',
      'handle': '@eitanbernath',
      'url': 'https://twitter.com/eitanbernath',
      'color': Color(0xFF1DA1F2),
      'icon': FontAwesomeIcons.twitter,
    },
    {
      'name': 'Official Website',
      'handle': 'eitanbernath.com',
      'url': 'https://www.eitanbernath.com/',
      'color': Color(0xFF3A9E9E),
      'icon': Icons.language,
    },
  ];

  final List<Map<String, String>> _featuredRecipes = const [
    {
      'title': 'Garlic Butter Pasta',
      'image': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=600',
      'url': 'https://www.eitanbernath.com/2021/04/05/garlic-butter-pasta/',
    },
    {
      'title': 'Ultimate Mac & Cheese',
      'image': 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=600',
      'url': 'https://www.eitanbernath.com/2020/12/14/ultimate-mac-cheese/',
    },
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'CONNECT & SHARE',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.2
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
              child: Text(
                'Eitan\'s Universe',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: isDark ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: _socials.length,
                itemBuilder: (context, index) => _buildSocialCircle(_socials[index], isDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Text(
                'Share Top Recipes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: isDark ? Colors.white : Colors.black),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _featuredRecipes.length,
              itemBuilder: (context, index) => _buildRecipeShareCard(_featuredRecipes[index], isDark),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3A9E9E), Color(0xFF1F5858)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.share_rounded, color: Colors.white, size: 50),
          SizedBox(height: 15),
          Text(
            'JOIN THE CULINARY REVOLUTION',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            'Follow Eitan across all platforms for daily recipes and fun!',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCircle(Map<String, dynamic> social, bool isDark) {
    return GestureDetector(
      onTap: () => _launchUrl(social['url']),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(social['icon'] as IconData, color: social['color'] as Color, size: 30),
            const SizedBox(height: 10),
            Text(
              social['name'] as String,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.white : Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              social['handle'] as String,
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeShareCard(Map<String, String> recipe, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Image.network(
              recipe['image']!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['title']!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                      ),
                      Text('Ready to be shared with friends!', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(recipe['url']!),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('SHARE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A9E9E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
