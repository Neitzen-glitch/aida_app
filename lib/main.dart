import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // FIXED: Added Provider import

import 'core/supabase/supabase_client.dart';
import 'core/services/user_profile_service.dart'; // FIXED: Added your global service
import 'core/widgets/trial_banner.dart';


import 'features/dashboard/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/presence/screens/online_presence_screen.dart';
import 'features/operations/screens/operation_screens.dart';
import 'features/marketing/screens/marketing_screen.dart'; // Note: Ensure the file name is marketing_screen.dart
import 'features/deals/screens/deals_screen.dart';

void main() async {
  // Ensure Flutter bindings are ready before initializing Supabase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before the app starts
  await SupabaseConfig.initialize();

  // FIXED: We wrap the entire app in the ChangeNotifierProvider.
  // This makes the UserProfileService available to EVERY screen in your app.
  // The "..init()" part automatically fetches the data from Supabase on startup.
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfileService()..init(),
      child: const AidaApp(),
    ),
  );
}

class AidaApp extends StatelessWidget {
  const AidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIDA — Assistive Business OS',
      debugShowCheckedModeBanner: false,

      // Professional SaaS Theme: Deep blue and Slate
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0052CC), // Neitzen Blue Brightness
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0052CC),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      // If User is logged in, show the Main Nav, otherwise Login
      home: supabase.auth.currentSession == null
          ? const LoginScreen()
          : const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  // FIXED: Cleaned up the list! Exactly 4 screens for your 4 bottom nav items.
  final List<Widget> _screens = const [

    HomeScreen(),
    OnlinePresenceScreen(), // Tab 0: Presence
    OperationsScreen(),     // Tab 1: Ops
    MarketingScreen(),      // Tab 2: Marketing Hub
    DealsScreen(),          // Tab 3: Deals & Outreach Hub
  ];

  @override
  Widget build(BuildContext context) {
    // Because we wrapped AidaApp in the Provider up in main(),
    // this line will now work perfectly without crashing.
    final service = Provider.of<UserProfileService>(context);

    return Scaffold(
      body: Column(
        children: [
          const TrialBanner(), // Global banner
          Expanded(
            child: AbsorbPointer(
              absorbing: service.isExpired, // Locks all buttons if expired!
              child: Opacity(
                opacity: service.isExpired ? 0.5 : 1.0, // Visual "lock"
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        // Make sure the items show their colors correctly
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.language), label: "Presence"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ops"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Marketing"),
          BottomNavigationBarItem(icon: Icon(Icons.handshake), label: "Deals"),
        ],
      ),
    );
  }
}