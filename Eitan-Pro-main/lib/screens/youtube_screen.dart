import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeScreen extends StatefulWidget {
  const YouTubeScreen({super.key});

  @override
  State<YouTubeScreen> createState() => _YouTubeScreenState();
}

class _YouTubeScreenState extends State<YouTubeScreen> {
  final List<String> _videoIds = [
    'k2jZ0C5y000', // Cooking in Moving Car
    'jZ5aH_lGv94', // Cooking for Bill Gates
    '4n-QvG-Iq0U', // What I Eat in a Day
    'tYpLhV4uK4M', // Cooking in a Tent
    'Xh01jI958eI', // Rainbow Crepe Cake
    'p0k1yJ1bO3A', // Valentine's Steak
    'kY67wB1f534', // Homemade Pasta
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Cooking Tutorials', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: ListView.builder(
        itemCount: _videoIds.length,
        itemBuilder: (context, index) {
          final controller = YoutubePlayerController(
            initialVideoId: _videoIds[index],
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          );
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
