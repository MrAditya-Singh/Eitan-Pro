# CookApp Implementation Plan

## Goal
Build a modern, cross-platform (Android + iOS) Cooking App with the following features:
- **Ingredient-based Recipe Suggestions**: Find recipes based on available ingredients.
- **Modern UI**: Clean, attractive, premium design (glassmorphism, vibrant colors).
- **Interactive Features**: YouTube integration for cooking videos, grocery list generation.
- **Backend**: Firebase integration (Auth, Database).
- **AI Features**: Optional AI API (Gemini/OpenAI) for recipe generation/suggestions.

## Phase 1: Foundation Setup
1.  **Project Initialization**: Create new Flutter project `Eitan Pro`.
2.  **Dependencies**: Add `firebase_core`, `firebase_auth`, `cloud_firestore`, `provider` (or `riverpod`/`bloc`), `cached_network_image`, `youtube_player_flutter`, etc.
3.  **Design System**: Set up `app_theme.dart` with custom color palette and typography.
4.  **Project Structure**: Configure folders for `screens`, `widgets`, `services`, `models`, `utils`.

## Phase 2: Core Features
1.  **Authentication**: Login/Signup screens with Firebase Auth.
2.  **Home Screen**: Dashboard with recipe categories, search bar, and personalized suggestions.
3.  **Recipe Detail**: View recipe steps, ingredients, and embedded YouTube player.
4.  **Ingredient Input**: Interface to enter available ingredients and get suggestions.

## Phase 3: Advanced Features
1.  **Grocery List**: Feature to add ingredients from recipes to a shopping list.
2.  **Meal Planning**: Simple weekly meal planner.
3.  **AI Integration**: Implement AI service to suggest recipes based on loose descriptions or ingredients.

## Phase 4: Polish & Deploy
1.  **UI Polish**: Animations, transitions (COMPLETED), dark mode support (COMPLETED).
2.  **Testing**: Unit and widget tests.
3.  **Build**: Generate APK/AAB for Android and IPA relevant bundle for iOS.

## Phase 5: Cook Mode & AI (New)
1.  **AI Integration (Gemini 1.5 Pro)**:
    -   **Recipe Parser**: Use Gemini to analyze video descriptions/content/transcripts and generate structured Cook Mode data (Steps, Timers, Ingredients).
    -   **AI Chef Assistant**: Real-time chat overlay in Cook Mode with context of the current recipe. Support image input (multimodal) if possible.
2.  **UI Implementation**: Create immersive, distraction-free `CookModeScreen`.
    -   Large typography, step-by-step navigation.
    -   Ingredient highlighting & smart timer panel.
    -   AI Chat Bubble & Voice Inputs.
3.  **Navigation**: Replace 'Cookbooks' in footer with 'Cook Mode'.
4.  **Integration**: accessible from Search Results and Video Player.
