import 'package:flutter/material.dart';
import 'package:minichat/data/providers/home_provider.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Scaffold(
      body: provider.pages[provider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.selectedIndex,
        onTap: provider.onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: AppColor.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
