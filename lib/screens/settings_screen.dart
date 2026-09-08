import 'package:flutter/material.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.headingStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingTile(
            icon: Icons.dark_mode_rounded,
            title: 'Theme',
            subtitle: 'Dark Mode (Always Active)',
            trailingText: 'Dark',
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.attach_money_rounded,
            title: 'Base Currency',
            subtitle: 'Default display currency',
            trailingText: 'USD (\$)',
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.notifications_active_rounded,
            title: 'Push Notifications',
            subtitle: 'Price movement alerts',
            trailingWidget: Switch(
              value: true,
              onChanged: (_) {},
              activeThumbColor: AppTheme.accentGold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.security_rounded,
            title: 'Security',
            subtitle: 'Biometric unlock & PIN code',
            trailingText: 'Enabled',
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text(
                  'CryptoScope v1.0.0',
                  style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crypto Market Research & Analytics',
                  style: AppTheme.bodyStyle(fontSize: 11, color: AppTheme.textFaint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    Widget? trailingWidget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceRaised,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.accentGold, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.headingStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          if (trailingWidget != null)
            trailingWidget
          else if (trailingText != null)
            Text(
              trailingText,
              style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.accentGold),
            ),
        ],
      ),
    );
  }
}
