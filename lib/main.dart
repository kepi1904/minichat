import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minichat/data/locals/shared_preferences.dart';
import 'package:minichat/data/providers/chat_provider.dart';
import 'package:minichat/data/providers/home_provider.dart';
import 'package:minichat/data/providers/initialize_provider.dart';
import 'package:minichat/data/providers/login_provider.dart';
import 'package:minichat/data/providers/profile_provider.dart';
import 'package:minichat/data/providers/register_provider.dart';
import 'package:minichat/presentation/pages/auth/initialize_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceHandler.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InitializeProvider>(
            create: (_) => InitializeProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<RegisterProvider>(
            create: (_) => RegisterProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themes = Provider.of<HomeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themes.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: InitializePage(),
          );
        },
      ),
    );
  }
}
