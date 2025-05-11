import 'package:flutter/material.dart';
import '../theme.dart';  // for AppTheme enum

class SettingsPage extends StatelessWidget {
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;

  const SettingsPage({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select App Theme',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          DropdownButton<AppTheme>(
            value: currentTheme,
            isExpanded: true,
            items: AppTheme.values.map((mode) {
              final name = mode.toString().split('.').last;
              return DropdownMenuItem(
                value: mode,
                child: Text(name),
              );
            }).toList(),
            onChanged: (mode) {
              if (mode != null) onThemeChanged(mode);
            },
          ),
          // add more settings here later…
        ],
      ),
    );
  }
}
