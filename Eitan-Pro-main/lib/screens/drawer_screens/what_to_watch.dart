import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../video_view_screen.dart';

class WhatToWatchScreen extends StatelessWidget {
  const WhatToWatchScreen({super.key});

  final List<Map<String, String>> _recentUploads = const [
    {
      'title': 'Ultimate 2024 Cooking Challenge', 
      'id': 'c-j1w5-z0XQ', 
      'views': '1.5M',
      'desc': 'A massive Indian feast and smashing cucumber salad hacks.'
    },
    {
      'title': 'World\'s Spiciest Chip Challenge', 
      'id': '5xW0hI8jF_E', 
      'views': '2.8M',
      'desc': 'Eitan takes on the viral Paqui One Chip Challenge.'
    },
    {
      'title': 'What I Eat In A Day (Young Chef)', 
      'id': '6v-tN199A6E', 
      'views': '450K',
      'desc': 'A look into the daily culinary life in NYC.'
    },
  ];

  final List<Map<String, String>> _series = const [
    {
      'title': 'Insatiable',
      'subtitle': 'Series: EP 01 Marcus Samuelsson',
      'id': 'j220vA-z7nU', 
      'description': 'Eitan hosts world-renowned chefs to discuss their culinary journeys.',
      'tag': 'AUTHENTIC',
    },
    {
      'title': 'Extreme Kitchens',
      'subtitle': 'Series: Cooking in a Moving Car',
      'id': 'kYv9r2oYlC0',
      'description': 'Watch Eitan cook a full gourmet meal in the back of a moving vehicle.',
      'tag': 'POPULAR',
    },
    {
      'title': 'Nah, We Make It At Home!',
      'subtitle': 'Series: Homemade Pizza',
      'id': '5mIu67H-8uM', 
      'description': 'Recreating the world\'s most famous dishes in Eitan\'s own kitchen.',
      'tag': 'ELITE',
    },
  ];

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _playInApp(BuildContext context, String id, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoViewScreen(videoId: id, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'EITAN WATCH',
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
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new, color: isDark ? Colors.white70 : Colors.black, size: 22),
            onPressed: () => _launchUrl('https://www.eitanbernath.com/'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
              child: Text(
                'Recent Uploads',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: isDark ? Colors.white : Colors.black),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentUploads.length,
              itemBuilder: (context, index) => _buildRecentUploadItem(context, _recentUploads[index], isDark),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
              child: Text(
                'Featured Series',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: isDark ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(
              height: 420, // Increased height to prevent overflow
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: _series.length,
                itemBuilder: (context, index) => _buildSeriesCard(context, _series[index], isDark),
              ),
            ),
            _buildTrustedSourcesFooter(isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800'),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 60),
            onPressed: () => _playInApp(context, 'c-j1w5-z0XQ', 'Latest: Ultimate Challenge'),
          ),
          const SizedBox(height: 10),
          const Text(
            'LATEST FROM EITAN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const Text(
            'New Episodes Every Week',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => _launchUrl('https://www.youtube.com/@EitanBernath'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('SUBSCRIBE'),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesCard(BuildContext context, Map<String, String> series, bool isDark) {
    return GestureDetector(
      onTap: () => _playInApp(context, series['id']!, series['title']!),
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    'https://i.ytimg.com/vi/${series['id']}/hqdefault.jpg',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 160,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      height: 160,
                      child: const Icon(Icons.video_library, color: Colors.grey, size: 50),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        series['tag']!,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      series['title']!,
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      series['subtitle']!,
                      style: const TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      series['description']!,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey[600], height: 1.3),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => _playInApp(context, series['id']!, series['title']!),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Center(child: Text('WATCH IN-APP', style: TextStyle(fontSize: 12))),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUploadItem(BuildContext context, Map<String, String> video, bool isDark) {
    return GestureDetector(
      onTap: () => _playInApp(context, video['id']!, video['title']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://i.ytimg.com/vi/${video['id']}/mqdefault.jpg',
                width: 120,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${video['views']} views',
                    style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_circle_outline, color: Colors.red),
              onPressed: () => _playInApp(context, video['id']!, video['title']!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustedSourcesFooter(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trusted Sources & Partners',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSourceIcon('https://www.tastemade.com/favicon.ico', 'Tastemade', 'https://www.tastemade.com', isDark),
              _buildSourceIcon('https://www.foodandwine.com/favicon.ico', 'Food & Wine', 'https://www.foodandwine.com', isDark),
              _buildSourceIcon('https://www.delish.com/favicon.ico', 'Delish', 'https://www.delish.com', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceIcon(String iconUrl, String label, String url, bool isDark) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                iconUrl,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.language, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: isDark ? Colors.white60 : Colors.black87)),
        ],
      ),
    );
  }
}
