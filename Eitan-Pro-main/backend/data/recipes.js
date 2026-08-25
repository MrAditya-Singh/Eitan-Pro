const recipes = [
    {
        id: 1,
        title: "Classic Spaghetti Carbonara",
        description: "A traditional Roman pasta dish made with eggs, hard cheese, cured pork, and black pepper.",
        image: "https://images.unsplash.com/photo-1612874742237-fa5237f4abd3?w=500&auto=format&fit=crop&q=60",
        time: "20 min",
        difficulty: "Medium",
        calories: "450 kcal",
        ingredients: [
            "400g Spaghetti",
            "200g Pancetta or Guanciale",
            "4 Large Eggs",
            "100g Pecorino Romano cheese",
            "Black Pepper",
            "Salt"
        ],
        steps: [
            "Boil water in a large pot with salt.",
            "Cut pancetta into small cubes and fry until crispy.",
            "Whisk eggs and grated cheese in a bowl with plenty of black pepper.",
            "Cook pasta until al dente.",
            "Mix hot pasta with egg mixture quickly to create a creamy sauce.",
            "Add crispy pancetta and serve immediately."
        ]
    },
    {
        id: 2,
        title: "Homemade Margherita Pizza",
        description: "Simple yet delicious pizza with fresh basil, mozzarella, and tomato sauce.",
        image: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500&auto=format&fit=crop&q=60",
        time: "45 min",
        difficulty: "Medium",
        calories: "600 kcal",
        ingredients: ["Pizza Dough", "San Marzano Tomatoes", "Fresh Mozzarella", "Fresh Basil", "Olive Oil"],
        steps: ["Preheat oven to max temp.", "Stretch dough.", "Add sauce and cheese.", "Bake until golden.", "Top with basil."]
    },
    {
        id: 3,
        title: "Avocado Toast",
        description: "Creamy avocado on toasted sourdough bread, topped with chili flakes and poached egg.",
        image: "https://images.unsplash.com/photo-1588137372308-15f7b5b373ae?w=500&auto=format&fit=crop&q=60",
        time: "10 min",
        difficulty: "Easy",
        calories: "320 kcal",
        ingredients: ["Sourdough Bread", "Ripe Avocado", "Red Chili Flakes", "Lemon Juice", "Poached Egg (optional)"],
        steps: ["Toast the bread.", "Mash avocado with lemon and salt.", "Spread on toast.", "Sprinkle chili flakes."]
    },
    {
        id: 4,
        title: "Chicken Tikka Masala",
        description: "Roasted marinated chicken chunks in spiced curry sauce.",
        image: "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=500&auto=format&fit=crop&q=60",
        time: "60 min",
        difficulty: "Hard",
        calories: "550 kcal",
        ingredients: ["Chicken Breast", "Yogurt", "Tomato Puree", "Cream", "Garam Masala", "Cumin", "Coriander"],
        steps: ["Marinate chicken in yogurt and spices.", "Grill chicken.", "Simmer tomato sauce with spices.", "Add cream and chicken."]
    },
    {
        id: 5,
        title: "Berry Smoothie",
        description: "A refreshing blend of mixed berries, yogurt, and honey.",
        image: "https://images.unsplash.com/photo-1553531384-cc64ac80f931?w=500&auto=format&fit=crop&q=60",
        time: "5 min",
        difficulty: "Easy",
        calories: "200 kcal",
        ingredients: ["Mixed Berries (frozen)", "Banana", "Greek Yogurt", "Milk of choice", "Honey"],
        steps: ["Add all ingredients to blender.", "Blend until smooth.", "Serve chilled."]
    },
    {
        id: 6,
        title: "Beef Tacos",
        description: "Spiced ground beef served in corn tortillas with fresh toppings.",
        image: "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=500&auto=format&fit=crop&q=60",
        time: "25 min",
        difficulty: "Easy",
        calories: "400 kcal",
        ingredients: ["Ground Beef", "Taco Seasoning", "Corn Tortillas", "Lettuce", "Cheese", "Salsa"],
        steps: ["Brown the beef.", "Add seasoning.", "Warm tortillas.", "Assemble tacos."]
    },
    {
        id: 7,
        title: "Caesar Salad",
        description: "Crisp romaine lettuce with croutons, parmesan cheese, and caesar dressing.",
        image: "https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=500&auto=format&fit=crop&q=60",
        time: "15 min",
        difficulty: "Easy",
        calories: "350 kcal",
        ingredients: ["Romaine Lettuce", "Croutons", "Parmesan Cheese", "Caesar Dressing", "Lemon Juice"],
        steps: ["Chop lettuce.", "Toss with dressing.", "Top with croutons and cheese."]
    },
    {
        id: 8,
        title: "Pancakes",
        description: "Fluffy breakfast pancakes served with maple syrup and butter.",
        image: "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500&auto=format&fit=crop&q=60",
        time: "20 min",
        difficulty: "Medium",
        calories: "400 kcal",
        ingredients: ["Flour", "Milk", "Egg", "Baking Powder", "Sugar", "Butter"],
        steps: ["Mix dry ingredients.", "Whisk wet ingredients.", "Combine.", "Cook on griddle."]
    },
    {
        id: 9,
        title: "Grilled Salmon",
        description: "Fresh salmon fillet grilled to perfection with lemon and herbs.",
        image: "https://images.unsplash.com/photo-1485921325833-c519f76c4927?w=500&auto=format&fit=crop&q=60",
        time: "15 min",
        difficulty: "Medium",
        calories: "450 kcal",
        ingredients: ["Salmon Fillet", "Lemon", "Dill", "Olive Oil", "Salt", "Pepper"],
        steps: ["Season salmon.", "Preheat grill.", "Grill 4-5 mins per side.", "Serve with lemon."]
    },
    {
        id: 10,
        title: "Vegetable Stir Fry",
        description: "Quick and healthy mix of colorful vegetables in a savory sauce.",
        image: "https://images.unsplash.com/photo-1527068589345-b77c0643e14f?w=500&auto=format&fit=crop&q=60",
        time: "15 min",
        difficulty: "Easy",
        calories: "250 kcal",
        ingredients: ["Broccoli", "Carrots", "Bell Peppers", "Soy Sauce", "Ginger", "Garlic"],
        steps: ["Chop veggies.", "Stir fry garlic and ginger.", "Add veggies.", "Add sauce and serve."]
    },
    {
        id: 11,
        title: "Mushroom Risotto",
        description: "Creamy Italian rice dish cooked with broth and wild mushrooms.",
        image: "https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=500&auto=format&fit=crop&q=60",
        time: "40 min",
        difficulty: "Hard",
        calories: "500 kcal",
        ingredients: ["Arborio Rice", "Mushrooms", "Vegetable Broth", "White Wine", "Parmesan", "Butter"],
        steps: ["Sauté mushrooms.", "Toast rice.", "Add wine.", "Add broth gradually while stirring.", "Finish with butter and cheese."]
    },
    {
        id: 12,
        title: "Greek Salad",
        description: "Fresh salad with cucumbers, tomatoes, feta cheese, and olives.",
        image: "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500&auto=format&fit=crop&q=60",
        time: "10 min",
        difficulty: "Easy",
        calories: "300 kcal",
        ingredients: ["Cucumber", "Tomato", "Red Onion", "Feta Cheese", "Kalamata Olives", "Oregano"],
        steps: ["Chop vegetables.", "Combine in bowl.", "Add feta and olives.", "Drizzle with olive oil."]
    },
    {
        id: 13,
        title: "Chocolate Chip Cookies",
        description: "Classic chewy cookies loaded with chocolate chips.",
        image: "https://images.unsplash.com/photo-1499636138143-bd649043ea52?w=500&auto=format&fit=crop&q=60",
        time: "30 min",
        difficulty: "Medium",
        calories: "150 kcal (per cookie)",
        ingredients: ["Butter", "Sugar", "Flour", "Chocolate Chips", "Egg", "Vanilla"],
        steps: ["Cream butter and sugar.", "Add egg.", "Mix dry ingredients.", "Fold in chips.", "Bake."]
    },
    {
        id: 14,
        title: "French Toast",
        description: "Bread dipped in spiced custard and fried until golden.",
        image: "https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=500&auto=format&fit=crop&q=60",
        time: "15 min",
        difficulty: "Easy",
        calories: "380 kcal",
        ingredients: ["Bread Slices", "Eggs", "Milk", "Cinnamon", "Vanilla Extract", "Butter"],
        steps: ["Whisk eggs, milk, cinnamon.", "Dip bread.", "Fry in butter.", "Serve with syrup."]
    },
    {
        id: 15,
        title: "Shrimp Scampi",
        description: "Shrimp cooked in garlic, butter, lemon, and white wine sauce.",
        image: "https://images.unsplash.com/photo-1625938146369-adc83368bda7?w=500&auto=format&fit=crop&q=60",
        time: "20 min",
        difficulty: "Medium",
        calories: "420 kcal",
        ingredients: ["Shrimp", "Linguine", "Garlic", "Butter", "Lemon", "Parsley"],
        steps: ["Cook pasta.", "Sauté garlic.", "Add shrimp.", "Add lemon and butter.", "Toss with pasta."]
    },
    {
        id: 16,
        title: "Caprese Salad",
        description: "Simple Italian salad made of sliced fresh mozzarella, tomatoes, and sweet basil.",
        image: "https://images.unsplash.com/photo-1529312266912-b33cf6227e2f?w=500&auto=format&fit=crop&q=60",
        time: "10 min",
        difficulty: "Easy",
        calories: "280 kcal",
        ingredients: ["Fresh Mozzarella", "Tomatoes", "Fresh Basil", "Balsamic Glaze", "Olive Oil"],
        steps: ["Slice tomatoes and mozzarella.", "Layer with basil.", "Drizzle with oil and balsamic."]
    },
    {
        id: 17,
        title: "Lemon Herb Chicken",
        description: "Juicy roasted chicken flavored with lemon, rosemary, and thyme.",
        image: "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&auto=format&fit=crop&q=60",
        time: "50 min",
        difficulty: "Medium",
        calories: "480 kcal",
        ingredients: ["Chicken Thighs", "Lemon", "Rosemary", "Thyme", "Garlic", "Olive Oil"],
        steps: ["Marinate chicken.", "Preheat oven.", "Roast until golden and cooked through."]
    },
    {
        id: 18,
        title: "Vegetable Soup",
        description: "Hearty and warming soup packed with seasonal vegetables.",
        image: "https://images.unsplash.com/photo-1547592166-23acbe34071b?w=500&auto=format&fit=crop&q=60",
        time: "40 min",
        difficulty: "Easy",
        calories: "180 kcal",
        ingredients: ["Carrots", "Celery", "Potatoes", "Tomatoes", "Broth", "Herbs"],
        steps: ["Sauté aromatics.", "Add veggies and broth.", "Simmer until tender.", "Season."]
    },
    {
        id: 19,
        title: "Eggplant Parmesan",
        description: "Breaded eggplant slices baked with marinara sauce and cheese.",
        image: "https://images.unsplash.com/photo-1625944230945-1b7dd3b9497e?w=500&auto=format&fit=crop&q=60",
        time: "60 min",
        difficulty: "Medium",
        calories: "520 kcal",
        ingredients: ["Eggplant", "Breadcrumbs", "Marinara Sauce", "Mozzarella", "Parmesan", "Basil"],
        steps: ["Slice and bread eggplant.", "Bake or fry slices.", "Layer with sauce and cheese.", "Bake until bubbly."]
    },
    {
        id: 20,
        title: "Mango Lassi",
        description: "Sweet and creamy Indian mango yogurt drink.",
        image: "https://images.unsplash.com/photo-1543362185-1d6cc4468f78?w=500&auto=format&fit=crop&q=60",
        time: "5 min",
        difficulty: "Easy",
        calories: "250 kcal",
        ingredients: ["Ripe Mango", "Yogurt", "Milk", "Sugar", "Cardamom"],
        steps: ["Blend chopped mango.", "Add yogurt, milk, sugar.", "Blend until smooth.", "Serve chilled."]
    }
];

module.exports = { recipes };
