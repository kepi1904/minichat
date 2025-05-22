import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:minichat/presentation/pages/chat/chat_page.dart';
import 'package:minichat/data/providers/home_provider.dart';
import 'package:minichat/presentation/pages/contacts/contact_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ambil last message dari Firestore jika tidak ada di room
  Future<Map<String, dynamic>?> getLastMessage(String roomId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
    } catch (e) {
      debugPrint("Error fetching last message: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text('Chats'),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'contact') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const ContactPage(),
                      ),
                    );
                  } else if (value == 'logout') {
                    provider.logout(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'contact',
                    child: Text('Contact'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dark Mode'),
                        Consumer<HomeProvider>(
                          builder: (context, themeProvider, child) {
                            return Switch(
                              value: themeProvider.isDarkMode,
                              onChanged: (value) async {
                                themeProvider.toggleTheme(value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const ContactPage(),
              ),
            );
          },
          backgroundColor: AppColor.kBlueLight,
          child: const Icon(Icons.chat, color: AppColor.white),
        ),
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users'));
                }

                final rooms = snapshot.data!;

                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];

                    // FutureBuilder untuk ambil pesan terakhir
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: room.lastMessages?.isNotEmpty == true
                          ? Future.value(room.lastMessages!.first.toJson())
                          : getLastMessage(room.id),
                      builder: (context, snapshotMessage) {
                        String lastMessageText = '';
                        String lastMessageTime = '';

                        if (snapshotMessage.hasData) {
                          final data = snapshotMessage.data!;
                          final createdAt = data['createdAt'];

                          // Jenis pesan
                          switch (data['type']) {
                            case 'text':
                              lastMessageText = data['text'] ?? '';
                              break;
                            case 'image':
                              lastMessageText = '[Gambar]';
                              break;
                            case 'file':
                              lastMessageText = '[File]';
                              break;
                            default:
                              lastMessageText = '[Pesan]';
                          }

                          DateTime? time;

                          if (createdAt is int) {
                            time =
                                DateTime.fromMillisecondsSinceEpoch(createdAt);
                          } else if (createdAt is Timestamp) {
                            time = createdAt.toDate();
                          }

                          if (time != null) {
                            lastMessageTime =
                                DateFormat('dd MMM, HH:mm').format(time);
                          }
                        }

                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(room: room),
                                  ),
                                );
                              },
                              leading: provider.buildAvatar(room),
                              title: Text(room.name ?? 'No Name'),
                              subtitle: Text(
                                lastMessageText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColor.grey),
                              ),
                              trailing: Text(
                                lastMessageTime.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColor.grey,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20, left: 70),
                              child: Divider(thickness: 0.5),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
