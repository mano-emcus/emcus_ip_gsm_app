import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogType { fire, fault, all }

class SiteDashboardScreen extends StatefulWidget {
  const SiteDashboardScreen({super.key, required this.siteName});
  final String siteName;

  @override
  State<SiteDashboardScreen> createState() => _SiteDashboardScreenState();
}

class _SiteDashboardScreenState extends State<SiteDashboardScreen> {
  LogType selectedLogType = LogType.fire;
  @override
  void initState() {
    super.initState();
    // Fetch logs when the screen loads
    _fetchLogs();
  }

  void _fetchLogs() {
    context.read<LogsBloc>().add(LogsFetched());
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs) {
    switch (selectedLogType) {
      case LogType.fire:
        return logs
            .where((log) => log.u16EventId >= 1001 && log.u16EventId <= 1007)
            .toList();
      case LogType.fault:
        return logs
            .where((log) => log.u16EventId >= 2000 && log.u16EventId < 3000)
            .toList();
      case LogType.all:
        return logs;
    }
  }

  String _getLogTypeText(LogEntry log) {
    if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
      return 'Fire';
    } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
      return 'Fault';
    } else {
      return 'Event';
    }
  }

  Color _getLogTypeColor(LogEntry log) {
    if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
      return ColorConstants.fireTitleTextColor;
    } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
      return ColorConstants.faultTitleTextColor;
    } else {
      return ColorConstants.allEventsTitleTextColor;
    }
  }

  Color _getLogTypeBackgroundColor(LogEntry log) {
    if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
      return ColorConstants.fireTitleBackGroundColor;
    } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
      return ColorConstants.faultTitleBackGroundColor;
    } else {
      return ColorConstants.allEventsTitleBackGroundColor;
    }
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
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 600),
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const SignInScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, -0.15),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
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
        body: CustomScrollView(
          slivers: [
            _buildSiteAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                Divider(
                  color: ColorConstants.textFieldBorderColor,
                  thickness: 1,
                ),
              ]),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildDashboardContent(selectedLogType),
                  // const SizedBox(height: 39),
                  _buildEventLogs(),

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to calculate log counts based on event IDs
  int _getFireCount(List<LogEntry> logs) {
    return logs
        .where((log) => log.u16EventId >= 1001 && log.u16EventId <= 1007)
        .length;
  }

  int _getFaultCount(List<LogEntry> logs) {
    return logs
        .where((log) => log.u16EventId >= 2000 && log.u16EventId < 3000)
        .length;
  }

  int _getAllEventsCount(List<LogEntry> logs) {
    return logs.length;
  }

  void _selectLogType(LogType logType) {
    setState(() {
      selectedLogType = logType;
    });
  }

  Widget _buildSiteAppBar() {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorConstants.textColor,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: ColorConstants.primaryColor),
          onPressed: () {
            context.read<LogsBloc>().add(LogsFetched());
          },
        ),
      ],
      centerTitle: true,
      title: Text(
        widget.siteName,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorConstants.primaryColor,
        ),
      ),
      backgroundColor: ColorConstants.whiteColor,
    );
  }

  Widget _buildDashboardContent(LogType selectedLogType) {
    return Column(
      children: [
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
              crossAxisSpacing: 8,
              childAspectRatio: 1.25,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () => _selectLogType(LogType.fire),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.fireTitleBackGroundColor,
                      border: Border.all(
                        color: ColorConstants.fireTitleBorderColor,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(
                            opacity: selectedLogType == LogType.fire ? 1 : 0.5,
                            child: SvgPicture.asset(
                              'assets/svgs/fire_tile_icon.svg',
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fireCountText,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.blackColor,
                                ),
                              ),
                              Text(
                                'Fire',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.fireTitleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectLogType(LogType.fault),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.faultTitleBackGroundColor,
                      border: Border.all(
                        color: ColorConstants.faultTitleBorderColor,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(
                            opacity: selectedLogType == LogType.fault ? 1 : 0.5,
                            child: SvgPicture.asset(
                              'assets/svgs/fault_tile_icon.svg',
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                faultCountText,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.blackColor,
                                ),
                              ),
                              Text(
                                'Fault',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.faultTitleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectLogType(LogType.all),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(
                            opacity: selectedLogType == LogType.all ? 1 : 0.5,
                            child: SvgPicture.asset(
                              'assets/svgs/all_event_tile_icon.svg',
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                allEventsCountText,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.blackColor,
                                ),
                              ),
                              Text(
                                'Events',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.allEventsTitleTextColor,
                                ),
                              ),
                            ],
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

  Widget _buildEventLogs() {
    return BlocBuilder<LogsBloc, LogsState>(
      builder: (context, state) {
        if (state is LogsLoading) {
          return Padding(
            padding: const EdgeInsets.only(top: 100),
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.primaryColor,
              ),
            ),
          );
        } else if (state is LogsSuccess) {
          final filteredLogs = _filterLogs(state.logs);

          if (filteredLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No ${selectedLogType.name.toLowerCase()} found',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredLogs.length,
            itemBuilder: (context, index) {
              final log = filteredLogs[index];
              return _buildLogCard(log);
            },
          );
        } else if (state is LogsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Failed to load logs',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<LogsBloc>().add(LogsFetched());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    foregroundColor: ColorConstants.whiteColor,
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLogCard(LogEntry log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Zone Address and Device Address
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Zone Address',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.u8ZoneNumber.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Device Address',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.u8DeviceAddress.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Second row: Source
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Source',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 5,
                    top: 1,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: log.source.toLowerCase() == 'gsm'
                        ? ColorConstants.gsmBackGroundColor
                        : ColorConstants.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.source,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.allEventsTitleBackGroundColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Third row: Date & Time and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date & Time',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.formattedDateTime,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getLogTypeText(log),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _getLogTypeColor(log),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: ColorConstants.primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ColorConstants.textColor,
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
                  builder:
                      (context) => GenericYetToImplementPopUpWidget(
                        title: 'Recent Notes',
                        message: 'This feature is not yet implemented',
                        onClose: () {},
                      ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => GenericYetToImplementPopUpWidget(
                        title: 'Recent Notes',
                        message: 'This feature is not yet implemented',
                        onClose: () {},
                      ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => GenericYetToImplementPopUpWidget(
                        title: 'Recent Notes',
                        message: 'This feature is not yet implemented',
                        onClose: () {},
                      ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(
                    alpha: 0.3,
                  ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
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
