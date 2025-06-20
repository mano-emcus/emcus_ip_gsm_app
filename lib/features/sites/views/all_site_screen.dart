import 'package:emcus_ipgsm_app/features/sites/sites_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';

class AllSitesScreen extends StatefulWidget {
  const AllSitesScreen({super.key});

  @override
  State<AllSitesScreen> createState() => _AllSitesScreenState();
}

class _AllSitesScreenState extends State<AllSitesScreen> {
  LogsBloc? _logsBloc; // Add this field to store the bloc reference

  @override
  void initState() {
    super.initState();
    _logsBloc = context.read<LogsBloc>(); // Store the bloc reference
    _fetchLogs();
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
    _logsBloc?.add(LogsPollingStarted()); // Use stored reference
  }

  void _stopPolling() {
    _logsBloc?.add(LogsPollingStop()); // Use stored reference instead of context.read
  }

  void _fetchLogs() {
    _logsBloc?.add(LogsFetched()); // Use stored reference
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Padding(
        padding: EdgeInsets.only(
          left: 17,
          right: 17,
          top: MediaQuery.of(context).padding.top + 16,
        ),
        child: _buildRecentSites(),
      ),
    );
  }

  Widget _buildRecentSites() {
    return BlocBuilder<LogsBloc, LogsState>(
      builder: (context, state) {
        String fireCountText = '-';
        String faultCountText = '-';
        String allEventsCountText = '-';

        if (state is LogsSuccess) {
          final int fireCount = _getFireCount(state.logs);
          final int faultCount = _getFaultCount(state.logs);
          final int allEventsCount = _getAllEventsCount(state.logs);
          fireCountText = fireCount.toString();
          faultCountText = faultCount.toString();
          allEventsCountText = allEventsCount.toString();
        } else if (state is LogsLoading) {
          fireCountText = '...';
          faultCountText = '...';
          allEventsCountText = '...';
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            SvgPicture.asset('assets/svgs/emcus_logo.svg'),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sites',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SitesScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 17,
                    right: 17,
                    top: 13,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emcus',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Fire : ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: fireCountText,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Fault : ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: faultCountText,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'All Events : ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: allEventsCountText,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }
}
