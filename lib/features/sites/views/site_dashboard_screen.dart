import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_state.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogType { fire, fault, all }

class SiteDashboardScreen extends StatefulWidget {
  const SiteDashboardScreen({super.key, required this.siteId});
  final int siteId;

  @override
  State<SiteDashboardScreen> createState() => _SiteDashboardScreenState();
}

class _SiteDashboardScreenState extends State<SiteDashboardScreen> {
  LogType selectedLogType = LogType.all;
  // LogsBloc? _logsBloc;
  SiteLogsBloc? _siteLogsBloc;

  @override
  void initState() {
    super.initState();
    _siteLogsBloc = context.read<SiteLogsBloc>();
    _fetchSiteLogs();
    // Start polling logs when the screen loads (polls every 30 seconds)
    Future.delayed(const Duration(seconds: 30), () {
      _startPolling();
    });
  }

  @override
  void dispose() {
    // Stop polling when the screen is disposed
    _stopPolling();
    super.dispose();
  }

  void _startPolling() {
    // Start polling with 30-second interval (you can customize this)
  }

  void _stopPolling() {
  }

  void _fetchSiteLogs() {
    _siteLogsBloc?.add(SiteLogsFetched(siteId: widget.siteId));
  }

  List<LogEntry> _filterLogs({required List<LogEntry> fireLogs, required List<LogEntry> faultLogs, required List<LogEntry> allLogs}) {
    switch (selectedLogType) {
      case LogType.fire:
        return fireLogs;
      case LogType.fault:
        return faultLogs;
      case LogType.all:
        return allLogs;
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
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
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
                  const SizedBox(height: 10),
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

  // // Helper methods to calculate log counts based on event IDs
  // int _getFireCount(List<LogEntry> logs) {
  //   return logs
  //       .where((log) => log.u16EventId >= 1001 && log.u16EventId <= 1007)
  //       .length;
  // }

  // int _getFaultCount(List<LogEntry> logs) {
  //   return logs
  //       .where((log) => log.u16EventId >= 2000 && log.u16EventId < 3000)
  //       .length;
  // }

  // int _getAllEventsCount(List<LogEntry> logs) {
  //   return logs.length;
  // }

  void _selectLogType(LogType logType) {
    setState(() {
      selectedLogType = logType;
    });
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
        BlocBuilder<SiteLogsBloc, SiteLogsState>(
          builder: (context, state) {
            int fireCount = 0;
            int faultCount = 0;
            int allEventsCount = 0;
            String fireCountText = '-';
            String faultCountText = '-';
            String allEventsCountText = '-';

            if (state is SiteLogsSuccess) {
              fireCount = state.logs[0].fireCount;
              faultCount = state.logs[0].faultCount;
              allEventsCount = state.logs[0].allCount;
              fireCountText = fireCount.toString();
              faultCountText = faultCount.toString();
              allEventsCountText = allEventsCount.toString();
            } else if (state is SiteLogsLoading) {
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
                  onTap: () {
                    _selectLogType(LogType.fire);
                  },
                  child: Opacity(
                    opacity: selectedLogType == LogType.fire ? 1 : 0.5,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/fire_tile_icon.svg',
                                  height: 32,
                                ),
                                Text(
                                  fireCountText,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
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
                ),
                GestureDetector(
                  onTap: () {
                    _selectLogType(LogType.fault);
                  },
                  child: Opacity(
                    opacity: selectedLogType == LogType.fault ? 1 : 0.5,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/fault_tile_icon.svg',
                                ),
                                Text(
                                  faultCountText,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
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
                ),
                GestureDetector(
                  onTap: () {
                    _selectLogType(LogType.all);
                  },
                  child: Opacity(
                    opacity: selectedLogType == LogType.all ? 1 : 0.5,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/all_event_tile_icon.svg',
                                ),
                                Text(
                                  allEventsCountText,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
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
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventLogs() {
    return BlocBuilder<SiteLogsBloc, SiteLogsState>(
      builder: (context, state) {
        if (state is SiteLogsLoading) {
          return Padding(
            padding: const EdgeInsets.only(top: 100),
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.primaryColor,
              ),
            ),
          );
        } else if (state is SiteLogsSuccess) {
          final fireLogs = state.logs[0].fire.reversed.toList();
          final faultLogs = state.logs[0].fault.reversed.toList();
          final allLogs = state.logs[0].all.reversed.toList();
          final filteredLogs = _filterLogs(fireLogs: fireLogs, faultLogs: faultLogs, allLogs: allLogs).reversed.toList();
          if (filteredLogs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
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
              ),
            );
          }

          return SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.bottom -
                180,
            child: RefreshIndicator(
              backgroundColor: ColorConstants.whiteColor,
              color: ColorConstants.primaryColor,
              onRefresh: () async {
                _fetchSiteLogs();
              },
              child: ListView.builder(
                itemCount: filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = filteredLogs[index];
                  return _buildLogCard(log);
                },
              ),
            ),
          );
        } else if (state is SiteLogsFailure) {
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
                    _fetchSiteLogs();
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
                  'Serial No',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.u8SerialNumber.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Device Address',
            //       style: GoogleFonts.inter(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w600,
            //         color: ColorConstants.primaryColor,
            //       ),
            //     ),
            //     const SizedBox(height: 4),
            //     Text(
            //       log.u8DeviceAddress.toString(),
            //       style: GoogleFonts.inter(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w400,
            //         color: ColorConstants.textColor,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),
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
                    color:
                        log.source.toLowerCase() == 'gsm'
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
}
