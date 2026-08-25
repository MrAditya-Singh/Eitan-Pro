import 'package:flutter/material.dart';
import 'package:cook_app/services/notification_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _dailyInspiration = true;
  bool _newVideoAlerts = true;

  // Mock Data simulating fetching from Eitan's website/socials
  final List<Map<String, String>> _updates = [
    {
      'title': 'New Recipe Drop: Spicy Honey Garlic Chicken',
      'date': '2 hours ago',
      'summary': 'Get ready for a flavor explosion! This 20-minute recipe is perfect for weeknight dinners.',
      'type': 'recipe',
      'url': 'https://www.eitanbernath.com/recipes/'
    },
    {
      'title': 'Live Cooking Session Tomorrow!',
      'date': '5 hours ago',
      'summary': 'Join me on Instagram Live at 5 PM EST. We are making homemade pasta from scratch!',
      'type': 'event',
      'url': 'https://www.instagram.com/eitan'
    },
    {
      'title': 'Merch Restock Alert 🚨',
      'date': '1 day ago',
      'summary': 'The "Chef Eitan" aprons are back in stock. Grab yours before they sell out again.',
      'type': 'shop',
      'url': 'https://www.eitanbernath.com/shop/'
    },
    {
      'title': 'Behind the Scenes: TV Appearance',
      'date': '2 days ago',
      'summary': 'Catch me on The Drew Barrymore Show this Friday! Here is a sneak peek.',
      'type': 'news',
      'url': 'https://www.eitanbernath.com/'
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _checkPermissions() async {
    await _notificationService.requestPermissions();
  }

  void _toggleDaily(bool value) {
    setState(() => _dailyInspiration = value);
    if (value) {
      _notificationService.scheduleDailyReminder(); // 10 AM daily
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily inspiration scheduled! 🍳')),
      );
    } else {
      _notificationService.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFE91E63);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50], // Premium background
      body: CustomScrollView(
        slivers: [
          // Elegant AppBar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'NOTIFICATIONS',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark 
                      ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)] 
                      : [Colors.grey[200]!, Colors.white],
                  ),
                ),
              ),
            ),
          ),

          // Settings Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREFERENCES',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _dailyInspiration,
                          activeColor: primaryColor,
                          title: const Text('Daily Inspiration', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Get a recipe idea every morning'),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.wb_sunny_rounded, color: Colors.orange),
                          ),
                          onChanged: _toggleDaily,
                        ),
                        Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[200]),
                        SwitchListTile(
                          value: _newVideoAlerts,
                          activeColor: primaryColor,
                          title: const Text('New Video Alerts', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Notify when Eitan posts a new video'),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.play_circle_fill_rounded, color: Colors.red),
                          ),
                          onChanged: (val) => setState(() => _newVideoAlerts = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Latest Updates List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        'LATEST UPDATES',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    );
                  }
                  final update = _updates[index - 1];
                  return _buildUpdateCard(update, isDark);
                },
                childCount: _updates.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard(Map<String, String> update, bool isDark) {
    IconData icon;
    Color iconColor;
    
    switch (update['type']) {
      case 'recipe':
        icon = Icons.restaurant_menu;
        iconColor = Colors.orange;
        break;
      case 'event':
        icon = Icons.event;
        iconColor = Colors.purple;
        break;
      case 'shop':
        icon = Icons.shopping_bag;
        iconColor = Colors.pink;
        break;
      default:
        icon = Icons.article;
        iconColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            // Open URL
            final uri = Uri.parse(update['url']!);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Expanded(
                             child: Text(
                               update['title']!,
                               style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 15,
                                 color: isDark ? Colors.white : Colors.black87,
                               ),
                             ),
                           ),
                           Text(
                             update['date']!,
                             style: TextStyle(
                               fontSize: 11,
                               color: isDark ? Colors.white38 : Colors.grey,
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 5),
                       Text(
                         update['summary']!,
                         style: TextStyle(
                           fontSize: 13,
                           color: isDark ? Colors.white60 : Colors.black54,
                           height: 1.4,
                         ),
                       ),
                       const SizedBox(height: 10),
                       Row(
                         children: [
                           Text(
                             'Tap to read more',
                             style: TextStyle(
                               fontSize: 11,
                               color: iconColor,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           const SizedBox(width: 5),
                           Icon(Icons.arrow_forward, size: 12, color: iconColor),
                         ],
                       ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
