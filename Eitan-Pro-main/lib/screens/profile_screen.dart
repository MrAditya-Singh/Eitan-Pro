import 'package:cook_app/services/auth_service.dart';
import 'package:cook_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cook_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _handleJoin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Register with Firebase Auth
        User? user = await _auth.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim()
        );

        if (user != null) {
          // Save extra details to Firestore
          await DatabaseService().addMember(
            _nameController.text.trim(),
            _emailController.text.trim(),
            uid: user.uid
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Welcome to Eitan\'s Elite Community!'),
                backgroundColor: Color(0xFF3A9E9E),
              ),
            );
            Navigator.pop(context);
          }
        } else {
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration failed. Email might be in use.'), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSignOut() async {
    await _auth.signOut();
    setState(() {
      _user = null;
    });
    // Optional: Pop or show snackbar
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed Out Successfully'), backgroundColor: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return _buildLoggedInView();
    } else {
      return _buildGuestRegistrationView();
    }
  }

  Widget _buildLoggedInView() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildExoticHeader(
              title: 'WELCOME BACK, CHEF',
              subtitle: user?.email ?? 'Elite Member',
              icon: Icons.verified_user_rounded,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Status Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark 
                          ? [const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)]
                          : [Colors.white, const Color(0xFFF5F5F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.workspace_premium, color: Colors.amber, size: 30),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PLATINUM STATUS',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 1.2,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Member since ${DateTime.now().year}',
                              style: TextStyle(
                                color: isDark ? Colors.white60 : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Stats Grid
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('saved_recipes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      final savedCount = snapshot.data?.docs.length ?? 0;
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              savedCount.toString(),
                              'SAVED RECIPES',
                              Icons.bookmark,
                              const Color(0xFF3A9E9E),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildStatCard(
                              '∞',
                              'AI GENERATIONS',
                              Icons.auto_awesome,
                              const Color(0xFFCE93D8),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Action Menu
                  _buildActionTile(icon: Icons.settings, title: 'App Settings', onTap: () {}), // Could link to SettingsScreen
                  _buildActionTile(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
                  _buildActionTile(
                    icon: Icons.logout, 
                    title: 'Sign Out', 
                    onTap: _handleSignOut,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : Colors.grey,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, required VoidCallback onTap, bool isDestructive = false}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black);
    
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white24 : Colors.black26),
    );
  }

  Widget _buildGuestRegistrationView() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'ELITE JOIN',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildExoticHeader(
              title: 'ELITE CULINARY MEMBERSHIP',
              subtitle: 'Experience Eitan\'s Private World',
              icon: Icons.stars_rounded,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR IDENTITY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFCE93D8),
                        letterSpacing: 2.5
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildEliteTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildEliteTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildEliteTextField(
                      controller: _passwordController,
                      label: 'Create Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Password must be 6+ chars' : null,
                    ),
                    const SizedBox(height: 35),
                    const Text(
                      'PREMIUM PRIVILEGES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3A9E9E),
                        letterSpacing: 2.5
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildPremiumFeatureCard(
                            'ELITE COOKBOOK',
                            'Exclusive digital access to the secret vault.',
                            Icons.menu_book_rounded,
                            const Color(0xFFFF8A80),
                          ),
                          _buildPremiumFeatureCard(
                            'UNLIMITED SAVES',
                            'Infinite recipe collection storage.',
                            Icons.all_inclusive_rounded,
                            const Color(0xFF81D4FA),
                          ),
                          _buildPremiumFeatureCard(
                            'MEAL ARCHITECT',
                            'Weekly personalized culinary planning.',
                            Icons.calendar_view_week_rounded,
                            const Color(0xFFA5D6A7),
                          ),
                          _buildPremiumFeatureCard(
                            'NUTRI-SCAN',
                            'Precision calorie & macro analytics.',
                            Icons.analytics_rounded,
                            const Color(0xFFCE93D8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleJoin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF3A9E9E) : Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'JOIN COMMUNITY',
                              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                           Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                           );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 13),
                            children: [
                              const TextSpan(text: "Already a member? "),
                              TextSpan(
                                text: "Login Here",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black, 
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExoticHeader({required String title, required String subtitle, required IconData icon}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800'),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              isDark ? Colors.black.withValues(alpha: 0.9) : Colors.black.withValues(alpha: 0.8), 
              Colors.transparent
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDark) const SizedBox(height: 20), // Top padding for status bar if needed
            Icon(icon, color: const Color(0xFFFFD700), size: 50),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 3,
                fontSize: 14
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white60, 
                fontSize: 13,
                fontStyle: FontStyle.italic
              ),
            ),
            if (Navigator.canPop(context))
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeatureCard(String title, String desc, IconData icon, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2
            ),
          ),
          const SizedBox(height: 5),
          Text(
            desc,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.grey[700],
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.3
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: isDark ? const Color(0xFF72CFCF) : Colors.black),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8F9FA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: isDark ? const Color(0xFF72CFCF) : Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
