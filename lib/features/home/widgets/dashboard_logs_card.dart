import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoardLogsCard extends StatefulWidget {
  const DashBoardLogsCard({
    super.key,
    required this.fireCount,
    required this.faultCount,
    required this.generalCount,
  });
  final int fireCount;
  final int faultCount;
  final int generalCount;

  @override
  State<DashBoardLogsCard> createState() => _DashBoardLogsCardState();
}

class _DashBoardLogsCardState extends State<DashBoardLogsCard> {
  int _touchedIndex = -1;

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      // General alerts section
      PieChartSectionData(
        value: widget.generalCount.toDouble(),
        showTitle: false,
        radius: _touchedIndex == 0 ? 35 : 28,
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E3188), // Using your allEventsTitleBorderColor
            Color(0xFF007AFF), // Lighter shade for gradient
          ],
        ),
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
      // Fault alerts section
      PieChartSectionData(
        value: widget.faultCount.toDouble(),
        showTitle: false,
        radius: _touchedIndex == 1 ? 35 : 28,
        gradient: LinearGradient(
          colors: [
            Color(0xFFE2A41E), // Using your faultTitleBorderColor
            Color(0xFFFFC107), // Lighter shade for gradient
          ],
        ),
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
      // Fire alerts section
      PieChartSectionData(
        value: widget.fireCount.toDouble(),
        showTitle: false,
        radius: _touchedIndex == 2 ? 35 : 28,
        gradient: LinearGradient(
          colors: [
            Color(0xFFE61C1C), // Using your fireTitleBorderColor
            Color(0xFFFF4444), // Lighter shade for gradient
          ],
        ),
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: customColors.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: customColors.themeBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Alert Summary',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: customColors.themeTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shadow/glow effect container
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: customColors.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      // Main pie chart
                      PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          sections: _buildPieChartSections(),
                          centerSpaceRadius: 35,
                          sectionsSpace: 2,
                          pieTouchData: PieTouchData(
                            touchCallback: (
                              FlTouchEvent event,
                              pieTouchResponse,
                            ) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex =
                                    pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                              });
                            },
                          ),
                        ),
                      ),
                      // Center content
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: customColors.themeSurface,
                          border: Border.all(
                            color: customColors.themeBorder.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.generalCount + widget.faultCount + widget.fireCount}',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: customColors.themeTextPrimary,
                                ),
                              ),
                              Text(
                                'Total',
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                  color: customColors.themeTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      widget.fireCount.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color:
                            ColorConstants
                                .fireColor, // Using fireTitleBorderColor
                      ),
                    ),
                    Text(
                      'Fire',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: customColors.themeTextSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.faultCount.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color:
                            ColorConstants
                                .faultColor, // Using faultTitleBorderColor
                      ),
                    ),
                    Text(
                      'Fault',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: customColors.themeTextSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.generalCount.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.generalColor,
                      ),
                    ),
                    Text(
                      'General',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: customColors.themeTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
