import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';
import 'package:emcus_ipgsm_app/features/notes/views/notes_screen.dart';
import 'package:emcus_ipgsm_app/features/notes/widgets/note_details_view_bottom_sheet_widget.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteGridViewWidget extends StatelessWidget {
  const NoteGridViewWidget({
    super.key,
    required this.notes,
    this.isHomeScreen = false,
  });
  final List<NoteEntry> notes;
  final bool? isHomeScreen;

  @override
  Widget build(BuildContext context) {
    final reversedNotes = notes.reversed.toList();
    final notesToShow =
        isHomeScreen == true ? reversedNotes.take(3).toList() : reversedNotes;

    return isHomeScreen == true
        ? GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(3, (index) {
            if (index < notesToShow.length) {
              final note = notesToShow[index];
              return GestureDetector(
                onTap: () {
                  _showNoteDetailsBottomSheet(context, note);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorConstants.allEventsTitleBackGroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorConstants.primaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color:
                                  note.noteTag == NoteCategory.generalNotes
                                      ? ColorConstants
                                          .generalNotesBackGroundColor
                                      : note.noteTag == NoteCategory.infoNotes
                                      ? ColorConstants.infoNotesBackGroundColor
                                      : ColorConstants
                                          .issueNotesBackGroundColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              note.noteTitle,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          note.noteContent,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.greyColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'By: ${note.username}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.greyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Empty placeholder container
              return Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'No note',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.greyColor,
                    ),
                  ),
                ),
              );
            }
          }),
        )
        : GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: notesToShow.length,
          itemBuilder: (context, index) {
            final note = notesToShow[index];
            return GestureDetector(
              onTap: () {
                _showNoteDetailsBottomSheet(context, note);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorConstants.allEventsTitleBackGroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorConstants.primaryColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                note.noteTag == NoteCategory.generalNotes
                                    ? ColorConstants.generalNotesBackGroundColor
                                    : note.noteTag == NoteCategory.infoNotes
                                    ? ColorConstants.infoNotesBackGroundColor
                                    : ColorConstants.issueNotesBackGroundColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            note.noteTitle,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        note.noteContent,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.greyColor,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'By: ${note.username}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.greyColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  void _showNoteDetailsBottomSheet(BuildContext context, NoteEntry note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteDetailsViewBottomSheetWidget(note: note),
    );
  }
}
