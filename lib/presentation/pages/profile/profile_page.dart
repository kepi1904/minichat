import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minichat/data/providers/profile_provider.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Dengarkan perubahan status login
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);
        provider.loadUserProfile();
      }
    });

    // Panggil load pertama kali juga
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        body: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColor.black
                        : Colors.blue.shade100,
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : AppColor.white
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: user == null
                  ? const Center(child: Text("Tidak ada pengguna yang login"))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: provider.imageUrl != null
                                ? NetworkImage(provider.imageUrl.toString())
                                : null,
                            child: provider.imageUrl == null
                                ? const Icon(Icons.person, size: 60)
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.firstName ?? 'Nama tidak tersedia',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? 'Email tidak tersedia',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(context, [
                            _infoTile(Icons.location_on, "Alamat",
                                "Jakarta, Indonesia"),
                            _infoTile(Icons.cake, "Umur", "25 tahun"),
                            _infoTile(Icons.sports_soccer, "Hobi",
                                "Sepak Bola, Membaca"),
                          ]),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "User ID: ${user.uid}",
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.grey,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black26
                : AppColor.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }
}
