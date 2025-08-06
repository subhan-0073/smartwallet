import 'package:flutter/material.dart';
import 'package:smartwallet/screens/categories_screen.dart';
import 'package:smartwallet/screens/dashboard_screen.dart';
import 'package:smartwallet/screens/report_screen.dart';
import 'package:smartwallet/screens/settings_screen.dart';
import '../screens/add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> get _pages => [
    DashboardScreen(
      toggleTheme: widget.toggleTheme,
      currentThemeMode: widget.currentThemeMode,
    ),
    ReportScreen(),
    AddExpenseScreen(),
    CategoriesScreen(),
    SettingsScreen(),
  ];

  void navigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,

        currentIndex: _selectedIndex,
        onTap: (value) {
          navigate(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: "Report",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_rounded), label: "Add"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
