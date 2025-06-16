import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogType { fire, fault, all }

class LogsListScreen extends StatefulWidget {
  final LogType logType;
  final String title;

  const LogsListScreen({
    super.key,
    required this.logType,
    required this.title,
  });

  @override
  State<LogsListScreen> createState() => _LogsListScreenState();
}

class _LogsListScreenState extends State<LogsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LogsBloc>().add(LogsFetched());
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs) {
    switch (widget.logType) {
      case LogType.fire:
        return logs.where((log) => log.u16EventId >= 1001 && log.u16EventId <= 1007).toList();
      case LogType.fault:
        return logs.where((log) => log.u16EventId >= 2000 && log.u16EventId < 3000).toList();
      case LogType.all:
        return logs;
    }
  }

  String _getStatusText(LogEntry log) {
    if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
      return 'Fire';
    } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
      return 'Fault';
    } else {
      return 'Event';
    }
  }

  Color _getStatusColor(LogEntry log) {
    if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
      return ColorConstants.fireTitleTextColor;
    } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
      return ColorConstants.faultTitleTextColor;
    } else {
      return ColorConstants.allEventsTitleTextColor;
    }
  }

  Color _getStatusBackgroundColor(LogEntry log) {
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
        appBar: AppBar(
          backgroundColor: ColorConstants.whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ColorConstants.textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorConstants.textColor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: ColorConstants.primaryColor,
              ),
              onPressed: () {
                context.read<LogsBloc>().add(LogsFetched());
              },
            ),
          ],
        ),
        body: BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            if (state is LogsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.primaryColor,
                ),
              );
            } else if (state is LogsSuccess) {
              final filteredLogs = _filterLogs(state.logs);
              
              if (filteredLogs.isEmpty) {
                return Center(
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
                        'No ${widget.title.toLowerCase()} found',
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
                padding: const EdgeInsets.all(16),
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
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
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
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    log.u8DeviceText,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(log),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getStatusText(log),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(log),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Zone',
                    log.u8ZoneNumber.toString(),
                    Icons.location_on_outlined,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Device',
                    log.u8DeviceAddress.toString(),
                    Icons.device_hub_outlined,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Source',
                    log.source,
                    log.source == 'IP' ? Icons.wifi : Icons.signal_cellular_4_bar,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  log.formattedDateTime,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Event ID: ${log.u16EventId}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
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
        Icon(
          icon,
          size: 20,
          color: ColorConstants.primaryColor,
        ),
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
} 