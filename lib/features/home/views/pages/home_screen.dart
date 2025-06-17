import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/sites/sites_screen.dart';
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
  int fireCount = 0;
  int faultCount = 0;
  int allEventsCount = 0;
  String fireCountText = '-';
  String faultCountText = '-';
  String allEventsCountText = '-';
  @override
  void initState() {
    super.initState();
    // Start polling logs when the screen loads (polls every 30 seconds)
    _startPolling();
  }

  @override
  void dispose() {
    // Stop polling when the screen is disposed
    context.read<LogsBloc>().add(LogsPollingStop());
    super.dispose();
  }

  void _startPolling() {
    // Start polling with 30-second interval (you can customize this)
    context.read<LogsBloc>().add(LogsPollingStarted(
      interval: const Duration(seconds: 30),
    ));
  }

  void _stopPolling() {
    context.read<LogsBloc>().add(LogsPollingStop());
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
            SliverAppBar(
              backgroundColor: ColorConstants.whiteColor,
              surfaceTintColor: ColorConstants.whiteColor,
              elevation: 0,
              pinned: true,
              expandedHeight: 120,
              automaticallyImplyLeading: false,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double appBarHeight = constraints.biggest.height;
                  final double statusBarHeight =
                      MediaQuery.of(context).padding.top;
                  final double minHeight = kToolbarHeight + statusBarHeight;
                  final double maxHeight = 120 + statusBarHeight;

                  // Calculate scroll progress (0.0 = fully expanded, 1.0 = fully collapsed)
                  final double scrollProgress = ((maxHeight - appBarHeight) /
                          (maxHeight - minHeight))
                      .clamp(0.0, 1.0);

                  // Calculate logo size and position based on scroll
                  final double logoSize =
                      60 - (25 * scrollProgress); // 60 -> 35
                  final double topPadding =
                      statusBarHeight + (20 * (1 - scrollProgress));

                  return Container(
                    color: ColorConstants.whiteColor,
                    child: Align(
                      alignment:
                          scrollProgress > 0.5
                              ? Alignment.bottomCenter
                              : Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: scrollProgress > 0.5 ? 0 : topPadding,
                          bottom: scrollProgress > 0.5 ? 16 : 0,
                        ),
                        child: Hero(
                          tag: 'emcus_logo',
                          child: SvgPicture.asset(
                            'assets/svgs/emcus_logo.svg',
                            height: logoSize,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildDashboardContent(),
                  const SizedBox(height: 39),
                  _buildRecentSites(),
                  const SizedBox(height: 39),
                  _buildRecentNotes(),

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

  Widget _buildDashboardContent() {
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
                Container(
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
                Container(
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
                            SvgPicture.asset('assets/svgs/fault_tile_icon.svg'),
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
                Container(
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
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentSites() {
    return BlocBuilder<LogsBloc, LogsState>(
      builder: (context, state) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SitesScreen(),
                  ),
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
}
