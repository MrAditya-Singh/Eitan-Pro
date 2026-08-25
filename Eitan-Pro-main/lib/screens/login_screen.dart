import 'package:flutter/material.dart';
import 'package:cook_app/services/auth_service.dart';
import 'package:cook_app/screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      dynamic result = await _auth.signInWithEmailAndPassword(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not sign in with those credentials'), backgroundColor: Colors.red),
          );
        } else {
          Navigator.pop(context); // Return to previous screen (likely Home, which will update due to stream)
        }
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const ProfileScreen()) // ProfileScreen is basically our "Join" screen in Guest mode
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'ELITE LOGIN',
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
            _buildExoticHeader(),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFCE93D8),
                        letterSpacing: 2.5
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildEliteTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildEliteTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Password must be 6+ chars' : null,
                    ),
                    const SizedBox(height: 40),
                     SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF3A9E9E) : Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'ACCESS ACCOUNT',
                              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: _navigateToRegister,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 13),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Join Elite",
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

  Widget _buildExoticHeader() {
    return Container(
      width: double.infinity,
      height: 220,
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
            colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.vpn_key_rounded, color: Color(0xFFFFD700), size: 60),
            SizedBox(height: 15),
            Text(
              'SECURE MEMBER ACCESS',
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 3,
                fontSize: 14
              ),
            ),
          ],
        ),
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
