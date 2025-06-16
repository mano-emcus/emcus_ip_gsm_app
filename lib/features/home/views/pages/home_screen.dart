import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/logs/views/logs_list_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch logs when the screen loads
    _fetchLogs();
  }

  void _fetchLogs() {
    context.read<LogsBloc>().add(LogsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogsBloc, LogsState>(
      listener: (context, state) {
        if (state is LogsFailure) {
          // Check if it's an authentication error
          if (state.error.contains('AuthenticationException') || 
              state.error.contains('No valid authentication token') ||
              state.error.contains('Missing Authorization header')) {
            // Authentication failed, redirect to sign-in
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SignInScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            // Show error message for other failures
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load logs: ${state.error}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstants.whiteColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  children: [
                    _buildDashboard(),
                    const SizedBox(height: 39),
                    _buildRecentSites(),
                    const SizedBox(height: 39),
                    _buildRecentNotes(),
                    const SizedBox(height: 39),
                    _buildLogoutButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper methods to calculate log counts based on event IDs
  int _getFireCount(List<LogEntry> logs) {
    return logs.where((log) => log.u16EventId >= 1001 && log.u16EventId <= 1007).length;
  }

  int _getFaultCount(List<LogEntry> logs) {
    return logs.where((log) => log.u16EventId >= 2000 && log.u16EventId < 3000).length;
  }

  int _getAllEventsCount(List<LogEntry> logs) {
    return logs.length;
  }

  void _navigateToLogsList(LogType logType, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LogsBloc(),
          child: LogsListScreen(
            logType: logType,
            title: title,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Column(
      children: [
        SizedBox(height: 46 + MediaQuery.of(context).padding.top),
        SvgPicture.asset('assets/svgs/emcus_logo.svg'),
        const SizedBox(height: 43),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Dashboard',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorConstants.textColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            int fireCount = 0;
            int faultCount = 0;
            int allEventsCount = 0;
            String fireCountText = '-';
            String faultCountText = '-';
            String allEventsCountText = '-';

            if (state is LogsSuccess) {
              fireCount = _getFireCount(state.logs);
              faultCount = _getFaultCount(state.logs);
              allEventsCount = _getAllEventsCount(state.logs);
              fireCountText = fireCount.toString();
              faultCountText = faultCount.toString();
              allEventsCountText = allEventsCount.toString();
            } else if (state is LogsLoading) {
              fireCountText = '...';
              faultCountText = '...';
              allEventsCountText = '...';
            }

            return GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.25,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () => _navigateToLogsList(LogType.fire, 'Fire Events'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.fireTitleBackGroundColor,
                      border: Border.all(color: ColorConstants.fireTitleBorderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 17,
                        right: 13,
                        bottom: 9,
                        left: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              fireCountText,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.blackColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Fire',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.fireTitleTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToLogsList(LogType.fault, 'Fault Events'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.faultTitleBackGroundColor,
                      border: Border.all(color: ColorConstants.faultTitleBorderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 17,
                        right: 13,
                        bottom: 9,
                        left: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              faultCountText,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.blackColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Fault',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.faultTitleTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToLogsList(LogType.all, 'All Events'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.allEventsTitleBackGroundColor,
                      border: Border.all(
                        color: ColorConstants.allEventsTitleBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 17,
                        right: 13,
                        bottom: 9,
                        left: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              allEventsCountText,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.blackColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'All Events',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.allEventsTitleTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentSites() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Sites',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConstants.textColor,
              ),
            ),
            SvgPicture.asset('assets/svgs/arrow_forward_icon.svg'),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => GenericYetToImplementPopUpWidget(
                    title: 'Recent Sites',
                    message: 'This feature is not yet implemented',
                    onClose: () {},
                  ),
            );
          },
          child: Container(
            height: 68,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Recent Sites',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.textColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => GenericYetToImplementPopUpWidget(
                    title: 'Recent Sites',
                    message: 'This feature is not yet implemented',
                    onClose: () {},
                  ),
            );
          },
          child: Container(
            height: 68,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Recent Sites',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.textColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => GenericYetToImplementPopUpWidget(
                    title: 'Recent Sites',
                    message: 'This feature is not yet implemented',
                    onClose: () {},
                  ),
            );
          },
          child: Container(
            height: 68,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Recent Sites',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.textColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentNotes() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Notes',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConstants.textColor,
              ),
            ),
            SvgPicture.asset('assets/svgs/arrow_forward_icon.svg'),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.25,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => GenericYetToImplementPopUpWidget(
                    title: 'Recent Notes',
                    message: 'This feature is not yet implemented',
                    onClose: () {},
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                
              ),
            ),
            GestureDetector(
               onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => GenericYetToImplementPopUpWidget(
                    title: 'Recent Notes',
                    message: 'This feature is not yet implemented',
                    onClose: () {},
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                
              ),
            ),
            GestureDetector(
               onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => GenericYetToImplementPopUpWidget(
                    title: 'Recent Notes',
                    message: 'This feature is not yet implemented',
                    onClose: () {},
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          foregroundColor: ColorConstants.whiteColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorConstants.textColor,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorConstants.textColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await AuthManager().logout(context);
              },
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
