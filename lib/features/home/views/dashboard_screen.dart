import 'package:emcus_ipgsm_app/features/home/views/pages/home_screen.dart';
import 'package:emcus_ipgsm_app/features/home/views/pages/notes_screen.dart';
import 'package:emcus_ipgsm_app/features/home/views/pages/sites_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    HomeScreen(),
    SitesScreen(),
    NotesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/home_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0 ? ColorConstants.primaryColor : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/sites_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 1 ? ColorConstants.primaryColor : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Sites',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/notes_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 2 ? ColorConstants.primaryColor : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Notes',
              ),
              
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: ColorConstants.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            backgroundColor: ColorConstants.whiteColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
