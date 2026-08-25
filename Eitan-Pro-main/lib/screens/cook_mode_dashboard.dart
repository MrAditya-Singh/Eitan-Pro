import 'package:flutter/material.dart';
import 'package:cook_app/screens/cook_mode_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CookModeDashboard extends StatefulWidget {
  final VoidCallback onGoToSearch;

  const CookModeDashboard({super.key, required this.onGoToSearch});

  @override
  State<CookModeDashboard> createState() => _CookModeDashboardState();
}

class _CookModeDashboardState extends State<CookModeDashboard> {
  final TextEditingController _urlController = TextEditingController();

  void _startFromUrl() {
    if (_urlController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CookModeScreen(
            videoTitle: 'Recipe from URL',
            videoUrl: _urlController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const FaIcon(FontAwesomeIcons.fireBurner, size: 80, color: Color(0xFF2979FF)),
              const SizedBox(height: 20),
              Text(
                'COOK MODE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your immersive AI cooking assistant.',
                style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
              ),
              const SizedBox(height: 40),
              
              // Paste Link
              TextField(
                controller: _urlController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Paste YouTube URL...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.link, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Color(0xFF2979FF)),
                    onPressed: _startFromUrl,
                  ),
                ),
                onSubmitted: (_) => _startFromUrl(),
              ),
              const SizedBox(height: 20),
              
              // Or Search
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: widget.onGoToSearch,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2979FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: const Icon(Icons.search, color: Color(0xFF2979FF)),
                  label: const Text('SEARCH FOR RECIPES', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                ),
              ),
              
              const SizedBox(height: 40),
              Align(alignment: Alignment.centerLeft, child: Text('RECENT', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black54))),
              const SizedBox(height: 10),
              // Mock Recent
              _buildRecentTile(isDark, 'Spicy Ramen', '15 mins'),
              _buildRecentTile(isDark, 'Garlic Bread', '10 mins'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTile(bool isDark, String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // decoration: BoxDecoration(
      //   color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF2979FF).withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.history, color: Color(0xFF2979FF), size: 18),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        subtitle: Text(time, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
               builder: (context) => CookModeScreen(videoTitle: title, videoUrl: 'mock'),
            ),
          );
        },
      ),
    );
  }
}
