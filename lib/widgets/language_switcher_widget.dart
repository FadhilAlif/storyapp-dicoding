import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) {
        context.setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('🇬🇧 English'),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('id'),
          child: Text('🇮🇩 Indonesia'),
        ),
      ],
      icon: const Icon(Icons.language),
    );
  }
}
