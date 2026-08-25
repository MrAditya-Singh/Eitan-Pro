import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatToAttendScreen extends StatelessWidget {
  const WhatToAttendScreen({super.key});

  final List<Map<String, String>> events = const [
    {
      'title': 'NYC FOOD FESTIVAL', 
      'subtitle': 'Live Cooking Demo',
      'date': 'NOV 15, 2024', 
      'location': 'New York City, NY',
      'url': 'https://www.eitanbernath.com/'
    },
    {
      'title': 'BOOK SIGNING TOUR', 
      'subtitle': 'Eitan Eats the World',
      'date': 'DEC 05, 2024', 
      'location': 'Los Angeles, CA',
      'url': 'https://www.eitanbernath.com/'
    },
    {
      'title': 'CULINARY MASTERCLASS', 
      'subtitle': 'VIP Experience',
      'date': 'FEB 12, 2025', 
      'location': 'Miami, FL',
      'url': 'https://www.eitanbernath.com/'
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
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'GLOBAL EVENTS',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900, 
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0
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
      body: ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: events.length,
        itemBuilder: (context, index) => _buildEventCard(events[index], isDark),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event, bool isDark) {
    return GestureDetector(
      onTap: () => _launchUrl(event['url']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: (isDark ? Colors.orangeAccent : Colors.orange).withValues(alpha: 0.05), blurRadius: 40, spreadRadius: -10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event['date']!,
                  style: const TextStyle(color: Color(0xFFFFCC80), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2),
                ),
                const Icon(Icons.star_outline, color: Colors.amber, size: 18),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              event['title']!,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
            ),
            Text(
              event['subtitle']!,
              style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Icon(Icons.location_on, color: isDark ? Colors.white24 : Colors.grey[400], size: 16),
                const SizedBox(width: 8),
                Text(
                  event['location']!,
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFCC80), Color(0xFFE65100)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'RESERVE SPOT',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
