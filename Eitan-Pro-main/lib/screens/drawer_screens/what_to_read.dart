import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatToReadScreen extends StatelessWidget {
  const WhatToReadScreen({super.key});

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
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: Text(
          'ELITE READS',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900, 
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookShowcase(isDark),
            const SizedBox(height: 40),
            const Text(
              'LIFESTYLE & STORIES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFCE93D8), letterSpacing: 2.5),
            ),
            const SizedBox(height: 20),
            _buildExoticArticle(
              'THE ULTIMATE PIZZA GUIDE', 
              'Everything you need to know about dough mastery.',
              'https://www.eitanbernath.com/tag/pizza/',
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
              isDark
            ),
            _buildExoticArticle(
              'KITCHEN ESSENTIALS 2024', 
              'The 5 tools every modern home cook needs.',
              'https://www.eitanbernath.com/category/lifestyle/',
              'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400',
              isDark
            ),
            _buildExoticArticle(
              'HOLIDAY ENTERTAINING', 
              'Impress your guests with elite hosting tips.',
              'https://www.eitanbernath.com/category/recipes/holiday/',
              'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?w=400',
              isDark
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookShowcase(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(5, 5)),
              ],
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1589998059171-988d887df646?w=400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eitan Eats the World',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.1, color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 5),
                const Text('By Eitan Bernath', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 12),
                Text(
                  'Explore Eitan\'s New York Times Bestseller comfort classics.',
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _launchUrl('https://www.eitanbernath.com/book/'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF3A9E9E) : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('SHOP BOOK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExoticArticle(String title, String subtitle, String url, String imageUrl, bool isDark) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imageUrl, width: 90, height: 90, fit: BoxFit.cover),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: isDark ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle, 
                    style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[600], fontSize: 13, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white24 : Colors.black12),
          ],
        ),
      ),
    );
  }
}
