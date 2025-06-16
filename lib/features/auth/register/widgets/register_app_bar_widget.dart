import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterAppBarWidget extends StatelessWidget {
  const RegisterAppBarWidget({super.key, required this.title, this.isBackButtonVisible = false});
  final String title;
  final bool isBackButtonVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: <Widget>[
          if (isBackButtonVisible)
            SvgPicture.asset(
              'assets/svgs/arrow_back_icon.svg',
              width: 24,
              height: 24,
            ),
          const SizedBox(width: 15),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorConstants.blackColor,
            ),
          ),
          const Spacer(),
          SvgPicture.asset('assets/svgs/emcus_logo.svg', width: 147),
        ],
      ),
    );
  }
}
