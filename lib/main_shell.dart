import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instproject/features/chatgroup/pages/group_chat_page.dart';
import 'package:instproject/features/auth/presentation/pages/profile_page.dart';
import 'package:instproject/features/posts/presentation/pages/create_post_page.dart';
import 'package:instproject/features/posts/presentation/pages/feed_page.dart';
import 'package:instproject/features/institutes/presentation/pages/institutes_page.dart';
import 'package:instproject/features/posts/presentation/pages/search_posts.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final pages = [
      FeedPage(userId: user?.uid ?? 'defaultId'),
      const GroupsPage(),
      CreatePostPage(userId: user?.uid ?? ''),
      SearchPostsPage(),
      ProfilePage(uid: user?.uid ?? ''),
      const InstitutesPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4E342E), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: IndexedStack(index: _currentIndex, children: pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple,
        selectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.unselectedItemColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_outlined),
            activeIcon: Icon(Icons.post_add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Institutes',
          ),
        ],
      ),
    );
  }
}
