import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:url_launcher/url_launcher.dart';

class SavedRecipesScreen extends StatelessWidget {
  final VoidCallback? onGoToGrocery;
  
  const SavedRecipesScreen({super.key, this.onGoToGrocery});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F0F12) : Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_outline_rounded, size: 80, color: isDark ? Colors.white24 : Colors.grey[300]),
              const SizedBox(height: 20),
              const Text(
                'SIGN IN TO SAVE RECIPES',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text('Keep your favorites linked to your Google account.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F12) : Colors.white,
      appBar: AppBar(
        title: const Text('SAVED COLLECTION', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket_rounded, color: Color(0xFF3A9E9E)),
            onPressed: onGoToGrocery,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('saved_recipes')
            .orderBy('savedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF3A9E9E)));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 60, color: Color(0xFF3A9E9E)),
                  const SizedBox(height: 20),
                  const Text('YOUR COLLECTION IS EMPTY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onGoToGrocery,
                    child: const Text('USE GROCERY AI TO FIND INGREDIENTS', style: TextStyle(color: Color(0xFF3A9E9E), fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return _buildSavedCard(context, data, docs[index].id, isDark);
            },
          );
        },
      ),
    );
  }

  Widget _buildSavedCard(BuildContext context, Map<String, dynamic> data, String docId, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: InkWell(
        onTap: () async {
          if (data['isExternal'] == true) {
             final Uri url = Uri.parse(data['externalUrl']);
             if (await canLaunchUrl(url)) {
               await launchUrl(url, mode: LaunchMode.externalApplication);
             }
          } else {
             // Load internal recipe
          }
        },
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  child: Image.network(
                    data['coverImage'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('saved_recipes')
                          .doc(docId)
                          .delete();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.bookmark_remove_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data['isExternal'] == true ? 'EITAN.COM' : 'INTERNAL RECIPE',
                          style: const TextStyle(color: Color(0xFF3A9E9E), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
