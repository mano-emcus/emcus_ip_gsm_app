import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_event.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();
    _notesBloc = NotesBloc();
    _notesBloc.add(NotesFetched());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesBloc.close();
    super.dispose();
  }

  void _showAddNoteBottomSheet(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: ColorConstants.greyColor.withValues(alpha: 0.3),
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
                      // Note input field
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorConstants.textFieldBorderColor.withValues(alpha: 0.3),
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
                      ),
                      const SizedBox(height: 20),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (noteController.text.trim().isNotEmpty) {
                              // TODO: Implement note submission logic
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Note saved successfully!'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter some content for your note'),
                                  backgroundColor: Colors.orange,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.primaryColor,
                            foregroundColor: ColorConstants.whiteColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Submit to Cloud',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
    return BlocProvider(
      create: (context) => _notesBloc,
      child: Scaffold(
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
                            _notesBloc.add(NotesFetched());
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
                child: BlocListener<NotesBloc, NotesState>(
                  listener: (context, state) {
                    if (state is NotesFailure) {
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
                    }
                  },
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (state is NotesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is NotesSuccess) {
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

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            final note = state.notes[index];
                            return GestureDetector(
                              onTap: () {
                                GenericYetToImplementPopUpWidget.show(
                                  context,
                                  title: 'Note Details',
                                  message: 'Note details view is coming soon!',
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: ColorConstants.textFieldBorderColor
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.noteTitle,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstants.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      note.noteContent,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.greyColor,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'By: ${note.username}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstants.greyColor,
                                              ),
                                            ),
                                            Text(
                                              'Created: ${note.createdAt}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstants.greyColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            GenericYetToImplementPopUpWidget.show(
                                              context,
                                              title: 'Note Options',
                                              message:
                                                  'Note options menu is coming soon!',
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.more_vert,
                                            size: 20,
                                          ),
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
                        );
                      } else if (state is NotesFailure) {
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
                                  _notesBloc.add(NotesFetched());
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
            bottom: 80,
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
      ),
    );
  }
}
