import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api_service.dart';
import 'package:restaurant_app/data/local/notification_service.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/nav_provider.dart';
import 'package:restaurant_app/provider/reminder_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/theme.dart';
import 'package:restaurant_app/ui/pages/favorite_page.dart';
import 'package:restaurant_app/ui/pages/settings_page.dart';
import 'package:restaurant_app/ui/pages/restaurant_list_page.dart';
import 'package:restaurant_app/ui/pages/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/pages/search_page.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await NotificationService.scheduleDailyAt11();

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()..loadFavorites()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()..load()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return ShadcnApp(
            title: "Restaurant",
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                      builder: (_) => const RestaurantListPage());
                case '/detail':
                  final id = settings.arguments as String;
                  return MaterialPageRoute(
                      builder: (_) => RestaurantDetailPage(id: id));
                case '/search':
                  return MaterialPageRoute(builder: (_) => const SearchPage());
                case '/favorites':
                  return MaterialPageRoute(builder: (_) => const FavoritePage());
                case '/settings':
                  return MaterialPageRoute(builder: (_) => const SettingsPage());
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
