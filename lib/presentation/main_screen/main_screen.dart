import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../health_dashboard/health_dashboard.dart';
import '../medical_records_screen/medical_records_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../schedule_screen/schedule_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  static MainScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void switchToTab(int index) {
    if (index >= 0 && index < 4) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onBottomNavTapped(CustomBottomBarItem item) {
    // Navigate to the page corresponding to the item index
    // Enum order matches page order: HealthID (0), Records (1), Schedule (2), Profile (3)
    switchToTab(item.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Carousel effect
        children: const [
          HealthDashboard(),
          MedicalRecordsScreen(),
          ScheduleScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.values[_currentIndex],
        onItemSelected: _onBottomNavTapped,
      ),
    );
  }
}
