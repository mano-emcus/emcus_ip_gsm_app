import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_state.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:emcus_ipgsm_app/features/sites/sites_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SiteCard extends StatefulWidget {
  const SiteCard({super.key, required this.siteData});
  final SiteData siteData;

  @override
  State<SiteCard> createState() => _SiteCardState();
}

class _SiteCardState extends State<SiteCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SitesScreen(siteData: widget.siteData),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: customColors.themeSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: customColors.themeBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.siteData.siteName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: customColors.themeTextPrimary,
                    ),
                  ),
                  BlocBuilder<SiteLogsBloc, SiteLogsState>(
                    builder: (context, state) {
                      if (state is SiteLogsLoading) {
                        return const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        );
                      }
                      if (state is SiteLogsSuccess) {
                        return Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.fireColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.logs[0].faultCount.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: customColors.themeTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.faultColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${state.logs[0].allCount - state.logs[0].fireCount - state.logs[0].faultCount}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: customColors.themeTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.generalColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.logs[0].fireCount.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: customColors.themeTextSecondary,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.siteData.siteLocation,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: customColors.themeTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
