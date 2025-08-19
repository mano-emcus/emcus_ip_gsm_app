import 'package:emcus_ipgsm_app/features/home/views/pages/home_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/views/all_logs_screen.dart';
import 'package:emcus_ipgsm_app/features/notes/views/all_notes_screen.dart';
import 'package:emcus_ipgsm_app/features/profile/views/profile_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
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
    const HomeScreen(),
    const AllLogsScreen(),
    const AllNotesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void _showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Logout',
  //           style: GoogleFonts.inter(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w600,
  //             color: ColorConstants.textColor,
  //           ),
  //         ),
  //         content: Text(
  //           'Are you sure you want to logout?',
  //           style: GoogleFonts.inter(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //             color: ColorConstants.textColor,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text(
  //               'Cancel',
  //               style: GoogleFonts.inter(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop(); // Close dialog first
  //               await AuthManager().logout(context);
  //             },
  //             child: Text(
  //               'Logout',
  //               style: GoogleFonts.inter(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 color: ColorConstants.primaryColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 80 + MediaQuery.of(context).padding.bottom,
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
                    _selectedIndex == 0
                        ? ColorConstants.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Transform.translate(
                  offset: const Offset(
                    0,
                    -2,
                  ), // Move the entire icon up by 2 pixels
                  child: SvgPicture.asset(
                    'assets/svgs/logs_icon.svg',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 1
                          ? ColorConstants.primaryColor
                          : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                label: 'Logs',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/notes_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 2
                        ? ColorConstants.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/profile_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 3
                        ? ColorConstants.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: ColorConstants.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            backgroundColor: customColors.themeSurface,
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
