import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:emcus_ipgsm_app/features/sites/sites_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SiteCard extends StatefulWidget {
  const SiteCard({
    super.key,
    required this.site,
    this.fireCount,
    this.faultCount,
    this.allEventsCount,
  });
  final SiteData site;
  final String? fireCount;
  final String? faultCount;
  final String? allEventsCount;

  @override
  State<SiteCard> createState() => _SiteCardState();
}

class _SiteCardState extends State<SiteCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SitesScreen(siteData: widget.site),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.site.siteName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.site.siteLocation,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.site.company,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.textColor,
                      ),
                    ),
                  ),
                  if (widget.site.users.isNotEmpty) ...[
                    Expanded(
                      child: Text(
                        'Users: ${widget.site.users.length}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fire: ${widget.fireCount}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Fault: ${widget.faultCount}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.textColor,
                      ),
                    ),
                  ),
                  if (widget.site.users.isNotEmpty) ...[
                    Expanded(
                      child: Text(
                        'All Events: ${widget.allEventsCount}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
