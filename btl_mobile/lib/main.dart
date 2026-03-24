import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_mobile/providers/app_state.dart';
import 'package:btl_mobile/screens/auth/login_screen.dart';
import 'package:btl_mobile/screens/auth/register_screen.dart';
import 'package:btl_mobile/screens/home/home_screen.dart';
import 'package:btl_mobile/screens/explore/explore_screen.dart';
import 'package:btl_mobile/screens/community/community_screen.dart';
import 'package:btl_mobile/screens/profile/profile_screen.dart';
import 'package:btl_mobile/screens/settings/settings_screen.dart';
import 'package:btl_mobile/screens/venue_detail/venue_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'BTL Review & Check-in',
        theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/explore': (_) => const ExploreScreen(),
          '/community': (_) => const CommunityScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/settings': (_) => const SettingsScreen(),
          // ĐÃ XÓA DÒNG '/venue-detail' Ở ĐÂY
        },
        onGenerateRoute: (settings) {
          // Xử lý route có arguments
          if (settings.name == '/venue-detail') {
            final id = settings.arguments as int?;
            print('🎯 Main.dart nhận ID: $id');
            return MaterialPageRoute(
              builder: (context) => VenueDetailScreen(venueId: id),
            );
          }
          return null;
        },
      ),
    );
  }
}
