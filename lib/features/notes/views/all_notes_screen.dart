import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/logs/widgets/logs_card.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_event.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_state.dart';
import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';
import 'package:emcus_ipgsm_app/features/notes/views/notes_screen.dart';
import 'package:emcus_ipgsm_app/features/notes/widgets/note_card.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_state.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_event.dart';

enum NoteFilter { all, issue, info, general }

class AllNotesScreen extends StatefulWidget {
  const AllNotesScreen({super.key});

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {
  NoteFilter selectedFilter = NoteFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  NotesBloc? _notesBloc;
  SiteNotesBloc? _siteNotesBloc;
  SitesBloc? _sitesBloc;
  late NoteCategory selectedCategory;

  @override
  void initState() {
    super.initState();
    _initializeBlocs();
    _fetchData();
    selectedCategory = NoteCategory.generalNotes;
  }

  void _initializeBlocs() {
    _notesBloc = context.read<NotesBloc>();
    _siteNotesBloc = context.read<SiteNotesBloc>();
    _sitesBloc = context.read<SitesBloc>();
  }

  void _fetchData() {
    _fetchNotes();
    _fetchSites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchNotes() {
    _notesBloc?.add(NotesFetched());
  }

  void _fetchSites() {
    _sitesBloc?.add(SitesFetched());
  }

  List<NoteEntry> _filterNotes(List<NoteEntry> notes) {
    List<NoteEntry> filteredNotes = notes;

    // Apply filter based on selected type
    switch (selectedFilter) {
      case NoteFilter.issue:
        filteredNotes =
            notes
                .where((note) => note.noteTag == NoteCategory.issueNotes)
                .toList();
        break;
      case NoteFilter.info:
        filteredNotes =
            notes
                .where((note) => note.noteTag == NoteCategory.infoNotes)
                .toList();
        break;
      case NoteFilter.general:
        filteredNotes =
            notes
                .where((note) => note.noteTag == NoteCategory.generalNotes)
                .toList();
        break;
      case NoteFilter.all:
        filteredNotes = notes;
        break;
    }

    return filteredNotes;
  }

  void _handleAuthenticationError() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder:
            (context, animation, secondaryAnimation) => const SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -0.15),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load Notes: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _isAuthenticationError(String error) {
    return error.contains('AuthenticationException') ||
        error.contains('No valid authentication token') ||
        error.contains('Missing Authorization header');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;

    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesFailure) {
          if (_isAuthenticationError(state.error)) {
            _handleAuthenticationError();
          } else {
            _showErrorSnackBar(state.error);
          }
        }
      },
      child: Scaffold(
        backgroundColor: customColors.themeBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildHeader(customColors),
                const SizedBox(height: 16),
                _buildFilterChips(customColors),
                const SizedBox(height: 16),
                Expanded(child: _buildNotesList()),
                const SizedBox(height: 16),
                _buildAddNoteButton(customColors),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CustomColors customColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: customColors.themeTextPrimary,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                color: customColors.themeTextSecondary,
              ),
            ),
            IconButton(
              onPressed: () => _showFilterModal(context),
              icon: Icon(
                Icons.filter_list_outlined,
                color: customColors.themeTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChips(CustomColors customColors) {
    return Row(
      children: [
        _buildFilterChip('All', NoteFilter.all, customColors),
        const SizedBox(width: 12),
        _buildFilterChip('Issue', NoteFilter.issue, customColors),
        const SizedBox(width: 12),
        _buildFilterChip('Info', NoteFilter.info, customColors),
        const SizedBox(width: 12),
        _buildFilterChip('General', NoteFilter.general, customColors),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    NoteFilter filter,
    CustomColors customColors,
  ) {
    final bool isSelected = selectedFilter == filter;
    final Color backgroundColor =
        isSelected
            ? customColors.primaryColor.withValues(alpha: 0.2)
            : customColors.themeTextFieldBackgroud;
    final Color textColor =
        isSelected ? customColors.primaryColor : customColors.themeTextPrimary;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorConstants.primaryColor,
            ),
          );
        } else if (state is NotesSuccess) {
          final filteredNotes = _filterNotes(state.notes);

          if (filteredNotes.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchNotes(),
            color: ColorConstants.primaryColor,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filteredNotes.length,
              itemBuilder:
                  (context, index) => _buildNoteCard(filteredNotes[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          );
        } else if (state is LogsFailure) {
          return _buildErrorState();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    final String message = _getEmptyStateMessage();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty ? Icons.search_off : Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery.isNotEmpty) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _clearSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  foregroundColor: ColorConstants.whiteColor,
                ),
                child: Text(
                  'Clear Search',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEmptyStateMessage() {
    final String baseMessage =
        searchQuery.isNotEmpty ? 'found for "$searchQuery"' : 'found';

    switch (selectedFilter) {
      case NoteFilter.issue:
        return searchQuery.isNotEmpty
            ? 'No issue notes $baseMessage'
            : 'No issue notes found';
      case NoteFilter.info:
        return searchQuery.isNotEmpty
            ? 'No info notes $baseMessage'
            : 'No info notes found';
      case NoteFilter.general:
        return searchQuery.isNotEmpty
            ? 'No general notes $baseMessage'
            : 'No general notes found';
      case NoteFilter.all:
        return searchQuery.isNotEmpty
            ? 'No notes $baseMessage'
            : 'No notes found';
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchQuery = '';
    });
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Failed to load logs',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchNotes,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                foregroundColor: ColorConstants.whiteColor,
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(NoteEntry note) {
    return NotesCard(note: note);
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorConstants.greyColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ColorConstants.textColor,
          ),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterModalContent(),
    );
  }

  Widget _buildFilterModalContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Options',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorConstants.textColor,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.sort, color: ColorConstants.primaryColor),
            title: Text(
              'Sort by Date (Newest First)',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Currently active',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: ColorConstants.greyColor,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: ColorConstants.primaryColor,
            ),
            title: Text(
              'About Filters',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Use the filter chips above to filter by log type',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: ColorConstants.greyColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                foregroundColor: ColorConstants.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNoteButton(CustomColors customColors) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => _showAddNoteBottomSheet(context),
        icon: const Icon(Icons.add, size: 24, color: Colors.white),
        label: Text(
          'Add Note',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53E3E),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    int? selectedSiteId; // No default site ID, initially null

    selectedCategory = NoteCategory.generalNotes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => _buildAddNoteModalContent(
                  titleController,
                  noteController,
                  selectedSiteId,
                  setModalState,
                  (newSiteId) => selectedSiteId = newSiteId,
                ),
          ),
    );
  }

  Widget _buildAddNoteModalContent(
    TextEditingController titleController,
    TextEditingController noteController,
    int? selectedSiteId,
    StateSetter setModalState,
    Function(int) onSiteIdChanged,
  ) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: customColors.themeSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModalHeader(),
            const SizedBox(height: 18),
            _buildTitleField(titleController),
            const SizedBox(height: 20),
            _buildDescriptionField(noteController),
            const SizedBox(height: 20),
            _buildTagSection(setModalState),
            const SizedBox(height: 20),
            _buildSiteDropdown(selectedSiteId, setModalState, onSiteIdChanged),
            const Spacer(),
            _buildSaveButton(titleController, noteController, selectedSiteId),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add New Note',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: customColors.themeTextPrimary,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: customColors.themeTextSecondary),
        ),
      ],
    );
  }

  Widget _buildTitleField(TextEditingController titleController) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: customColors.themeTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: customColors.themeTextFieldBackgroud,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: titleController,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: customColors.themeTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Enter note title',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: customColors.themeTextSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(TextEditingController noteController) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: customColors.themeTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: customColors.themeTextFieldBackgroud,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: noteController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: customColors.themeTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Enter note description',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: customColors.themeTextSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagSection(StateSetter setModalState) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Tag',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: customColors.themeTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTagChip(
              'General',
              NoteCategory.generalNotes,
              Colors.green,
              selectedCategory,
              setModalState,
            ),
            const SizedBox(width: 8),
            _buildTagChip(
              'Issue',
              NoteCategory.issueNotes,
              Colors.red,
              selectedCategory,
              setModalState,
            ),
            const SizedBox(width: 8),
            _buildTagChip(
              'Info',
              NoteCategory.infoNotes,
              Colors.blue,
              selectedCategory,
              setModalState,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSiteDropdown(
    int? selectedSiteId,
    StateSetter setModalState,
    Function(int) onSiteIdChanged,
  ) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Site',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: customColors.themeTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<SitesBloc, SitesState>(
          builder: (context, sitesState) {
            if (sitesState is SitesSuccess) {
              return _buildSiteDropdownSuccess(
                sitesState.sites,
                selectedSiteId,
                setModalState,
                onSiteIdChanged,
              );
            } else if (sitesState is SitesLoading) {
              return _buildSiteDropdownLoading();
            } else {
              return _buildSiteDropdownError();
            }
          },
        ),
      ],
    );
  }

  Widget _buildSiteDropdownSuccess(
    List<SiteData> sites,
    int? selectedSiteId,
    StateSetter setModalState,
    Function(int) onSiteIdChanged,
  ) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: customColors.themeTextFieldBackgroud,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedSiteId,
          dropdownColor: customColors.themeTextFieldBackgroud,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: customColors.themeTextPrimary,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: customColors.themeTextSecondary,
          ),
          hint: Text(
            'Select site',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: customColors.themeTextSecondary,
            ),
          ),
          onChanged: (int? newValue) {
            if (newValue != null) {
              setModalState(() {
                onSiteIdChanged(newValue);
              });
            }
          },
          items:
              sites.map<DropdownMenuItem<int>>((SiteData site) {
                return DropdownMenuItem<int>(
                  value: site.id,
                  child: Text(
                    site.siteName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: customColors.themeTextPrimary,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildSiteDropdownLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Loading sites...',
        style: GoogleFonts.inter(color: Colors.white54),
      ),
    );
  }

  Widget _buildSiteDropdownError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'No sites available',
        style: GoogleFonts.inter(color: Colors.white54),
      ),
    );
  }

  Widget _buildSaveButton(
    TextEditingController titleController,
    TextEditingController noteController,
    int? selectedSiteId,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            () => _handleSaveNote(
              titleController,
              noteController,
              selectedSiteId,
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53E3E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Save Note',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handleSaveNote(
    TextEditingController titleController,
    TextEditingController noteController,
    int? selectedSiteId,
  ) {
    final title = titleController.text.trim();
    final content = noteController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showValidationError('Please fill in both title and description');
      return;
    }

    if (selectedSiteId == null) {
      _showValidationError('Please select a site');
      return;
    }

    _siteNotesBloc!.add(
      SiteNoteCreated(
        siteId: selectedSiteId,
        noteTitle: title,
        noteContent: content,
        category: _getCategoryString(selectedCategory),
      ),
    );
    Navigator.pop(context);
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _getCategoryString(NoteCategory category) {
    switch (category) {
      case NoteCategory.generalNotes:
        return 'general';
      case NoteCategory.infoNotes:
        return 'info';
      case NoteCategory.issueNotes:
        return 'issue';
    }
  }

  Widget _buildTagChip(
    String label,
    NoteCategory category,
    Color color,
    NoteCategory selectedCategory,
    StateSetter setModalState,
  ) {
    final bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          this.selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
