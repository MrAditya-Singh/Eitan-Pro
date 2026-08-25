class CookModeRecipe {
  final String title;
  final String? description;
  final int? prepTime;
  final int? cookTime;
  final int? servings;
  final String? difficulty;
  final List<CookIngredient> ingredients;
  final List<CookStep> steps;

  CookModeRecipe({
    required this.title,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.difficulty,
    this.ingredients = const [],
    required this.steps,
  });

  factory CookModeRecipe.fromJson(Map<String, dynamic> json) {
    return CookModeRecipe(
      title: json['title'] ?? 'Untitled Recipe',
      description: json['description'],
      prepTime: json['prepTime'] ?? json['prep_time'],
      cookTime: json['cookTime'] ?? json['cook_time'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => CookIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => CookStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CookIngredient {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String category;
  final bool optional;

  CookIngredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    this.optional = false,
  });

  factory CookIngredient.fromJson(Map<String, dynamic> json) {
    return CookIngredient(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      category: json['category'] ?? '',
      optional: json['optional'] ?? false,
    );
  }
}

class CookStep {
  final int stepNumber;
  final String instruction;
  final List<String> ingredientsHighlighted;
  final int? timerDurationSeconds;
  final String? voiceShortcut;

  CookStep({
    required this.stepNumber,
    required this.instruction,
    required this.ingredientsHighlighted,
    this.timerDurationSeconds,
    this.voiceShortcut,
  });

  factory CookStep.fromJson(Map<String, dynamic> json) {
    // Support both the AI generator structure (timer in minutes) and the legacy structure (seconds)
    int? timer = json['timer'] ?? json['suggested_timer'];
    if (timer != null && json.containsKey('timer')) {
      timer = timer * 60; // Convert minutes to seconds if it came from the new AI pipeline
    }

    return CookStep(
      stepNumber: json['stepNumber'] ?? json['step_number'] ?? 0,
      instruction: json['instruction'] ?? '',
      ingredientsHighlighted:
          (json['ingredientsUsed'] as List<dynamic>? ?? json['ingredients_used'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      timerDurationSeconds: timer,
      voiceShortcut: json['voice_shortcuts'],
    );
  }
}
