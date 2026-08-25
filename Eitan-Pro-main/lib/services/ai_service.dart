import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cook_app/models/cook_mode_recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiService {
  // Use 10.0.2.2 for Android Emulator, or your PC's IP for physical device
  // e.g. 'http://192.168.1.15:3000'
  static const String _defaultBackendUrl = 'http://10.0.2.2:3000'; 
  String? _backendUrl;

  Future<void> _ensureInitialized() async {
    if (_backendUrl != null) return;
    
    final prefs = await SharedPreferences.getInstance();
    _backendUrl = prefs.getString('backend_url') ?? _defaultBackendUrl;
  }

  Future<void> setBackendUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    // Ensure URL has http/https
    if (!url.startsWith('http')) {
      url = 'http://$url';
    }
    // Remove trailing slash
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    await prefs.setString('backend_url', url);
    _backendUrl = url;
  }

  Future<String> getBackendUrl() async {
    await _ensureInitialized();
    return _backendUrl!;
  }

  // 1. Cook Mode Data
  Future<CookModeRecipe> generateCookModeData(String videoTitle, String? description) async {
    await _ensureInitialized();
    final url = Uri.parse('$_backendUrl/api/cook-mode');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'videoTitle': videoTitle,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return CookModeRecipe.fromJson(jsonDecode(response.body));
      } else {
        print('Backend Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Connection Error: $e');
    }
    return _getMockRecipe(videoTitle);
  }

  // 2. Chat with Chef
  Future<String> chatWithChef(String message, String recipeContext) async {
     await _ensureInitialized();
     final url = Uri.parse('$_backendUrl/api/chat');

     try {
       final response = await http.post(
         url,
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode({
           'message': message,
           'recipeContext': recipeContext,
         }),
       );

       if (response.statusCode == 200) {
         final data = jsonDecode(response.body);
         return data['reply'] ?? "I'm keeping my secrets for now.";
       }
     } catch (e) {
       return "Kitchen connection lost. Is the server running? ($e)";
     }
     return "I'm having trouble hearing you clearly, chef.";
  }

  // 3. Grocery List
  Future<List<Map<String, dynamic>>> generateGroceryList(String recipeInput) async {
    await _ensureInitialized();
    final url = Uri.parse('$_backendUrl/api/grocery-list');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'recipeInput': recipeInput}),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => {
          'name': item['name'],
          'quantity': item['quantity'],
          'checked': false,
        }).toList();
      }
    } catch (e) {
      print('Grocery Backend Error: $e');
    }
    return [];
  }

  // 4. Fridge Recipes (Legacy/Quick Suggest)
  Future<List<Map<String, String>>> suggestRecipes(List<String> ingredients) async {
    await _ensureInitialized();
    final url = Uri.parse('$_backendUrl/api/fridge-recipes');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': ingredients}),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => {
          'title': item['title'].toString(),
          'description': item['description'].toString(),
        }).toList();
      }
    } catch (e) {
      print('Fridge Backend Error: $e');
    }
    return [];
  }

  // 4b. Structured AI Generation (The New Elite Pipeline)
  Future<Map<String, dynamic>?> generateStructuredRecipe(String ingredients, {String? userId}) async {
    await _ensureInitialized();
    final url = Uri.parse('$_backendUrl/api/generate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ingredients': ingredients,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Generation Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Connection Error to Backend: $e');
    }
    return null;
  }

  // 5. Fetch All Recipes
  Future<List<dynamic>> fetchRecipes() async {
    await _ensureInitialized();
    final url = Uri.parse('$_backendUrl/api/recipes');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Fetch Recipes Error: $e');
    }
    return [];
  }

  CookModeRecipe _getMockRecipe(String title) {
    return CookModeRecipe(
      title: title.isEmpty ? 'Delicious Mock Recipe' : title,
      steps: [
        CookStep(
          stepNumber: 1,
          instruction: 'Heat 2 tbsp of olive oil in a large skillet over medium-high heat.',
          ingredientsHighlighted: ['Olive Oil'],
          voiceShortcut: 'Next',
        ),
        CookStep(
          stepNumber: 2,
          instruction: 'Add the chopped onions and garlic. Sauté for 3-5 minutes until translucent.',
          ingredientsHighlighted: ['Onions', 'Garlic'],
          timerDurationSeconds: 180,
          voiceShortcut: 'Start Timer',
        ),
        CookStep(
          stepNumber: 3,
          instruction: 'Pour in the crushed tomatoes and bring to a simmer. Season with salt and pepper.',
          ingredientsHighlighted: ['Crushed Tomatoes', 'Salt', 'Pepper'],
          timerDurationSeconds: 600,
        ),
        CookStep(
          stepNumber: 4,
          instruction: 'Taste and adjust seasoning. Serve hot with fresh basil.',
          ingredientsHighlighted: ['Basil'],
        ),
      ],
    );
  }
}
