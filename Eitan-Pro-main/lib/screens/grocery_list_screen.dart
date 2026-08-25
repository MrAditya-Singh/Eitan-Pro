import 'package:flutter/material.dart';
import 'package:cook_app/services/ai_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GroceryListScreen extends StatefulWidget {
  final String? initialQuery;
  const GroceryListScreen({super.key, this.initialQuery});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  late TextEditingController _controller;
  final AiService _aiService = AiService();
  List<Map<String, dynamic>> _groceryList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateList() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _groceryList = [];
    });

    final list = await _aiService.generateGroceryList(_controller.text);

    setState(() {
      _groceryList = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF2979FF);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: const Text('AI Grocery List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Input Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'What are you cooking?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Gemini will analyze the ingredients needed.',
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.grey),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'e.g. Italian Lasagna for 4...',
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.restaurant, color: primaryColor),
                  ),
                  onSubmitted: (_) => _generateList(),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _generateList,
                    icon: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, size: 20),
                    label: Text(
                      _isLoading ? 'ANALYZING RECIPE...' : 'GENERATE SHOPPING LIST',
                      style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 8,
                      shadowColor: primaryColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List Section
          Expanded(
            child: _groceryList.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.basketShopping, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 20),
                        Text(
                          'Your list is empty',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _groceryList.length,
                    itemBuilder: (context, index) {
                      final item = _groceryList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5)
                          ],
                        ),
                        child: CheckboxListTile(
                          value: item['checked'] ?? false,
                          activeColor: primaryColor,
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          title: Text(
                            item['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: item['checked'] == true ? TextDecoration.lineThrough : null,
                              color: item['checked'] == true ? Colors.grey : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                          subtitle: Text(
                            item['quantity'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          secondary: Container(
                             padding: const EdgeInsets.all(8),
                             decoration: BoxDecoration(
                               color: primaryColor.withValues(alpha: 0.1),
                               shape: BoxShape.circle,
                             ),
                             child: FaIcon(FontAwesomeIcons.carrot, size: 16, color: primaryColor),
                          ),
                          onChanged: (val) {
                            setState(() {
                              item['checked'] = val;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
