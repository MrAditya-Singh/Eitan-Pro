import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/ai_database_service.dart';

Future<void> seedAiDatabase() async {
  final aiDb = AiDatabaseService();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Check if we've already seeded to avoid duplicates (optional but good)
  final existing = await db.collection('recipes').limit(1).get();
  if (existing.docs.isNotEmpty) {
    print("✨ AI Database already has data. Skipping seeder.");
    return;
  }

  print("🚀 Seeding AI-Ready Database...");

  // Example 1: Garlic Butter Pasta
  await aiDb.addCuratedRecipe(
    {
      'title': 'Garlic Butter Pasta',
      'author': 'Eitan Bernath',
      'description': 'The 10-minute viral pasta that changed the internet.',
      'coverImage': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=800',
      'cookTime': '15 mins',
      'difficulty': 'Easy',
    },
    {
      'title': 'Viral Garlic Butter Pasta',
      'description': 'Rich, buttery, and packed with roasted garlic flavor.',
      'prepTime': 5,
      'cookTime': 10,
      'servings': 2,
      'difficulty': 'Easy',
      'tags': ['Quick', 'Pasta', 'Vegetarian'],
      'cuisine': 'Italian',
      'nutrition': {
        'calories': 450,
        'protein': 12,
        'carbs': 55,
        'fat': 22,
      },
      'ingredients': [
        {
          'id': 'spaghetti',
          'name': 'Spaghetti',
          'quantity': 200,
          'unit': 'grams',
          'category': 'carb',
          'optional': false,
        },
        {
          'id': 'garlic_cloves',
          'name': 'Garlic Cloves',
          'quantity': 6,
          'unit': 'pieces',
          'category': 'spice',
          'optional': false,
        },
        {
          'id': 'unsalted_butter',
          'name': 'Unsalted Butter',
          'quantity': 50,
          'unit': 'grams',
          'category': 'fat',
          'optional': false,
        },
      ],
      'steps': [
        {
          'stepNumber': 1,
          'instruction': 'Boil pasta in salted water until al dente.',
          'timer': 8,
          'ingredientsUsed': ['spaghetti'],
        },
        {
          'stepNumber': 2,
          'instruction': 'Saute minced garlic in butter until golden.',
          'timer': 3,
          'ingredientsUsed': ['garlic_cloves', 'unsalted_butter'],
        },
        {
          'stepNumber': 3,
          'instruction': 'Toss pasta with garlic butter and serve.',
          'timer': null,
          'ingredientsUsed': ['spaghetti', 'garlic_cloves', 'unsalted_butter'],
        }
      ],
    }
  );

  // Example 2: Ultimate Mac & Cheese
  await aiDb.addCuratedRecipe(
    {
      'title': 'Ultimate Mac & Cheese',
      'author': 'Eitan Bernath',
      'description': 'The creamiest five-cheese macaroni you will ever taste.',
      'coverImage': 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=800',
      'cookTime': '30 mins',
      'difficulty': 'Medium',
    },
    {
      'title': 'Creamy Five-Cheese Mac',
      'description': 'Heavy on the cheese, velvet texture, and a crunchy topping.',
      'prepTime': 15,
      'cookTime': 30,
      'servings': 4,
      'difficulty': 'Medium',
      'tags': ['Comfort Food', 'Cheese', 'Baking'],
      'cuisine': 'American',
      'nutrition': {
        'calories': 680,
        'protein': 28,
        'carbs': 42,
        'fat': 45,
      },
      'ingredients': [
        {
          'id': 'elbow_macaroni',
          'name': 'Elbow Macaroni',
          'quantity': 400,
          'unit': 'grams',
          'category': 'carb',
          'optional': false,
        },
        {
          'id': 'cheddar_cheese',
          'name': 'Sharp Cheddar',
          'quantity': 250,
          'unit': 'grams',
          'category': 'dairy',
          'optional': false,
        }
      ],
      'steps': [
        {
          'stepNumber': 1,
          'instruction': 'Make a roux with butter and flour.',
          'timer': 5,
          'ingredientsUsed': [],
        },
        {
          'stepNumber': 2,
          'instruction': 'Whisk in milk and cheese until smooth.',
          'timer': 10,
          'ingredientsUsed': ['cheddar_cheese'],
        },
        {
          'stepNumber': 3,
          'instruction': 'Bake with breadcrumbs until bubbly.',
          'timer': 15,
          'ingredientsUsed': [],
        }
      ],
    }
  );

  print("✅ AI Database Seeded Successfully!");
}
