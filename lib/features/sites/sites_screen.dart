import 'package:emcus_ipgsm_app/features/notes/views/notes_screen.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_event.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:emcus_ipgsm_app/features/sites/views/all_devices_screen.dart';
import 'package:emcus_ipgsm_app/features/sites/views/site_dashboard_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key, required this.siteData});
  final SiteData siteData;

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  int _selectedIndex = 0;
  SiteLogsBloc? _siteLogsBloc;
  SiteNotesBloc? _siteNotesBloc;
  SiteDevicesBloc? _siteDevicesBloc;

  List<Widget> get _screens => [
    SiteDashboardScreen(siteId: widget.siteData.id),
    AllDevicesScreen(siteId: widget.siteData.id,),
    SiteNotesScreen(siteId: widget.siteData.id,),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _siteLogsBloc = context.read<SiteLogsBloc>();
    _siteNotesBloc = context.read<SiteNotesBloc>();
    _siteLogsBloc = context.read<SiteLogsBloc>();
    _fetchSiteLogs();
    _fetchSiteNotes();
    _fetchSiteDevices();
    super.initState();
  }

  void _fetchSiteLogs() {
    _siteLogsBloc?.add(SiteLogsFetched(siteId: widget.siteData.id));
  }

  void _fetchSiteNotes() {
    _siteNotesBloc?.add(SiteNotesFetched(siteId: widget.siteData.id));
  }

  void _fetchSiteDevices() {
    _siteDevicesBloc?.add(SiteDevicesFetched(siteId: widget.siteData.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSiteAppBar(),
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/dashboard_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0
                        ? ColorConstants.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.memory,
                  size: 24,
                  color: _selectedIndex == 1 ? ColorConstants.primaryColor : Colors.grey[600],
                ),
                label: 'Devices',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgs/notes_icon.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 2
                        ? ColorConstants.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Notes',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: ColorConstants.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            backgroundColor: ColorConstants.whiteColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildSiteAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorConstants.textColor,
        ),
      ),
      centerTitle: true,
      title: Text(
        widget.siteData.siteName,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorConstants.primaryColor,
        ),
      ),
      backgroundColor: ColorConstants.whiteColor,
    );
  }
}
