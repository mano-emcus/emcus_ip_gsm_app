import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';
import 'package:emcus_ipgsm_app/features/notes/views/notes_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotesCard extends StatefulWidget {
  const NotesCard({super.key, required this.note});

  final NoteEntry note;

  @override
  State<NotesCard> createState() => _NotesCardState();
}

String _getNoteTypeText(NoteEntry note) {
  if (note.noteTag == NoteCategory.issueNotes) {
    return 'Issue';
  } else if (note.noteTag == NoteCategory.infoNotes) {
    return 'Info';
  } else {
    return 'General';
  }
}

String _getNoteTypeIcon(NoteEntry note) {
  if (note.noteTag == NoteCategory.issueNotes) {
    return 'assets/svgs/fire_icon.svg';
  } else if (note.noteTag == NoteCategory.infoNotes) {
    return 'assets/svgs/fault_icon.svg';
  } else {
    return 'assets/svgs/general_icon.svg';
  }
}

String _getNoteTitle(NoteEntry note) {
  if (note.noteTag == NoteCategory.issueNotes) {
    return 'Issue Note';
  } else if (note.noteTag == NoteCategory.infoNotes) {
    return 'Info Note';
  } else {
    return 'General Note';
  }
}

String _getLogDescription(
  LogEntry log,
  String deviceText,
  String zoneNumber,
  String sourceType,
  String deviceAddress,
) {
  if (log.u16EventId >= 1001 && log.u16EventId <= 1007) {
    return 'Fire Detected at $deviceText in Zone $zoneNumber from $sourceType $deviceAddress';
  } else if (log.u16EventId >= 2000 && log.u16EventId < 3000) {
    return 'System Fault at $deviceText in Zone $zoneNumber from $sourceType $deviceAddress';
  } else {
    return 'General Update at $deviceText in Zone $zoneNumber from $sourceType $deviceAddress';
  }
}

String _formatLogDate(NoteEntry note) {
  try {
    final now = DateTime.now();
    final noteDate = DateTime.parse(note.createdAt);

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final noteDateOnly = DateTime(noteDate.year, noteDate.month, noteDate.day);

    final timeString =
        '${noteDate.hour.toString().padLeft(2, '0')}:${noteDate.minute.toString().padLeft(2, '0')}';

    if (noteDateOnly == today) {
      return 'Today, $timeString';
    } else if (noteDateOnly == yesterday) {
      return 'Yesterday, $timeString';
    } else {
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final monthName = monthNames[noteDate.month - 1];
      return '$monthName ${noteDate.day}, $timeString';
    }
  } catch (e) {
    // Fallback to original value if parsing fails
    return note.createdAt;
  }
}

Color _getNoteTypeColor(NoteEntry note) {
  if (note.noteTag == NoteCategory.issueNotes) {
    return ColorConstants.fireTitleTextColor;
  } else if (note.noteTag == NoteCategory.infoNotes) {
    return ColorConstants.faultTitleTextColor;
  } else {
    return ColorConstants.allEventsTitleTextColor;
  }
}

Color _getNoteTypeBackgroundColor(NoteEntry note) {
  if (note.noteTag == NoteCategory.issueNotes) {
    return ColorConstants.fireTitleBackGroundColor;
  } else if (note.noteTag == NoteCategory.infoNotes) {
    return ColorConstants.faultTitleBackGroundColor;
  } else {
    return ColorConstants.allEventsTitleBackGroundColor;
  }
}

class _NotesCardState extends State<NotesCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: customColors.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: _getNoteTypeColor(widget.note), // Use corresponding color
            width: 4, // Adjust width as needed for thickness
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(_getNoteTypeIcon(widget.note)),
                const SizedBox(width: 8),
                Text(
                  widget.note.noteTitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: customColors.themeTextPrimary,
                  ),
                ),
                Spacer(),
                Text(
                  _formatLogDate(widget.note),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: customColors.themeTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.note.noteContent,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: customColors.themeTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Author: ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: customColors.themeTextSecondary,
                      ),
                    ),
                    Text(
                      widget.note.username,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: customColors.themeTextSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getNoteTypeBackgroundColor(widget.note),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getNoteTypeColor(
                        widget.note,
                      ).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getNoteTypeText(widget.note),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getNoteTypeColor(widget.note),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
