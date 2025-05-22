import 'package:flutter/material.dart';
import 'package:minichat/data/providers/initialize_provider.dart';
import 'package:minichat/presentation/pages/home/navigation_page.dart';
import 'package:provider/provider.dart';
import 'package:minichat/presentation/pages/auth/login_page.dart';

class InitializePage extends StatelessWidget {
  const InitializePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InitializeProvider>();

    if (provider.error) {
      return const Center(child: Text('Error initializing Firebase'));
    }

    if (!provider.initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = provider.user;

    return Scaffold(body: user == null ? LoginPage() : NavigationPage());
  }
}
