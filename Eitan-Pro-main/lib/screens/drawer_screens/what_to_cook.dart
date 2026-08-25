import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatToCookScreen extends StatelessWidget {
  const WhatToCookScreen({super.key});

  final List<Map<String, String>> categories = const [
    {
      'title': 'RECIPES',
      'subtitle': 'The Full Collection',
      'url': 'https://www.eitanbernath.com/category/recipes/',
      'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80'
    },
    {
      'title': 'GLOBAL',
      'subtitle': 'International Cuisines',
      'url': 'https://www.eitanbernath.com/category/recipes/international/',
      'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80'
    },
    {
      'title': 'QUICK',
      'subtitle': 'Fast & Delicious',
      'url': 'https://www.eitanbernath.com/category/recipes/quick-easy/',
      'image': 'https://images.unsplash.com/photo-1541529086526-db283c563270?w=800&q=80'
    },
    {
      'title': 'BAKING',
      'subtitle': 'Sweets & Treats',
      'url': 'https://www.eitanbernath.com/category/recipes/desserts/',
      'image': 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=600&q=80'
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
          'CULINARY CRAFT',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900, 
            fontStyle: FontStyle.italic,
            letterSpacing: 1.5
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MASTER THE KITCHEN',
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900, 
                color: isDark ? const Color(0xFF72CFCF) : const Color(0xFF1F5858),
                letterSpacing: -0.5
              ),
            ),
            Text(
              'Explore Eitan\'s exclusive recipe vault',
              style: TextStyle(fontSize: 14, color: isDark ? Colors.white38 : Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildExoticCard(categories[index], isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExoticCard(Map<String, String> category, bool isDark) {
    return GestureDetector(
      onTap: () => _launchUrl(category['url']!),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                category['image']!, 
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['subtitle']!,
                      style: const TextStyle(
                        color: Color(0xFF72CFCF),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2
                      ),
                    ),
                    Text(
                      category['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Icon(Icons.arrow_right_alt, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
