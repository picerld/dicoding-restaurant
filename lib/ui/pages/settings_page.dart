import 'package:provider/provider.dart';
import 'package:restaurant_app/data/local/notification_service.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/provider/reminder_provider.dart';
import 'package:restaurant_app/provider/nav_provider.dart'; // ✅ import NavProvider
import 'package:restaurant_app/ui/widgets/bottom_nav.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../widgets/ui_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavProvider>().setIndex(context, 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final reminderProv = context.watch<ReminderProvider>();

    return Scaffold(
      headers: const [UiAppBar(title: "Settings", showBack: true)],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Tema",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ThemeButton(
                label: "Light",
                icon: Icons.light_mode,
                active: themeProv.themeMode == ThemeMode.light,
                onTap: () =>
                    context.read<ThemeProvider>().setTheme(ThemeMode.light),
              ),
              _ThemeButton(
                label: "Dark",
                icon: Icons.dark_mode,
                active: themeProv.themeMode == ThemeMode.dark,
                onTap: () =>
                    context.read<ThemeProvider>().setTheme(ThemeMode.dark),
              ),
              _ThemeButton(
                label: "System",
                icon: Icons.phone_iphone,
                active: themeProv.themeMode == ThemeMode.system,
                onTap: () =>
                    context.read<ThemeProvider>().setTheme(ThemeMode.system),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            "Daily Reminder",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          PrimaryButton(
            onPressed: () {
              NotificationService.showInstantNotification();
            },
            child: const Text("Test Notification"),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Ingatkan makan siang (11:00 AM)",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Switch(
                value: reminderProv.enabled,
                onChanged: (v) async {
                  if (v) {
                    await NotificationService.scheduleDailyAt11();
                    reminderProv.enable();
                  } else {
                    await NotificationService.cancelDaily();
                    reminderProv.disable();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Notifikasi terjadwal setiap hari pukul 11:00",
            style: TextStyle(fontSize: 12, color: Colors.gray),
          ),
        ],
      ),

      footers: [
        const Divider(),
        Consumer<NavProvider>(
          builder: (context, nav, _) => ShadcnBottomNav(
            currentIndex: nav.index,
            onTap: (i) => nav.setIndex(context, i),
          ),
        ),
      ],
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onTap,
      child: Row(
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
    );
  }
}
