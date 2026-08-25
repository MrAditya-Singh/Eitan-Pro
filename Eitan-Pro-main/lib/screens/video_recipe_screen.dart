import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cook_app/screens/cook_mode_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoRecipeScreen extends StatefulWidget {
  const VideoRecipeScreen({super.key});

  @override
  State<VideoRecipeScreen> createState() => _VideoRecipeScreenState();
}

class _VideoRecipeScreenState extends State<VideoRecipeScreen> {
  final TextEditingController _urlController = TextEditingController();
  
  // Featured Eitan Videos that are confirmed working
  final List<Map<String, String>> _featuredVideos = [
    {
      'id': 'c-j1w5-z0XQ',
      'title': 'Ultimate Gourmet Burger',
      'duration': '12:45',
    },
    {
      'id': 't63yH3C_sJ0',
      'title': 'High Energy Breakfast',
      'duration': '08:30',
    },
    {
      'id': 'Y8D4M6-y7kY',
      'title': 'Garlic Butter Pasta',
      'duration': '10:15',
    },
     {
      'id': 'pGvX_eYJ-s0',
      'title': 'Creamy Mac & Cheese',
      'duration': '09:20',
    },
  ];

  void _extractFromUrl(String url) {
    if (url.isEmpty) return;
    String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CookModeScreen(
            videoTitle: 'Recipe from Video',
            videoUrl: url,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid YouTube URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFFF0000); // YouTube Red

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text('VIDEO TO RECIPE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Vision Mode',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          'Paste a video link and Gemini will extract the full recipe for you!',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // URL Input
            Text(
              'PASTE VIDEO LINK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white54 : Colors.grey,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'https://youtube.com/watch?v=...',
                filled: true,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.link, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, color: Colors.red),
                  onPressed: () => _extractFromUrl(_urlController.text),
                ),
              ),
              onSubmitted: _extractFromUrl,
            ),

            const SizedBox(height: 40),

            // Featured List
            Text(
              'FEATURED TUTORIALS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white54 : Colors.grey,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _featuredVideos.length,
              itemBuilder: (context, index) {
                final video = _featuredVideos[index];
                return _buildVideoCard(video, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(Map<String, String> video, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  'https://img.youtube.com/vi/${video['id']}/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CookModeScreen(
                        videoTitle: video['title'],
                        videoUrl: 'https://youtube.com/watch?v=${video['id']}',
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(video['duration']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(width: 15),
                          const Icon(Icons.auto_awesome, size: 14, color: Colors.blueAccent),
                          const SizedBox(width: 5),
                          const Text('AI Ready', style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CookModeScreen(
                          videoTitle: video['title'],
                          videoUrl: 'https://youtube.com/watch?v=${video['id']}',
                        ),
                      ),
                    );
                  },
                  child: const Text('COOK NOW', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
