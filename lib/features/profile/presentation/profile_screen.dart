import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Profile Screen + entry to Parent Dashboard
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myProfile)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ZelbyAvatar(size: 100, mood: 'happy'),
              const SizedBox(height: 16),
              Text(
                'Rafa (7 tahun)',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Bergabung sejak 12 Mei 2026',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 40),

              _ProfileMenuItem(
                icon: Icons.shield_rounded,
                label: AppStrings.parentDashboard,
                onTap: () {
                  // TODO: Add parent auth later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur orang tua akan hadir segera')),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ProfileMenuItem(
                icon: Icons.settings_rounded,
                label: AppStrings.settings,
                onTap: () {},
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Keluar',
                onPressed: () => context.goNamed('splash'),
                isSecondary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0B7A5C)),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white,
      onTap: onTap,
    );
  }
}
