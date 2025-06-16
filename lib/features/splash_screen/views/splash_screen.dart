import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
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
  @override
  void initState() {
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SignInScreen(),
          ),
        );
      }
    });
    super.initState();
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
            Spacer(),
            Text(
              'Version 1.0',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ColorConstants.textColor,
              ),
            ),
            SizedBox(height: 15),
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
