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
import 'package:btl_mobile/screens/check_in/check_in_screen.dart';
import 'package:btl_mobile/screens/venue_detail/venue_detail_screen.dart';
import 'package:btl_mobile/screens/rewards/rewards_screen.dart';

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
          '/checkin': (_) => const CheckInScreen(),
          '/rewards': (_) => const RewardsScreen(),
        },
        onGenerateRoute: (settings) {
          // Xử lý route có arguments
          if (settings.name == '/venue-detail') {
            return MaterialPageRoute(
              builder: (context) => const VenueDetailScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}
