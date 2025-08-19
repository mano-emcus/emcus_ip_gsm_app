import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/bloc/theme_bloc.dart';
import 'package:emcus_ipgsm_app/utils/theme/bloc/theme_event.dart';
import 'package:emcus_ipgsm_app/utils/theme/bloc/theme_state.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthManager _authManager = AuthManager();

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final customColors = Theme.of(context).extension<CustomColors>()!;
        return AlertDialog(
          backgroundColor: customColors.themeSurface,
          title: Text(
            'Log Out',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: customColors.themeTextPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: customColors.themeTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: customColors.themeTextSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _authManager.logout(context);
              },
              child: Text(
                'Log Out',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotImplementedDialog() {
    showDialog(
      context: context,
      builder: (context) => const GenericYetToImplementPopUpWidget(),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final customColors = Theme.of(context).extension<CustomColors>()!;
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return AlertDialog(
              backgroundColor: customColors.themeSurface,
              title: Text(
                'Choose Theme',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: customColors.themeTextPrimary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(
                      'Light',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: customColors.themeTextPrimary,
                      ),
                    ),
                    value: ThemeMode.light,
                    groupValue: themeState.themeMode,
                    activeColor: ColorConstants.primaryColor,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        context.read<ThemeBloc>().add(ThemeChanged(value));
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(
                      'Dark',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: customColors.themeTextPrimary,
                      ),
                    ),
                    value: ThemeMode.dark,
                    groupValue: themeState.themeMode,
                    activeColor: ColorConstants.primaryColor,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        context.read<ThemeBloc>().add(ThemeChanged(value));
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(
                      'System',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: customColors.themeTextPrimary,
                      ),
                    ),
                    value: ThemeMode.system,
                    groupValue: themeState.themeMode,
                    activeColor: ColorConstants.primaryColor,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        context.read<ThemeBloc>().add(ThemeChanged(value));
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.themeBackground,
      appBar: AppBar(
        backgroundColor: customColors.themeBackground,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: customColors.themeTextPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: customColors.themeSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: customColors.themeBorder),
                  ),
                  child: Row(
                    children: [
                      // Profile Avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: customColors.themeBorder,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svgs/profile_icon.svg',
                            width: 30,
                            height: 30,
                            colorFilter: ColorFilter.mode(
                              customColors.themeTextSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: customColors.themeTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'john.doe@example.com',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: customColors.themeTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit Button
                      TextButton(
                        onPressed: _showNotImplementedDialog,
                        child: Text(
                          'Edit',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Account Section
                _buildSectionTitle('Account'),
                const SizedBox(height: 12),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: _showNotImplementedDialog,
                ),
                _buildMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getThemeModeText(themeState.themeMode),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: customColors.themeTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: customColors.themeTextSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: _showThemeDialog,
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: _showNotImplementedDialog,
                ),

                const SizedBox(height: 24),

                // App Information Section
                _buildSectionTitle('App Information'),
                const SizedBox(height: 12),
                _buildInfoItem('App Version', '1.2.0'),
                _buildInfoItem('Build Number', '156'),

                const SizedBox(height: 24),

                // Legal Section
                _buildSectionTitle('Legal'),
                const SizedBox(height: 12),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: _showNotImplementedDialog,
                ),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: _showNotImplementedDialog,
                ),

                const SizedBox(height: 32),

                // Log Out Button
                Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _showLogoutDialog,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Widget _buildSectionTitle(String title) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: customColors.themeTextPrimary,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: customColors.themeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: customColors.themeBorder),
      ),
      child: ListTile(
        leading: Icon(icon, color: customColors.themeTextSecondary, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: customColors.themeTextPrimary,
          ),
        ),
        trailing:
            trailing ??
            Icon(
              Icons.chevron_right,
              color: customColors.themeTextSecondary,
              size: 20,
            ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: customColors.themeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: customColors.themeBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: customColors.themeTextPrimary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: customColors.themeTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
