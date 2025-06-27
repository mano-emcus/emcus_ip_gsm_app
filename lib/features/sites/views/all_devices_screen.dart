import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_state.dart';
import 'package:emcus_ipgsm_app/features/sites/models/site_devices_response.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllDevicesScreen extends StatefulWidget {
  const AllDevicesScreen({super.key, required this.siteId});
  final int siteId;

  @override
  State<AllDevicesScreen> createState() => _AllDevicesScreenState();
}

class _AllDevicesScreenState extends State<AllDevicesScreen> {
  SiteDevicesBloc? _siteDevicesBloc;

  @override
  void initState() {
    super.initState();
    _siteDevicesBloc = context.read<SiteDevicesBloc>();
    _fetchDevices();
  }

  void _fetchDevices() {
    _siteDevicesBloc?.add(SiteDevicesFetched(siteId: widget.siteId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SiteDevicesBloc, SiteDevicesState>(
      listener: (context, state) {
        if (state is SiteDevicesFailure) {
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
                content: Text('Failed to load devices: ${state.error}'),
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
          child: _buildDevicesList(),
        ),
      ),
    );
  }

  Widget _buildDevicesList() {
    return BlocBuilder<SiteDevicesBloc, SiteDevicesState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Devices',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (state is SiteDevicesLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.primaryColor,
                ),
              )
            else if (state is SiteDevicesSuccess)
              ...state.devices.map((device) => DeviceCard(device: device))
            else if (state is SiteDevicesFailure)
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
                      'Failed to load devices',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _fetchDevices,
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

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device});
  final Gateway device;

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd-MM-yyyy, HH:mm:ss').format(date);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorConstants.textFieldBorderColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _keyValueRow('Gateway ID', device.id.toString()),
            const SizedBox(height: 8),
            _keyValueRow('Serial Number', device.serialNumber),
            const SizedBox(height: 8),
            _keyValueRow('Category', device.category),
            const SizedBox(height: 8),
            _keyValueRow('Company', device.company),
            const SizedBox(height: 8),
            _keyValueRow('Created', _formatDate(device.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _keyValueRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$key: ',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorConstants.primaryColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: ColorConstants.textColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
