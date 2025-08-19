import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/logs/widgets/logs_card.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogFilter { all, fire, fault, general }

class AllLogsScreen extends StatefulWidget {
  const AllLogsScreen({super.key});

  @override
  State<AllLogsScreen> createState() => _AllLogsScreenState();
}

class _AllLogsScreenState extends State<AllLogsScreen> {
  LogFilter selectedFilter = LogFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  LogsBloc? _logsBloc;
  // bool _isSocketConnected = false;

  @override
  void initState() {
    super.initState();
    _logsBloc = context.read<LogsBloc>();
    _fetchLogs();
    // Listen to socket connection status
    // final socket = getIt<SocketService>().socket;
    // if (socket != null) {
    //   _isSocketConnected = socket.connected;
    //   socket.on('connect', (_) {
    //     setState(() {
    //       _isSocketConnected = true;
    //     });
    //   });
    //   socket.on('disconnect', (_) {
    //     setState(() {
    //       _isSocketConnected = false;
    //     });
    //   });
    // }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchLogs() {
    _logsBloc?.add(LogsFetched());
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs) {
    List<LogEntry> filteredLogs = logs;

    // Apply filter based on selected type
    switch (selectedFilter) {
      case LogFilter.fire:
        filteredLogs =
            logs
                .where(
                  (log) => log.u16EventId >= 1001 && log.u16EventId <= 1007,
                )
                .toList();
        break;
      case LogFilter.fault:
        filteredLogs =
            logs
                .where((log) => log.u16EventId >= 2000 && log.u16EventId < 3000)
                .toList();
        break;
      case LogFilter.general:
        filteredLogs =
            logs
                .where(
                  (log) =>
                      !(log.u16EventId >= 2000 && log.u16EventId < 3000) &&
                      !(log.u16EventId >= 1001 && log.u16EventId <= 1007),
                )
                .toList();
        break;
      case LogFilter.all:
        filteredLogs = logs;
        break;
    }

    // Apply search filter if search query is not empty
    if (searchQuery.isNotEmpty) {
      filteredLogs =
          filteredLogs.where((log) {
            return log.u8DeviceText.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                log.source.toLowerCase().contains(searchQuery.toLowerCase()) ||
                log.formattedDateTime.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                _getLogTypeText(
                  log,
                ).toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();
    }

    // Sort by most recent first
    filteredLogs.sort((a, b) {
      // Create DateTime objects for comparison
      final dateTimeA = DateTime(
        a.u8Year,
        a.u8Month,
        a.u8Date,
        a.u8Hours,
        a.u8Minutes,
        a.u8Seconds,
      );
      final dateTimeB = DateTime(
        b.u8Year,
        b.u8Month,
        b.u8Date,
        b.u8Hours,
        b.u8Minutes,
        b.u8Seconds,
      );
      return dateTimeB.compareTo(dateTimeA); // Most recent first
    });

    return filteredLogs;
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
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
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
        backgroundColor: customColors.themeBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // TEMP SOCKET STATUS INDICATOR
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: 12,
                //         height: 12,
                //         decoration: BoxDecoration(
                //           color: _isSocketConnected ? Colors.green : Colors.red,
                //           shape: BoxShape.circle,
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       Text(
                //         _isSocketConnected
                //             ? 'Socket Connected'
                //             : 'Socket Disconnected',
                //         style: TextStyle(
                //           color: _isSocketConnected ? Colors.green : Colors.red,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Header
                _buildHeader(customColors),
                const SizedBox(height: 16),

                // Search Bar
                // _buildSearchBar(),

                // Filter Chips
                _buildFilterChips(customColors),
                const SizedBox(height: 16),

                // Logs List
                Expanded(child: _buildLogsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CustomColors customColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Logs',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: customColors.themeTextPrimary,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                color: customColors.themeTextSecondary,
              ),
            ),
            IconButton(
              onPressed: () {
                // Show filter options or sort options
                _showFilterModal(context);
              },
              icon: Icon(
                Icons.filter_list_outlined,
                color: customColors.themeTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 26),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: TextField(
  //         controller: _searchController,
  //         decoration: InputDecoration(
  //           hintText: 'Search logs...',
  //           hintStyle: GoogleFonts.inter(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w400,
  //             color: ColorConstants.greyColor,
  //           ),
  //           prefixIcon: const Icon(
  //             Icons.search,
  //             color: ColorConstants.greyColor,
  //           ),
  //           suffixIcon:
  //               searchQuery.isNotEmpty
  //                   ? IconButton(
  //                     icon: const Icon(
  //                       Icons.clear,
  //                       color: ColorConstants.greyColor,
  //                     ),
  //                     onPressed: () {
  //                       _searchController.clear();
  //                       setState(() {
  //                         searchQuery = '';
  //                       });
  //                     },
  //                   )
  //                   : null,
  //           border: InputBorder.none,
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 16,
  //             vertical: 12,
  //           ),
  //         ),
  //         onChanged: (value) {
  //           setState(() {
  //             searchQuery = value;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFilterChips(CustomColors customColors) {
    return Row(
      children: [
        _buildFilterChip('All', LogFilter.all, customColors),
        const SizedBox(width: 12),
        _buildFilterChip('Fire', LogFilter.fire, customColors),
        const SizedBox(width: 12),
        _buildFilterChip('Fault', LogFilter.fault, customColors),
        const SizedBox(width: 12),
        _buildFilterChip('General', LogFilter.general, customColors),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    LogFilter filter,
    CustomColors customColors,
  ) {
    final bool isSelected = selectedFilter == filter;
    Color backgroundColor;
    Color textColor;

    if (isSelected) {
      backgroundColor = customColors.primaryColor.withValues(alpha: 0.2);
      textColor = customColors.primaryColor;
    } else {
      backgroundColor = customColors.themeTextFieldBackgroud;
      textColor = customColors.themeTextPrimary;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLogsList() {
    return BlocBuilder<LogsBloc, LogsState>(
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
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              _fetchLogs();
            },
            color: ColorConstants.primaryColor,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                return _buildLogCard(log);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
            ),
          );
        } else if (state is LogsFailure) {
          return _buildErrorState();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    switch (selectedFilter) {
      case LogFilter.fire:
        message =
            searchQuery.isNotEmpty
                ? 'No fire logs found for "$searchQuery"'
                : 'No fire logs found';
        break;
      case LogFilter.fault:
        message =
            searchQuery.isNotEmpty
                ? 'No fault logs found for "$searchQuery"'
                : 'No fault logs found';
        break;
      case LogFilter.all:
        message =
            searchQuery.isNotEmpty
                ? 'No logs found for "$searchQuery"'
                : 'No logs found';
        break;
      case LogFilter.general:
        message =
            searchQuery.isNotEmpty
                ? 'No general logs found for "$searchQuery"'
                : 'No general logs found';
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty ? Icons.search_off : Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery.isNotEmpty) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  foregroundColor: ColorConstants.whiteColor,
                ),
                child: Text(
                  'Clear Search',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
                _fetchLogs();
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
      ),
    );
  }

  Widget _buildLogCard(LogEntry log) {
    return Column(
      children: [
        LogsCard(log: log),
        Container(
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
                // Header row with status badge and event ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getLogTypeBackgroundColor(log),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _getLogTypeColor(log).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _getLogTypeText(log),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getLogTypeColor(log),
                        ),
                      ),
                    ),
                    Text(
                      'ID: ${log.u16EventId}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.greyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Device information
                if (log.u8DeviceText.isNotEmpty) ...[
                  Text(
                    log.u8DeviceText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Zone and Device Address
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow('Zone', log.u8ZoneNumber.toString()),
                    ),
                    Expanded(
                      child: _buildInfoRow(
                        'Device',
                        log.u8DeviceAddress.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Source and Date Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Source: ',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.greyColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
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
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      log.formattedDateTime,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.greyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorConstants.greyColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ColorConstants.textColor,
          ),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Options',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textColor,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.sort,
                  color: ColorConstants.primaryColor,
                ),
                title: Text(
                  'Sort by Date (Newest First)',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Currently active',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ColorConstants.greyColor,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: ColorConstants.primaryColor,
                ),
                title: Text(
                  'About Filters',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Use the filter chips above to filter by log type',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ColorConstants.greyColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    foregroundColor: ColorConstants.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
