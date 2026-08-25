import 'package:flutter/material.dart';
import 'package:cook_app/services/ai_service.dart';
import 'package:cook_app/screens/cook_mode_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final AiService _aiService = AiService();
  List<dynamic> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final recipes = await _aiService.fetchRecipes();
    if (mounted) {
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFFE91E63); // Pinkish for Cookbook theme

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.pink[50],
      appBar: AppBar(
        title: const Text('My Cookbook', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = _recipes[index];
                        return _buildRecipeCard(recipe, isDark, primaryColor);
                      },
                      childCount: _recipes.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRecipeCard(dynamic recipe, bool isDark, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CookModeScreen(
              videoTitle: recipe['title'],
              videoUrl: 'My Cookbook Recipe: ${recipe['title']}',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  recipe['image'] ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recipe['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 12, color: isDark ? Colors.white54 : Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          recipe['time'] ?? 'N/A',
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.grey),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            recipe['difficulty'] ?? 'Easy',
                            style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
