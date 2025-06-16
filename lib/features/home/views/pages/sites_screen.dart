import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key});

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sites',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.blackColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      GenericYetToImplementPopUpWidget.show(
                        context,
                        title: 'Site Settings',
                        message: 'Site management settings are coming soon!',
                      );
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sites...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.greyColor,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onTap: () {
                    GenericYetToImplementPopUpWidget.show(
                      context,
                      title: 'Search Sites',
                      message: 'Site search functionality is coming soon!',
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Sites List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      GenericYetToImplementPopUpWidget.show(
                        context,
                        title: 'Site Details',
                        message: 'Site details view is coming soon!',
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorConstants.textFieldBorderColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Site ${index + 1}',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstants.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '123 Main Street, City ${index + 1}',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStatusChip('Active', Colors.green),
                              const SizedBox(width: 8),
                              _buildStatusChip('${(index + 1) * 2} Devices', Colors.blue),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.greyColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  GenericYetToImplementPopUpWidget.show(
                                    context,
                                    title: 'Site Options',
                                    message: 'Site management options are coming soon!',
                                  );
                                },
                                icon: const Icon(Icons.more_vert, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GenericYetToImplementPopUpWidget.show(
            context,
            title: 'Add New Site',
            message: 'Add new site feature is coming soon!',
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}