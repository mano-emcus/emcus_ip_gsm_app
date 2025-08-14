import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogsCard extends StatefulWidget {
  const LogsCard({super.key, required this.log});

  final LogEntry log;

  @override
  State<LogsCard> createState() => _LogsCardState();
}

String _getLogTypeIcon(LogEntry log) {
  if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
    return 'assets/svgs/fire_icon.svg';
  } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
    return 'assets/svgs/fault_icon.svg';
  } else {
    return 'assets/svgs/general_icon.svg';
  }
}

class _LogsCardState extends State<LogsCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: customColors.themeSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(_getLogTypeIcon(widget.log)),
                Text('data'),
              ],
            ),
            Text('data'),
            Text('data'),
            Text('data'),
            Text('data'),
          ],
        ),
      ),
    );
  }
}
