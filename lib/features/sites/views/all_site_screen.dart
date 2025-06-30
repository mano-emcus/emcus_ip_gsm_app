import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/sites/widgets/site_card.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_event.dart';
import 'package:emcus_ipgsm_app/core/services/di.dart';

class AllSitesScreen extends StatefulWidget {
  const AllSitesScreen({super.key});

  @override
  State<AllSitesScreen> createState() => _AllSitesScreenState();
}

class _AllSitesScreenState extends State<AllSitesScreen> {
  SitesBloc? _sitesBloc;

  @override
  void initState() {
    super.initState();
    _sitesBloc = context.read<SitesBloc>();
    _fetchSites();
  }

  void _fetchSites() {
    _sitesBloc?.add(SitesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SitesBloc, SitesState>(
      listener: (context, state) {
        if (state is SitesFailure) {
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
                content: Text('Failed to load sites: ${state.error}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstants.whiteColor,
        body: Padding(
          padding: EdgeInsets.only(
            left: 17,
            right: 17,
            top: MediaQuery.of(context).padding.top + 16,
          ),
          child: _buildSitesList(),
        ),
      ),
    );
  }

  Widget _buildSitesList() {
    return BlocBuilder<SitesBloc, SitesState>(
      builder: (context, state) {
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
            if (state is SitesLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.primaryColor,
                ),
              )
            else if (state is SitesSuccess)
              ...state.sites.map((site) => BlocProvider(
                create: (context) => getIt<SiteLogsBloc>()..add(SiteLogsFetched(siteId: site.id)),
                child: SiteCard(siteData: site),
              ))
            else if (state is SitesFailure)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load sites',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _fetchSites,
                      child: Text(
                        'Retry',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
