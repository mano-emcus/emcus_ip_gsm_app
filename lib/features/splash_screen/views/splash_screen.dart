import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/home/views/dashboard_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthManager _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash screen display duration
    await Future.delayed(const Duration(seconds: 4));
    
    if (!mounted) return;
    
    // Check if user is already signed in
    final isSignedIn = await _authManager.isAuthenticated();
    
    if (isSignedIn) {
      // User has valid token, navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const DashBoardScreen(),
        ),
      );
    } else {
      // User doesn't have token, navigate to sign in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
            SvgPicture.asset('assets/svgs/emcus_logo.svg'),
            const Spacer(),
            Text(
              'Version 1.0',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ColorConstants.textColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Copyrighted, EMCUS & its Associates',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ColorConstants.textColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: SvgPicture.asset(
                    'assets/svgs/splash_bottom_left_icon.svg',
                  ),
                ),
                Flexible(
                  child: SvgPicture.asset(
                    'assets/svgs/splash_bottom_right_icon.svg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
