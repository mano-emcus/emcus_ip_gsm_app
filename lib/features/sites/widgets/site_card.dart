import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_state.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:emcus_ipgsm_app/features/sites/sites_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SiteCard extends StatefulWidget {
  const SiteCard({super.key, required this.siteData, this.isTappable});
  final SiteData siteData;
  final bool? isTappable;

  @override
  State<SiteCard> createState() => _SiteCardState();
}

class _SiteCardState extends State<SiteCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (widget.isTappable ?? true) ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SitesScreen(siteData: widget.siteData),
          ),
        );
      } : null,
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
                      widget.siteData.siteName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (widget.isTappable ?? true),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.siteData.siteLocation,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.textColor,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.siteData.company,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.textColor,
                      ),
                    ),
                  ),
                  if (widget.siteData.users.isNotEmpty) ...[
                    Expanded(
                      child: Text(
                        'Users: ${widget.siteData.users.length}',
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
              (widget.isTappable ?? true) ? BlocBuilder<SiteLogsBloc, SiteLogsState>(
                builder: (context, state) {
                  if (state is SiteLogsLoading) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Fire: ...',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.textColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Fault: ...',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.textColor,
                            ),
                          ),
                        ),
                        if (widget.siteData.users.isNotEmpty) ...[
                          Expanded(
                            child: Text(
                              'All Events: ...',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.textColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                  if (state is SiteLogsSuccess) {
                    return Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Fire: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.textColor,
                                  ),
                                ),
                                TextSpan(
                                  text: state.logs[0].fireCount.toString(),
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
                                  text:
                                      'Fault: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.textColor,
                                  ),
                                ),
                                TextSpan(
                                  text: state.logs[0].faultCount.toString(),
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
                                  text:
                                      'All Events: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.textColor,
                                  ),
                                ),
                                TextSpan(
                                  text: state.logs[0].allCount.toString(),
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
                    );
                  }
                  return const SizedBox.shrink();
                },
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
