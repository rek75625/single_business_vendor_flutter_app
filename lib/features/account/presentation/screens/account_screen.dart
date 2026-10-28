import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          // User Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'john.doe@email.com',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.tonal(
                        onPressed: () => context.push('/edit-profile'),
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Menu Items
          _MenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'View your order history',
            onTap: () => context.push('/orders'),
          ),
          _MenuItem(
            icon: Icons.location_on_outlined,
            title: 'Addresses',
            subtitle: 'Manage delivery addresses',
            onTap: () => context.push('/addresses'),
          ),
          _MenuItem(
            icon: Icons.favorite_outline,
            title: 'Favorites',
            subtitle: 'View your favorite products',
            onTap: () => context.go('/favorites'),
          ),
          _MenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () => context.push('/notifications'),
          ),
          _MenuItem(
            icon: Icons.support_agent_outlined,
            title: 'Support',
            subtitle: 'Get help with your orders',
            onTap: () => context.push('/support'),
          ),

          const Divider(),

          // Settings
          _MenuItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          _MenuItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Switch(
              value: theme.brightness == Brightness.dark,
              onChanged: (value) {
                // TODO: Implement theme toggle
              },
            ),
          ),
          _MenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ShopVendor',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(
                  Icons.shopping_bag,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              );
            },
          ),

          const Divider(),

          // Logout
          _MenuItem(
            icon: Icons.logout,
            title: 'Logout',
            iconColor: theme.colorScheme.error,
            titleColor: theme.colorScheme.error,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: titleColor != null
            ? theme.textTheme.titleMedium?.copyWith(color: titleColor)
            : null,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
