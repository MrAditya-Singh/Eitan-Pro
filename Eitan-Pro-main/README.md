# 🍳 Eitan Pro App

**Your Ultimate AI-Powered Cooking Companion.**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)

Eitan Pro is a modern, feature-rich cooking application designed to elevate your culinary experience. Built with Flutter and powered by Google's Gemini AI, it seamlessly blends recipe management, smart grocery planning, and interactive cooking guidance into one beautiful interface.

---

## ✨ Features

### 🤖 AI-Powered Kitchen Assistant
-   **Chef Chat:** Have a conversation with an AI Chef to get cooking tips, substitutions, or culinary advice.
-   **Structured Recipe Generation:** Turn a simple list of ingredients into a full-blown recipe with steps and timing.

### 🍳 Smart Cook Mode
-   **Step-by-Step Guidance:** Follow interactive cooking steps with timers and voice shortcuts.
-   **Voice Control:** Navigate through the recipe hands-free while your hands are busy chopping or stirring.

### 🛒 Grocery AI & Fridge Management
-   **Smart Grocery Lists:** Automatically generate organized shopping lists from any recipe.
-   **Fridge Inventory:** Input what you have in your fridge, and let the app suggest recipes to minimize food waste.

### 📹 Seamless Video Integration
-   **In-App YouTube Player:** Watch cooking tutorials and follow along without leaving the app.
-   **Video-to-Recipe:** (Experimental) Extract cooking steps directly from video descriptions.

### 📱 User & Social
-   **Profile Management:** Save your favorite recipes and track your cooking journey.
-   **Dark/Light Mode:** Beautifully designed themes to suit your preference.

---

## 🛠️ Tech Stack

-   **Frontend:** [Flutter](https://flutter.dev/) (Dart)
-   **State Management:** [Provider](https://pub.dev/packages/provider)
-   **Backend:** Node.js with Express
-   **AI Engine:** Google Gemini API
-   **Database & Auth:** Firebase Firestore & Authentication
-   **Video:** YouTube Player Flutter

---

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
-   [Node.js](https://nodejs.org/) (for the backend server).
-   A [Firebase](https://console.firebase.google.com/) project (for Auth & Database).
-   A [Google Cloud](https://console.cloud.google.com/) project with **Gemini API** enabled.

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/cook-app.git
cd cook-app
```

### 2. Backend Setup
The app relies on a local Node.js server to handle AI requests.

1.  Navigate to the backend directory:
    ```bash
    cd backend
    ```
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  Create a `.env` file in the `backend/` directory with your API keys:
    ```env
    GEMINI_API_KEY=your_gemini_api_key_here
    FIREBASE_SERVICE_ACCOUNT_KEY=path/to/your/serviceAccountKey.json
    PORT=3000
    ```
4.  Start the server:
    ```bash
    node server.js
    ```

### 3. Frontend Setup

1.  Navigate back to the root directory:
    ```bash
    cd ..
    ```
2.  Install Flutter dependencies:
    ```bash
    flutter pub get
    ```
3.  **Firebase Configuration:**
    -   Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective `android/app/` and `ios/Runner/` directories.
    -   Ensure your Firebase Service Account key is correctly linked for the backend.

4.  **Run the App:**
    ```bash
    flutter run
    ```

> **Note:** If running on an Android Emulator, the app is pre-configured to talk to `http://10.0.2.2:3000`. If running on a physical device, ensure your phone and computer are on the same Wi-Fi networks and update the backend URL in the app settings or `ai_service.dart`.

---

## 📸 Screenshots

*(Add your screenshots here)*

| Home Screen | Recipe Detail | Cook Mode |
|:-----------:|:-------------:|:---------:|
| ![Home](https://github.com/user-attachments/assets/8004a6df-2629-48bc-a2dd-d7b474028882) | ![Recipe](https://github.com/user-attachments/assets/1d2a6e8c-e16a-460f-9ac9-2c34485d8b63) | ![Cook Mode](https://github.com/user-attachments/assets/f25dc278-ba79-482e-8fe5-7697cbb76957) |

---

## 🚀 What's Next for Eitan Pro

Eitan Pro is evolving into a fully intelligent, AI-powered cooking assistant that acts like your personal chef.

---

# 🧠 AI Meal Planner

Users select:

- 🎯 Goal  
  - Weight loss  
  - Muscle gain  
  - Family dinner  

- 💰 Budget  
- ⏱ Time available  

AI generates:

- 📅 3-day or 7-day meal plan  
- 🛒 Automatic grocery list  
- 🔥 Calorie breakdown  
- 🧾 Nutrition insights  

---

# 🎤 Voice-Controlled Cook Mode 2.0

Upgrade Cook Mode with full voice interaction:

- “Next step”
- “Repeat”
- “How long left?”
- “Is this done?”

Hands-free cooking experience.

---

# 💎 Subscription Model — Cook Pro

## 🆓 FREE VERSION

Includes:

- 3 AI recipes per day
- Basic Cook Mode
- Manual grocery list
- No personalization memory
- No advanced voice features

---

## 💰 COOK PRO ($7–12/month)

Includes:

- Unlimited AI recipe generation
- AI Meal Planner (7-day planning)
- Personalized recipe suggestions
- Voice-Controlled Cook Mode 2.0
- Nutrition tracking
- Pantry memory
- Grocery integration
- AI substitution engine
- Fridge photo scan (future feature)

---

# 👤 Personalization System

Make the app feel like a private chef.

Personalization affects:

- Recipes generated
- Meal planning
- Grocery suggestions

---

## A. Taste & Diet Profile

Collected during onboarding:

- Diet type  
  - Vegetarian  
  - Vegan  
  - Keto  
  - High Protein  
  - Balanced  

- Allergies
- Spice level (1–5)
- Cooking skill  
  - Beginner  
  - Intermediate  
  - Advanced  

- Time preference  
  - Quick meals  
  - Weekend cooking  

---

## B. Cooking Behavior Learning

The app learns automatically:

- Recipes viewed
- Recipes cooked
- Time spent in Cook Mode
- Ingredients frequently used
- Preferred cuisines

---

## C. Smart Pantry Memory

Users can:

- Add ingredients manually
- Scan grocery receipts
- Sync with grocery integrations

App automatically:

- Suggests recipes using expiring ingredients
- Sends alerts like:  
  > "Your spinach expires tomorrow"

---

## D. AI Adaptive Recipe Generation

Gemini AI uses personalized profile:

Example:

Diet: High Protein
Avoid: Mushrooms
Spice level: Medium
Budget: Low


Generates fully customized recipes.

---

# 🛒 Grocery Integration System

Turn meal planning into execution.

Includes:

## Smart Grocery List Engine

- Auto-generated grocery lists from meal plans

## Price Estimation

- Estimate total grocery cost
- Budget optimization

## Direct Checkout Integration (Future)

- Order groceries directly from the app

---

# 🎯 Long-Term Vision

Eitan Pro becomes:

- AI personal chef
- Meal planner
- Grocery manager
- Nutrition coach
- Voice-guided cooking assistant

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 🙏 Acknowledgments

-   Aditya Singh - mradityasinghofficial1@gmail.com
-   Anshika Thakur - anshikath305@gmail.com
-   Sumit Kumar Ratna - sumit27.ratna@gmail.com
-   Detailed cooking videos from [Eitan Bernath](https://www.youtube.com/c/EitanBernath) (Inspiration).
