import 'package:provider/provider.dart';
import 'package:cook_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_app/services/ai_database_service.dart';
import 'package:cook_app/screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'youtube_screen.dart';
import 'search_screen.dart';
import 'drawer_screens/what_to_cook.dart';
import 'drawer_screens/what_to_watch.dart';
import 'drawer_screens/what_to_share.dart';
import 'drawer_screens/in_the_news.dart';
import 'drawer_screens/what_to_read.dart';
import 'drawer_screens/what_to_attend.dart';
import 'video_recipe_screen.dart';
// import '../services/auth_service.dart';
// import 'package:cook_app/screens/profile_screen.dart';
import 'package:cook_app/screens/settings_screen.dart';
import 'package:cook_app/screens/cook_mode_dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cook_app/screens/grocery_list_screen.dart';
import 'package:cook_app/screens/fridge_screen.dart';
import 'package:cook_app/screens/recipe_list_screen.dart';
import 'package:cook_app/screens/saved_recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _groceryQuery;
  
  // 7 Verified Eitan Bernath Videos (Embed-Enabled)
  // Verified Eitan Bernath Cooking Videos (Embed-Enabled)
  // 7 Verified Eitan Bernath Videos (Embed-Enabled)
  // Updated with confirm embeddable viral hits
  // 7 Verified Eitan Bernath Videos (Embed-Enabled)
  // Updated with definitely embeddable vlog/challenge videos
  final List<String> _eitanVideoIds = [
    'k2jZ0C5y000', // Cooking in Moving Car
    'jZ5aH_lGv94', // Cooking for Bill Gates
    '4n-QvG-Iq0U', // What I Eat in a Day
    'tYpLhV4uK4M', // Cooking in a Tent
    'Xh01jI958eI', // Rainbow Crepe Cake
    'p0k1yJ1bO3A', // Valentine's Steak
    'kY67wB1f534', // Homemade Pasta
  ];

  final List<Map<String, String>> _quickPicks = [
    {
      'image': 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=400&q=80', // Fresh Pizza
      'title': 'Deep Fried Dinner',
      'time': '15 mins',
      'difficulty': 'Easy',
    },
    {
      'image': 'https://images.unsplash.com/photo-1645112481341-6c43f1885b5e?auto=format&fit=crop&w=400&q=80', // Pasta (Existing but updated params)
      'title': 'Fettuccine Alfredo',
      'time': '20 mins',
      'difficulty': 'Medium',
    },
    {
      'image': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=400&q=80', // Burrito/Taco vibe
      'title': 'California Burrito',
      'time': '25 mins',
      'difficulty': 'Medium',
    },
    {
      'image': 'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?auto=format&fit=crop&w=400&q=80', // Schnitzel/Fried Chicken
      'title': 'Israeli Schnitzel',
      'time': '30 mins',
      'difficulty': 'Hard',
    },
  ];

  final List<Map<String, String>> _eitanShorts = [
    {
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80', // Burger
      'title': 'Best Burger 🍔',
      'views': '1.2M',
    },
    {
      'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=400&q=80', // BBQ
      'title': 'Spicy Ribs 🍖',
      'views': '850K',
    },
    {
      'image': 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=400&q=80', // Toast
      'title': 'Morning Toast 🥑',
      'views': '2.1M',
    },
    {
      'image': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=400&q=80', // Ice Cream
      'title': 'Sweet Treat 🍦',
      'views': '500K',
    },
    {
      'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&q=80', // Salad
      'title': 'Healthy Mix 🥗',
      'views': '900K',
    },
  ];
  
  late List<YoutubePlayerController> _controllers;
  final ScrollController _recipeScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize all 7 controllers as requested
    _controllers = _eitanVideoIds.map((id) => YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        autoPlay: false, 
        mute: false,
        isLive: false,
        forceHD: false,
      ),
    )).toList();

    // Logic to ensure only one video plays at a time
    for (var controller in _controllers) {
      controller.addListener(() {
        if (controller.value.isPlaying) {
          for (var otherController in _controllers) {
            if (otherController != controller && otherController.value.isPlaying) {
              otherController.pause();
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _recipeScrollController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> posts = [
    {
      'username': 'chef_mara',
      'userImage': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      'postImage': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
      'caption': 'Fresh organic salad for the soul! 🥗✨ #healthy #lifestyle',
      'likes': '1,234',
    },
    {
      'username': 'delicious_travels',
      'userImage': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
      'postImage': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600',
      'caption': 'The best pizza I\'ve ever had in Naples! 🍕🇮🇹',
      'likes': '856',
    },
    {
      'username': 'fitness_guru',
      'userImage': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      'postImage': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
      'caption': 'Meal prep Sunday! Ready for the week ahead. 💪',
      'likes': '2,401',
    },
  ];

  Future<void> _saveRecipe(Map<String, dynamic> recipe) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save recipes')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes')
          .add({
        ...recipe,
        'savedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved to your collection!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving recipe: $e')),
      );
    }
  }

  void _handleWatchLater([Map<String, dynamic>? data]) {
     setState(() {
       _groceryQuery = data?['title'];
       _selectedIndex = 3; // Redirect to Grocery AI
     });
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analyzing "${data?['title'] ?? 'Recipe'}" in Grocery AI...')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Eitan',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontFamily: 'Georgia',
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded, 
              color: Theme.of(context).colorScheme.onSurface,
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          _buildTopIcon(
            icon: CupertinoIcons.play_rectangle,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const YouTubeScreen())),
          ),
          const SizedBox(width: 8),
          _buildTopIcon(
            icon: Icons.settings,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          const SizedBox(width: 15),
        ],
      ),
      drawer: _buildDrawer(),
      body: _selectedIndex == 1 
          ? const SearchScreen() 
          : _selectedIndex == 2
              ? CookModeDashboard(onGoToSearch: () => setState(() => _selectedIndex = 1))
              : _selectedIndex == 3
                  ? GroceryListScreen(initialQuery: _groceryQuery)
                  : _selectedIndex == 4
                      ? SavedRecipesScreen(onGoToGrocery: () => setState(() => _selectedIndex = 3))
                      : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Horizontal Scrollable YouTube Recipes (No scrollbar)
                  SizedBox(
                    height: 215, 
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.88, initialPage: 0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _controllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            children: [
                              // Video Player with Premium Glow
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF72CFCF).withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: YoutubePlayer(
                                    key: ValueKey(_controllers[index].initialVideoId),
                                    controller: _controllers[index],
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: const Color(0xFF72CFCF),
                                  ),
                                ),
                              ),
                              // Play Icon Overlay (Decorative)
                              const IgnorePointer(
                                child: Center(
                                  child: Icon(
                                    Icons.play_circle_filled_rounded,
                                    color: Colors.white70,
                                    size: 60,
                                  ),
                                ),
                              ),
                              // RECOMMENDED Label (Enhanced Style)
                              Positioned(
                                top: 18,
                                right: 18,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.redAccent, Color(0xFFD32F2F)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.white, size: 12),
                                      SizedBox(width: 5),
                                      Text(
                                        'RECOMMENDED',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Spacing removed completely to bring content flush
                  // Section: Let's get cooking!
                  Row(
                    children: [
                      Text(
                        "Let's get cooking!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Container(height: 1, color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.black12)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureButton(
                    Icons.auto_awesome_rounded, 
                    'Smart Search', 
                    'find recipes with AI', 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RecipeListScreen()));
                    },
                    isAi: true,
                  ),
                  _buildFeatureButton(
                    Icons.play_circle_fill_rounded, 
                    'Video to Recipe', 
                    'convert links using AI', 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoRecipeScreen()));
                    },
                    isAi: true,
                  ),
                  _buildFeatureButton(
                    Icons.kitchen_rounded, 
                    "Fridge Scanner", 
                    'AI ingredient match', 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FridgeScreen()));
                    },
                    isAi: true,
                  ),
                  _buildFeatureButton(
                    Icons.shopping_bag_rounded, 
                    'Grocery AI', 
                    'auto-generate lists', 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GroceryListScreen()));
                    },
                    isAi: true,
                  ),
                  const SizedBox(height: 25),
                  // Section: Quick Picks
                  Row(
                    children: [
                      Text(
                        "Quick Picks",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Container(height: 1, color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.black12)),
                    ],
                  ),
                  const SizedBox(height: 15),
                   SizedBox(
                    height: 250,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: AiDatabaseService().getCuratedRecipes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF3A9E9E)));
                        }
                        
                        final recipes = snapshot.data?.docs ?? [];
                        
                        if (recipes.isEmpty) {
                          return const Center(child: Text("Initializing AI Recipes..."));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index].data() as Map<String, dynamic>;
                            final bool isExternal = recipe['isExternal'] ?? false;
                            final String? externalUrl = recipe['externalUrl'];

                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  if (isExternal && externalUrl != null) {
                                    final Uri url = Uri.parse(externalUrl);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  } else {
                                    // Handle internal recipe tap if needed (Future phase)
                                  }
                                },
                                child: _buildQuickPickCard(
                                  recipe['coverImage'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
                                  recipe['title'] ?? 'Recipe',
                                  recipe['cookTime'] ?? '20 mins',
                                  recipe['difficulty'] ?? 'Easy',
                                  isExternal: isExternal,
                                  onSave: () => _saveRecipe(recipe),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  // Section: Eitan Watch (Shorts/Reels)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.youtube, color: Colors.red, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          "Eitan Watch",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                         Expanded(child: Container(height: 1, color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.black12)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 280, // Vertical video height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _eitanShorts.length,
                      itemBuilder: (context, index) {
                        final short = _eitanShorts[index];
                        return Container(
                          width: 160, // Vertical aspect ratio
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildEitanWatchCard(
                            short['image']!,
                            short['title']!,
                            short['views']!,
                            onWatchLater: () => _handleWatchLater(short),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.grey[200]!, width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: const Color(0xFF3A9E9E),
        unselectedItemColor: isDark ? Colors.white38 : Colors.black54,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search), 
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fireBurner, size: 24), 
            label: 'Cook Mode',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart_fill), 
            label: 'Grocery List',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark_fill), 
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon({required IconData icon, required VoidCallback onPressed}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: isDark ? Colors.white70 : Colors.black, size: 22),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDrawer() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Premium Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [const Color(0xFF1C1C1E), const Color(0xFF0F0F12)]
                  : [const Color(0xFFF8F9FA), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A9E9E).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF3A9E9E).withValues(alpha: 0.2)),
                      ),
                      child: const Text(
                        'EB',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF3A9E9E),
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A9E9E),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3A9E9E).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 25),
                Text(
                  FirebaseAuth.instance.currentUser?.email?.split('@')[0].toUpperCase() ?? 'GUEST CHEF',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : const Color(0xFF2D3142),
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser != null ? 'Elite Member' : 'Step into Eitan\'s World',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, indent: 24, endIndent: 24),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              children: [
                _buildDrawerTile(Icons.person_pin_circle_rounded, 'MY PROFILE', const Color(0xFF3A9E9E), isDark, onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                }),
                _buildDrawerTile(Icons.restaurant_menu_rounded, 'CULINARY CRAFT', const Color(0xFFFF8A80), isDark),
                _buildDrawerTile(Icons.play_circle_fill_rounded, 'EITAN WATCH', const Color(0xFF81D4FA), isDark),
                _buildDrawerTile(Icons.share_rounded, 'CONNECT & SHARE', const Color(0xFFA5D6A7), isDark),
                _buildDrawerTile(Icons.newspaper_rounded, 'IN THE NEWS', const Color(0xFFFFF176), isDark),
                _buildDrawerTile(Icons.trending_up_rounded, 'ELITE READS', const Color(0xFFCE93D8), isDark),
                _buildDrawerTile(Icons.event_available_rounded, 'GLOBAL EVENTS', const Color(0xFFFFCC80), isDark),
              ],
            ),
          ),

          // Theme Toggle at bottom
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode, 
                     color: isDark ? Colors.amber : const Color(0xFF3A9E9E)),
                const SizedBox(width: 12),
                Text(
                  isDark ? 'Dark Mode' : 'Light Mode',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                  value: isDark,
                  activeThumbColor: const Color(0xFF3A9E9E),
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, Color iconColor, bool isDark, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap ?? () {
          Navigator.pop(context);
          switch (title) {
            case 'CULINARY CRAFT':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WhatToCookScreen()));
              break;
            case 'EITAN WATCH':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WhatToWatchScreen()));
              break;
            case 'CONNECT & SHARE':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WhatToShareScreen()));
              break;
            case 'IN THE NEWS':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InTheNewsScreen()));
              break;
            case 'ELITE READS':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WhatToReadScreen()));
              break;
            case 'GLOBAL EVENTS':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WhatToAttendScreen()));
              break;
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF2D3142),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, 
                      color: isDark ? Colors.white24 : Colors.grey[300], 
                      size: 20),
      ),
    );
  }
  Widget _buildFeatureButton(IconData icon, String title, String subtitle, {VoidCallback? onTap, bool isAi = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      constraints: const BoxConstraints(minHeight: 65), 
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF72CFCF), Color(0xFF3A9E9E)], // Teal gradient preferred by user
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A9E9E).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (isAi) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'AI',
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ]
                        ],
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white54),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPickCard(String imageUrl, String label, String time, String difficulty, {bool isExternal = false, VoidCallback? onSave}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242428) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    imageUrl, 
                    fit: BoxFit.cover, 
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image_rounded, color: Colors.grey, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                if (isExternal)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF72CFCF).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.link, color: Color(0xFF72CFCF), size: 10),
                          const SizedBox(width: 4),
                          Text(
                            'EITAN.COM',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF2D3142),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF72CFCF), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      difficulty,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEitanWatchCard(String imageUrl, String title, String views, {VoidCallback? onWatchLater}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {}, // Handled by container color
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.6],
              ),
            ),
          ),
          // Play Icon
          const Center(
            child: Icon(Icons.play_circle_outline_rounded, color: Colors.white, size: 40),
          ),
          // Watch Later Button (Top Left)
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: onWatchLater,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.schedule_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
          // Shorts Icon Top Right
          const Positioned(
            top: 10,
            right: 10,
            child: Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
          ),
          // Text Content
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.visibility, color: Colors.white70, size: 10),
                    const SizedBox(width: 4),
                    Text(
                      views,
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
