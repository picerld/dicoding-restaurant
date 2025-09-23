import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/theme.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/restaurant_detail_page.dart';
import 'ui/pages/search_page.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (_) => const RestaurantListPage(),
                );
              } else if (settings.name == '/detail') {
                final id = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (_) => RestaurantDetailPage(id: id),
                );
              } else if (settings.name == '/search') {
                return MaterialPageRoute(builder: (_) => const SearchPage());
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
