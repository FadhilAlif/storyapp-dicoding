import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:storyapp_dicoding/config/app_config.dart';
import 'package:storyapp_dicoding/main.dart' as app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  AppConfig(
    flavor: Flavor.prod,
    appName: 'Story App',
    baseUrl: 'https://story-api.dicoding.dev/v1',
  );

  app.runMyApp();
}
