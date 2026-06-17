// notes_controller.dart
// Notes Controller (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/shared/domain/repositories/note_repository.dart';

/// 笔记状态
class NotesState {
  final bool isLoading;
  final List<NoteData> notes;
  final NoteData? selectedNote;
  final String? errorMessage;

  const NotesState({
    this.isLoading = false,
    this.notes = const [],
    this.selectedNote,
    this.errorMessage,
  });

  NotesState copyWith({
    bool? isLoading,
    List<NoteData>? notes,
    NoteData? selectedNote,
    String? errorMessage,
  }) {
    return NotesState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      selectedNote: selectedNote,
      errorMessage: errorMessage,
    );
  }
}

/// 笔记控制器
class NotesController extends StateNotifier<NotesState> {
  final NoteRepository _repository;

  NotesController(this._repository) : super(const NotesState());

  /// 加载所有笔记
  Future<void> loadAllNotes() async {
    state = state.copyWith(isLoading: true);

    try {
      final notes = await _repository.getAllNotes();
      state = state.copyWith(isLoading: false, notes: notes);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.toString());
    }
  }

  /// 根据高亮加载笔记
  Future<void> loadNoteByHighlightId(int highlightId) async {
    state = state.copyWith(isLoading: true);

    try {
      final note = await _repository.getNoteByHighlightId(highlightId);
      state = state.copyWith(
          isLoading: false, selectedNote: note);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.toString());
    }
  }

  /// 创建笔记
  Future<void> createNote(NoteData note) async {
    try {
      await _repository.insertNote(note);
      final notes = await _repository.getAllNotes();
      state = state.copyWith(notes: notes);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 更新笔记
  Future<void> updateNote(NoteData note) async {
    try {
      await _repository.updateNote(note);
      final notes = await _repository.getAllNotes();
      state = state.copyWith(notes: notes);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 删除笔记
  Future<void> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
      final notes = await _repository.getAllNotes();
      state = state.copyWith(notes: notes);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

/// Notes Controller Provider
final notesControllerProvider =
    StateNotifierProvider<NotesController, NotesState>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return NotesController(repository);
});

/// 所有笔记 Provider
final allNotesProvider = FutureProvider<List<NoteData>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getAllNotes();
});
