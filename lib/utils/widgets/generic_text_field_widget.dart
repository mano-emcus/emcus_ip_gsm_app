import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericTextFieldWidget extends StatefulWidget {
  const GenericTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    this.obscureText,
    this.isPassword,
    this.isEmail,
    this.readOnly,
  });
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool? obscureText;
  final bool? isPassword;
  final bool? isEmail;
  final bool? readOnly;

  @override
  State<GenericTextFieldWidget> createState() => _GenericTextFieldWidgetState();
}

class _GenericTextFieldWidgetState extends State<GenericTextFieldWidget> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !(widget.obscureText ?? false);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: customColors.themeTextFieldBackgroud,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            readOnly: widget.readOnly ?? false,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText:
                widget.isPassword == true
                    ? !_isPasswordVisible
                    : (widget.obscureText ?? false),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: customColors.themeTextPrimary,
            ),
            obscuringCharacter: '*',
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorConstants.greyColor,
              ),
              suffixIcon:
                  widget.isPassword == true
                      ? IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ColorConstants.greyColor,
                          size: 20,
                        ),
                        onPressed: _togglePasswordVisibility,
                      )
                      : null,
            ),
          ),
        ),
      ],
    );
  }
}
