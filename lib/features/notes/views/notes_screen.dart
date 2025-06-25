import 'package:emcus_ipgsm_app/features/notes/widgets/note_grid_view_widget.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_event.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';

enum NoteCategory { issueNotes, infoNotes, generalNotes }

class SiteNotesScreen extends StatefulWidget {
  const SiteNotesScreen({super.key, required this.siteId});
  final int siteId;

  @override
  State<SiteNotesScreen> createState() => _SiteNotesScreenState();
}

class _SiteNotesScreenState extends State<SiteNotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late NoteCategory selectedCategory;
  SiteNotesBloc? _siteNotesBloc;

  @override
  void initState() {
    super.initState();
    _siteNotesBloc = context.read<SiteNotesBloc>();
    _fetchNotes();
    selectedCategory = NoteCategory.generalNotes;
  }

  void _fetchNotes() {
    _siteNotesBloc?.add(SiteNotesFetched(siteId: widget.siteId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddNoteBottomSheet(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    selectedCategory = NoteCategory.generalNotes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.85,
                      ),
                      child: IntrinsicHeight(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: ColorConstants.whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Handle bar
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: ColorConstants.greyColor
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Title
                                Text(
                                  'Add Note',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Title input field
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.textFieldBorderColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorConstants.textFieldBorderColor
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter note title...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.greyColor,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstants.blackColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Note input field
                                Container(
                                  height:
                                      300, // Set specific height for the text field
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.textFieldBorderColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorConstants.textFieldBorderColor
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: noteController,
                                    maxLines: null,
                                    expands: true,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      hintText: 'Write your note here...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.greyColor,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.blackColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Submit button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: ColorConstants.whiteColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              width: 2,
                                              color: ColorConstants.blackColor
                                                  .withValues(alpha: 0.2),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 17,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<
                                                NoteCategory
                                              >(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                value: selectedCategory,
                                                dropdownColor:
                                                    ColorConstants.whiteColor,
                                                isExpanded: true,
                                                icon: SvgPicture.asset(
                                                  'assets/svgs/dropdown_icon.svg',
                                                ),
                                                onChanged: (
                                                  NoteCategory? newValue,
                                                ) {
                                                  if (newValue != null) {
                                                    setModalState(() {
                                                      selectedCategory =
                                                          newValue;
                                                    });
                                                  }
                                                },
                                                items: [
                                                  DropdownMenuItem<
                                                    NoteCategory
                                                  >(
                                                    value:
                                                        NoteCategory
                                                            .generalNotes,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 14,
                                                          height: 14,
                                                          decoration:
                                                              const BoxDecoration(
                                                                color:
                                                                    ColorConstants
                                                                        .generalNotesBackGroundColor,
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'General Notes',
                                                          style: GoogleFonts.inter(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                ColorConstants
                                                                    .textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DropdownMenuItem<
                                                    NoteCategory
                                                  >(
                                                    value:
                                                        NoteCategory.infoNotes,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 14,
                                                          height: 14,
                                                          decoration:
                                                              const BoxDecoration(
                                                                color:
                                                                    ColorConstants
                                                                        .infoNotesBackGroundColor,
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Info Notes',
                                                          style: GoogleFonts.inter(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                ColorConstants
                                                                    .textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DropdownMenuItem<
                                                    NoteCategory
                                                  >(
                                                    value:
                                                        NoteCategory.issueNotes,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 14,
                                                          height: 14,
                                                          decoration:
                                                              const BoxDecoration(
                                                                color:
                                                                    ColorConstants
                                                                        .issueNotesBackGroundColor,
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Issue Notes',
                                                          style: GoogleFonts.inter(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                ColorConstants
                                                                    .textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            final title =
                                                titleController.text.trim();
                                            final content =
                                                noteController.text.trim();
                                            if (title.isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Please enter a title for your note',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorConstants
                                                              .whiteColor,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      ColorConstants
                                                          .primaryColor,
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            } else if (content.isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Please enter some content for your note',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorConstants
                                                              .whiteColor,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      ColorConstants
                                                          .primaryColor,
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // Trigger note creation
                                              BlocProvider.of<NotesBloc>(
                                                      context)
                                                  .add(
                                                NoteAdded(
                                                  noteTitle: title,
                                                  noteContent: content,
                                                  noteTag: selectedCategory,
                                                ),
                                              );

                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorConstants.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 17,
                                                  ),
                                              child: Center(
                                                child: Text(
                                                  'Submit to Cloud',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        ColorConstants
                                                            .whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ),
    );
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
                    'Notes',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.blackColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _fetchNotes();
                        },
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          GenericYetToImplementPopUpWidget.show(
                            context,
                            title: 'Settings',
                            message: 'Note settings feature is coming soon!',
                          );
                        },
                        icon: const Icon(Icons.settings_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.textFieldBorderColor.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.greyColor,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onTap: () {
                    GenericYetToImplementPopUpWidget.show(
                      context,
                      title: 'Search',
                      message: 'Search functionality is coming soon!',
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Notes List
            Expanded(
              child: BlocListener<SiteNotesBloc, SiteNotesState>(
                listener: (context, state) {
                  if (state is SiteNoteFailure) {
                    // Check if it's an authentication error
                    if (state.error.contains('AuthenticationException') ||
                        state.error.contains(
                          'No valid authentication token',
                        ) ||
                        state.error.contains(
                          'Missing Authorization header',
                        )) {
                      // Authentication failed, redirect to sign-in
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(
                            milliseconds: 600,
                          ),
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
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                        ),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      // Show error message for other failures
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to load notes: ${state.error}',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  } else if (state is SiteNoteCreateSuccess) {
                    // Show success message for note creation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else if (state is SiteNoteCreateFailure) {
                    // Check if it's an authentication error
                    if (state.error.contains('AuthenticationException') ||
                        state.error.contains('Authentication failed')) {
                      // Authentication failed, redirect to sign-in
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(
                            milliseconds: 600,
                          ),
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
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                        ),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      // Show error message for note creation failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to create note: ${state.error}',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
                child: BlocBuilder<SiteNotesBloc, SiteNotesState>(
                  builder: (context, state) {
                    if (state is SiteNoteLoading || state is SiteNoteCreateLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SiteNoteSuccess) {
                      if (state.notes.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_alt_outlined,
                                size: 64,
                                color: ColorConstants.greyColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No notes available',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.greyColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first note by tapping the + button',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.greyColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return NoteGridViewWidget(notes: state.notes);
                    } else if (state is SiteNoteFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load notes',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.error,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.greyColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<NotesBloc>(context).add(
                                  NotesFetched(),
                                );
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text('Welcome to Notes'));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 100,
        ), // Account for bottom nav bar height
        child: FloatingActionButton(
          onPressed: () {
            _showAddNoteBottomSheet(context);
          },
          backgroundColor: ColorConstants.primaryColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: ColorConstants.whiteColor),
        ),
      ),
    );
  }
}
