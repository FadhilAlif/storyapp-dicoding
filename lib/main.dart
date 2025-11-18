import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/api/api_service.dart';
import 'package:storyapp_dicoding/data/preferences/auth_preferences.dart';
import 'package:storyapp_dicoding/providers/auth_provider.dart';
import 'package:storyapp_dicoding/providers/story_provider.dart';
import 'package:storyapp_dicoding/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            apiService: ApiService(),
            authPreferences: AuthPreferences(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(
            apiService: ApiService(),
            authPreferences: AuthPreferences(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);
          return MaterialApp.router(
            title: 'Story App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routerConfig: router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
