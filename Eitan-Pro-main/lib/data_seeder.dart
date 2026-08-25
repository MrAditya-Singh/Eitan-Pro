
// Use this script to manually populate your Firestore 'recipes' collection.
// You can run this file temporarily in your app or use it as a reference for the Firebase Console.

/*
Data Structure for 'recipes' collection:
{
  "name": "Recipe Name",
  "description": "Short, appetizing description.",
  "image": "URL to a high-quality food image",
  "category": "Lunch", // Breakfast, Lunch, Dinner, Dessert
  "difficulty": "Easy", // Easy, Medium, Hard
  "cookTime": "15 mins",
  "ingredients": ["Pasta", "Garlic", "Butter", "Parsley"],
  "rating": 4.8
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedDatabase() async {
  final List<Map<String, dynamic>> recipes = [
    {
      "name": "Garlic Butter Pasta",
      "description": "Eitan's viral 10-minute pasta dinner. Rich, creamy, and garlic-packed.",
      "image": "https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=600",
      "category": "Dinner",
      "difficulty": "Easy",
      "cookTime": "15 mins",
      "rating": 4.9
    },
    {
      "name": "Ultimate Mac & Cheese",
      "description": "The cheesiest, creamiest mac and cheese with a crispy breadcrumb topping.",
      "image": "https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=600",
      "category": "Lunch",
      "difficulty": "Medium",
      "cookTime": "30 mins",
      "rating": 5.0
    },
    {
      "name": "Exotic Shakshuka",
      "description": "Poached eggs in a spicy tomato and pepper sauce. A Middle Eastern classic.",
      "image": "https://images.unsplash.com/photo-1590412200988-a436970781fa?w=600",
      "category": "Breakfast",
      "difficulty": "Medium",
      "cookTime": "25 mins",
      "rating": 4.7
    },
    {
      "name": "Crispy Chicken Schnitzel",
      "description": "Golden fried chicken breast with a secret spice blend coating.",
      "image": "https://images.unsplash.com/photo-1598103442097-8b74394b98c6?w=600",
      "category": "Dinner",
      "difficulty": "Medium",
      "cookTime": "40 mins",
      "rating": 4.8
    },
    {
      "name": "Avocado Toast Royale",
      "description": "Sourdough toast topped with smashed avocado, poached egg, and chili flakes.",
      "image": "https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=600",
      "category": "Breakfast",
      "difficulty": "Easy",
      "cookTime": "10 mins",
      "rating": 4.6
    },
    {
      "name": "Spicy Tuna Tartare",
      "description": "Fresh raw tuna cubes with sesame oil, soy sauce, and avocado.",
      "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600",
      "category": "Appetizer",
      "difficulty": "Hard",
      "cookTime": "20 mins",
      "rating": 4.9
    },
    {
      "name": "Classic Beef Burger",
      "description": "Juicy beef patty with cheddar, lettuce, tomato, and special sauce.",
      "image": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600",
      "category": "Dinner",
      "difficulty": "Medium",
      "cookTime": "25 mins",
      "rating": 4.7
    },
    {
      "name": "Vegan Buddha Bowl",
      "description": "Quinoa base with roasted chickpeas, avocado, and tahini dressing.",
      "image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600",
      "category": "Lunch",
      "difficulty": "Easy",
      "cookTime": "20 mins",
      "rating": 4.5
    },
    {
      "name": "Decadent Chocolate Cake",
      "description": "Rich, moist dark chocolate cake with ganache frosting.",
      "image": "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600",
      "category": "Dessert",
      "difficulty": "Medium",
      "cookTime": "60 mins",
      "rating": 5.0
    },
    {
      "name": "Berry Smoothie Bowl",
      "description": "Frozen berries blended with banana and topped with granola.",
      "image": "https://images.unsplash.com/photo-1626074353765-517a681e40be?w=600",
      "category": "Breakfast",
      "difficulty": "Easy",
      "cookTime": "5 mins",
      "rating": 4.8
    },
    {
      "name": "Grilled Salmon",
      "description": "Perfectly grilled salmon fillet with lemon butter sauce.",
      "image": "https://images.unsplash.com/photo-1485921325833-c519f76c4927?w=600",
      "category": "Dinner",
      "difficulty": "Medium",
      "cookTime": "25 mins",
      "rating": 4.9
    },
    {
      "name": "Caesar Salad",
      "description": "Crisp romaine lettuce with parmesan, croutons, and Caesar dressing.",
      "image": "https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=600",
      "category": "Lunch",
      "difficulty": "Easy",
      "cookTime": "15 mins",
      "rating": 4.6
    },
    {
      "name": "Tacos Al Pastor",
      "description": "Marinated pork tacos with pineapple, cilantro, and onions.",
      "image": "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=600",
      "category": "Dinner",
      "difficulty": "Hard",
      "cookTime": "45 mins",
      "rating": 4.9
    },
    {
      "name": "Mango Sticky Rice",
      "description": "Sweet coconut sticky rice served with fresh mango slices.",
      "image": "https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600",
      "category": "Dessert",
      "difficulty": "Medium",
      "cookTime": "35 mins",
      "rating": 4.8
    },
    {
      "name": "French Onion Soup",
      "description": "Caramelized onion soup topped with toasted baguette and gruyère.",
      "image": "https://images.unsplash.com/photo-1547592166-23acbe32263b?w=600",
      "category": "Lunch",
      "difficulty": "Medium",
      "cookTime": "50 mins",
      "rating": 4.7
    }
  ];

  final FirebaseFirestore db = FirebaseFirestore.instance;
  
  for (var recipe in recipes) {
    await db.collection('recipes').add(recipe);
  }
}
