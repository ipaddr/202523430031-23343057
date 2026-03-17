import 'package:flutter/material.dart';
import '../themes.dart';
import 'scan_view.dart';
import 'history_view.dart';
import 'profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  
  final List<Widget> _views = [
    const ScanView(),
    const HistoryView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: MotifaTheme.black, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: MotifaTheme.black,
              offset: Offset(0, -4),
              blurRadius: 0,
            )
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: MotifaTheme.backgroundWhite,
          selectedItemColor: MotifaTheme.primaryBlue,
          unselectedItemColor: MotifaTheme.black.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined, size: 28),
              activeIcon: Icon(Icons.document_scanner, size: 28),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 28),
              activeIcon: Icon(Icons.history, size: 28),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
