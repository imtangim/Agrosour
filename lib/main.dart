import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:nasa_space_app/authentication/auth_handler.dart';
import 'package:nasa_space_app/authentication/authentication_screen.dart';
import 'package:nasa_space_app/authentication/user_form_screen.dart';
import 'package:nasa_space_app/core/injection/binder.dart';
import 'package:nasa_space_app/core/theme/keys.dart';
import 'package:nasa_space_app/homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ScreenUtil.ensureScreenSize();

  Gemini.init(
    apiKey: KeysForApi.geminiKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GetMaterialApp(
        initialBinding: GetxBinder(),
        title: 'Agrisour',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          useMaterial3: true,
          fontFamily: "Nunito",
          indicatorColor: Colors.black87,
          splashFactory: NoSplash.splashFactory,
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.orangeAccent.shade400,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const AuthHandler()),
          GetPage(name: '/home', page: () => const Homepage()),
          GetPage(name: '/user-form', page: () => const UserFormScreen()),
          GetPage(
              name: '/authentication',
              page: () => const AuthenticationScreen()),
        ],
      ),
    );
  }
}
