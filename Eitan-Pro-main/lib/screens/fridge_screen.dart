import 'package:flutter/material.dart';
import 'package:cook_app/services/ai_service.dart';
import 'package:cook_app/screens/cook_mode_screen.dart';
import 'package:cook_app/models/cook_mode_recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({super.key});

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  final AiService _aiService = AiService();
  List<Map<String, String>> _recipes = [];
  bool _isLoading = false;

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  void _findRecipes() async {
    if (_ingredients.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ingredientsString = _ingredients.join(', ');
      final user = FirebaseAuth.instance.currentUser;
      final recipeData = await _aiService.generateStructuredRecipe(
        ingredientsString,
        userId: user?.uid ?? 'guest',
      );

      if (recipeData != null && mounted) {
        final recipe = CookModeRecipe.fromJson(recipeData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CookModeScreen(
              videoTitle: recipe.title,
              videoUrl: 'AI Generated: $ingredientsString',
              initialRecipe: recipe,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating recipe: $e')),
        );
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
    const primaryColor = Color(0xFF00E676); // Green for fridge/freshness

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.green[50],
      appBar: AppBar(
        title: const Text("What's in My Fridge?", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                   // AI Info Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tips_and_updates_outlined, color: primaryColor),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Add items from your fridge, and Gemini will craft gourmet recipes just for you.',
                            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enter Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ingredientController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. Eggs, Milk, Spinach',
                                  filled: true,
                                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                ),
                                onSubmitted: (_) => _addIngredient(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: _addIngredient,
                              icon: const Icon(Icons.add_circle, color: primaryColor, size: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _ingredients.map((ing) => Chip(
                            label: Text(ing),
                            backgroundColor: primaryColor.withValues(alpha: 0.1),
                            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => setState(() => _ingredients.remove(ing)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                          )).toList(),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: _ingredients.isEmpty || _isLoading ? null : _findRecipes,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 8,
                              shadowColor: primaryColor.withValues(alpha: 0.4),
                            ),
                            icon: _isLoading 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.auto_awesome, size: 20),
                            label: Text(
                              _isLoading ? 'CONSULTING GEMINI...' : 'GENERATE RECIPES',
                              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          if (_recipes.isEmpty && !_isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.carrot, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text(
                      'Add items to find recipes',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final recipe = _recipes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      elevation: 3,
                      shadowColor: Colors.black.withValues(alpha: 0.1),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CookModeScreen(
                                videoTitle: recipe['title'],
                                videoUrl: 'AI Generated: ${recipe['title']}',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                                    child: const FaIcon(FontAwesomeIcons.utensils, color: primaryColor, size: 20),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      recipe['title']!,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                recipe['description']!,
                                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600], height: 1.5),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('COOK NOW', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12)),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.arrow_forward, size: 16, color: primaryColor),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _recipes.length,
                ),
              ),
            ),
            
           // Extra padding at bottom
           const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
