import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InTheNewsScreen extends StatelessWidget {
  const InTheNewsScreen({super.key});

  final List<Map<String, String>> news = const [
    {
      'title': 'Eitan Bernath: The Chef of Gen Z', 
      'source': 'The New York Times', 
      'date': 'Global Press',
      'url': 'https://www.eitanbernath.com/press/',
      'image': 'https://images.unsplash.com/photo-1585241936939-be4099591252?w=400'
    },
    {
      'title': 'How Social Media is Changing Fine Dining', 
      'source': 'Forbes', 
      'date': 'Industry Insights',
      'url': 'https://www.eitanbernath.com/press/',
      'image': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400'
    },
    {
      'title': 'Cooking with Eitan: A Journey', 
      'source': 'Food & Wine', 
      'date': 'Culinary Focus',
      'url': 'https://www.eitanbernath.com/press/',
      'image': 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=400'
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
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'IN THE NEWS',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900, 
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: news.length,
        itemBuilder: (context, index) => _buildNewsCard(news[index], isDark),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, String> item, bool isDark) {
    return GestureDetector(
      onTap: () => _launchUrl(item['url']!),
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(item['image']!),
            fit: BoxFit.cover,
            opacity: isDark ? 0.4 : 0.6,
          ),
          border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark 
                ? [Colors.black.withValues(alpha: 0.9), Colors.transparent]
                : [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.1)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['source']!.toUpperCase(),
                style: TextStyle(
                  color: isDark ? const Color(0xFFCFD8DC) : Colors.black54, 
                  fontWeight: FontWeight.w900, 
                  fontSize: 12, 
                  letterSpacing: 2
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item['title']!,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black, 
                  fontSize: 20, 
                  fontWeight: FontWeight.w900,
                  height: 1.2
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  item['date']!,
                  style: TextStyle(color: isDark ? Colors.white60 : Colors.black45, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
