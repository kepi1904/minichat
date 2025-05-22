import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:minichat/data/providers/chat_provider.dart';
import 'package:minichat/data/providers/home_provider.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isAttachmentUploading = false;
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref().child(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance
              .updateMessage(updatedMessage, widget.room.id);

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance
              .updateMessage(updatedMessage, widget.room.id);
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);
    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(message, widget.room.id);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themes = Provider.of<HomeProvider>(context);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_getReceiverId(widget.room))
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading...");
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            final isOnline = data?['isOnline'] ?? false;
            final lastSeenTimestamp = data?['lastSeen'];
            final lastSeen = lastSeenTimestamp != null
                ? (lastSeenTimestamp as Timestamp).toDate()
                : null;

            return Row(
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: isOnline ? AppColor.green : AppColor.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.room.name ?? "Chat",
                          style: const TextStyle(fontSize: 18)),
                      if (!isOnline && lastSeen != null)
                        Text(
                          "Last seen ${timeago.format(lastSeen)}",
                          style: TextStyle(fontSize: 12, color: AppColor.grey),
                        ),
                      if (isOnline)
                        const Text(
                          "Online",
                          style: TextStyle(fontSize: 12, color: AppColor.green),
                        )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Consumer<ChatProvider>(builder: (context, provider, child) {
        return StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) => Chat(
              isAttachmentUploading: isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
              theme: DefaultChatTheme(
                backgroundColor: themes.themeMode == ThemeMode.dark
                    ? const Color(0xFF121212) // Warna latar belakang dark mode
                    : const Color(
                        0xFFFFFFFF), // Warna latar belakang light mode

                // Bubble dari pengirim (kamu)
                primaryColor: themes.themeMode == ThemeMode.dark
                    ? const Color(0xFF9C27B0) // Ungu terang di dark mode
                    : const Color(0xFF6A1B9A), // Ungu lebih gelap di light mode

                // Bubble dari penerima
                secondaryColor: themes.themeMode == ThemeMode.dark
                    ? const Color(0xFF1976D2) // Biru terang di dark mode
                    : const Color(0xFF0D47A1), // Biru gelap di light mode

                // Style teks (optional untuk lebih jelas)
                sentMessageBodyTextStyle: const TextStyle(
                  color: AppColor.white,
                  fontSize: 15,
                ),
                receivedMessageBodyTextStyle: const TextStyle(
                  color: AppColor.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      }),
    ));
  }

  String _getReceiverId(types.Room room) {
    final currentUserId = FirebaseChatCore.instance.firebaseUser?.uid;
    return room.users.firstWhere((u) => u.id != currentUserId).id;
  }
}
