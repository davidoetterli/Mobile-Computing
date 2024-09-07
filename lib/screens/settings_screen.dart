import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    Theme(
                      data: themeProvider.themeMode == ThemeMode.dark
                          ? ThemeData.dark()
                          : ThemeData.light(),
                      child: SwitchListTile(
                        title: const Text("Dark Mode"),
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (bool value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
