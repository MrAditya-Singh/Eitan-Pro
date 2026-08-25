import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cook_app/screens/cook_mode_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cook_app/services/ai_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchMode = 'Cookbook'; // 'Cookbook', 'AI', 'Google'
  List<Map<String, dynamic>> _cookbookResults = [];
  String _aiResponse = '';
  bool _isLoading = false;

  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _cookbookResults = [];
      _aiResponse = '';
    });

    try {
      if (_searchMode == 'Cookbook') {
        final results = await FirebaseFirestore.instance
            .collection('recipes')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: '$query\uf8ff')
            .get();
        setState(() {
          _cookbookResults = results.docs.map((doc) => doc.data()).toList();
        });
      } else if (_searchMode == 'AI') {
        // Use AiService to generate recipe
        final aiService = AiService();
        final response = await aiService.chatWithChef(
          'Give me a detailed recipe for: $query. Include ingredients and steps.',
          'User is asking for a recipe.',
        );
        setState(() {
          _aiResponse = response;
        });
      } else if (_searchMode == 'Google') {
        final url = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent('$query recipe')}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not launch Google Search')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiResponse = 'Error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Search Recipes', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for recipes...',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                  prefixIcon: Icon(CupertinoIcons.search, color: isDark ? Colors.white70 : Colors.black54),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: isDark ? const Color(0xFF72CFCF) : Colors.black),
                    onPressed: _performSearch,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildModeChip('Cookbook', Icons.book),
                const SizedBox(width: 10),
                _buildModeChip('AI', Icons.auto_awesome),
                const SizedBox(width: 10),
                _buildModeChip('Google', Icons.public),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String mode, IconData icon) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _searchMode == mode;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54)),
          const SizedBox(width: 8),
          Text(mode),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _searchMode = mode;
          });
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
      selectedColor: const Color(0xFF72CFCF),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
    );
  }

  Widget _buildResults() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (_searchMode == 'Cookbook') {
      if (_cookbookResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 60, color: isDark ? Colors.white12 : Colors.grey[300]),
              const SizedBox(height: 15),
              Text(
                'No recipes found in your cookbook.', 
                style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.w500)
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cookbookResults.length,
        itemBuilder: (context, index) {
          final recipe = _cookbookResults[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF242428) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02), blurRadius: 10),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe['image'] ?? 'https://via.placeholder.com/150',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                recipe['name'] ?? 'Untitled',
                style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              ),
              subtitle: Text(
                recipe['description'] ?? 'No description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                // Navigate to Detail
              },
            ),
          );
        },
      );
    } else if (_searchMode == 'AI') {
      if (_aiResponse.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 60, color: isDark ? Colors.white12 : Colors.grey[300]),
              const SizedBox(height: 15),
              Text(
                'Enter a dish name to get an AI recipe!',
                style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.w500)
              ),
            ],
          ),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF242428) : Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white10 : Colors.blue.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF72CFCF), size: 18),
                  const SizedBox(width: 10),
                  Text('AI CHEF RESPONSE', style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? Colors.white38 : Colors.blue[300],
                    letterSpacing: 1.2
                  )),
                ],
              ),
              const Divider(height: 30),
              Text(
                _aiResponse,
                style: TextStyle(fontSize: 16, height: 1.6, color: isDark ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CookModeScreen(
                          videoTitle: 'AI Recipe: ${_searchController.text}',
                          videoUrl: _aiResponse, // Using response as context for parsing
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.fireBurner),
                  label: const Text('START COOK MODE', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public_rounded, size: 60, color: isDark ? Colors.white12 : Colors.grey[300]),
            const SizedBox(height: 15),
            Text(
              'Search results will open in your browser.', 
              style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      );
    }
  }
}
