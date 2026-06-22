// poster_controller.dart
// Poster Controller (Riverpod)

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/poster.dart';
import '../../domain/repositories/poster_repository.dart';

/// 海报状态
class PosterState {
  final Poster? currentPoster;
  final PosterTemplate selectedTemplate;
  final PosterRatio selectedRatio;
  final List<Poster> history;
  final bool isLoading;
  final String? fontFamily;

  const PosterState({
    this.currentPoster,
    this.selectedTemplate = PosterTemplate.minimal,
    this.selectedRatio = PosterRatio.square,
    this.history = const [],
    this.isLoading = false,
    this.fontFamily,
  });

  PosterState copyWith({
    Poster? currentPoster,
    PosterTemplate? selectedTemplate,
    PosterRatio? selectedRatio,
    List<Poster>? history,
    bool? isLoading,
    String? fontFamily,
    bool clearFontFamily = false,
  }) {
    return PosterState(
      currentPoster: currentPoster ?? this.currentPoster,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      fontFamily: clearFontFamily ? null : (fontFamily ?? this.fontFamily),
    );
  }
}

/// 海报控制器
class PosterController extends StateNotifier<PosterState> {
  final PosterRepository _repository;
  String? _editingId;

  PosterController(this._repository) : super(const PosterState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    state = state.copyWith(isLoading: true);
    try {
      final posters = await _repository.getAllPosters();
      state = state.copyWith(isLoading: false, history: posters);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void createPoster({
    required int highlightId,
    required String quoteText,
    String? bookTitle,
    String? author,
  }) {
    _editingId = null;
    final poster = Poster.create(
      highlightId: highlightId,
      quoteText: quoteText,
      bookTitle: bookTitle,
      author: author,
      template: state.selectedTemplate,
      ratio: state.selectedRatio,
    );
    state = state.copyWith(currentPoster: poster);
  }

  void setTemplate(PosterTemplate template) {
    state = state.copyWith(selectedTemplate: template);
    if (state.currentPoster != null) {
      state = state.copyWith(
        currentPoster: Poster.create(
          highlightId: state.currentPoster!.highlightId,
          quoteText: state.currentPoster!.quoteText,
          bookTitle: state.currentPoster!.bookTitle,
          author: state.currentPoster!.author,
          template: template,
          ratio: state.currentPoster!.ratio,
        ),
      );
    }
  }

  void setFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
  }

  void setBookTitle(String title) {
    if (state.currentPoster == null) return;
    state = state.copyWith(
      currentPoster: Poster.create(
        highlightId: state.currentPoster!.highlightId,
        quoteText: state.currentPoster!.quoteText,
        bookTitle: title,
        author: state.currentPoster!.author,
        template: state.currentPoster!.template,
        ratio: state.currentPoster!.ratio,
      ),
    );
  }

  void setAuthor(String author) {
    if (state.currentPoster == null) return;
    state = state.copyWith(
      currentPoster: Poster.create(
        highlightId: state.currentPoster!.highlightId,
        quoteText: state.currentPoster!.quoteText,
        bookTitle: state.currentPoster!.bookTitle,
        author: author,
        template: state.currentPoster!.template,
        ratio: state.currentPoster!.ratio,
      ),
    );
  }

  void setRatio(PosterRatio ratio) {
    state = state.copyWith(selectedRatio: ratio);
    if (state.currentPoster != null) {
      state = state.copyWith(
        currentPoster: Poster.create(
          highlightId: state.currentPoster!.highlightId,
          quoteText: state.currentPoster!.quoteText,
          bookTitle: state.currentPoster!.bookTitle,
          author: state.currentPoster!.author,
          template: state.currentPoster!.template,
          ratio: ratio,
        ),
      );
    }
  }

  void clearEditor() {
    _editingId = null;
    state = state.copyWith(currentPoster: null, clearFontFamily: true);
  }

  void editPoster(Poster poster) {
    _editingId = poster.id;
    state = state.copyWith(
      currentPoster: poster,
      selectedTemplate: poster.template,
      selectedRatio: poster.ratio,
    );
  }

  /// 保存海报到数据库（传入 repaintKey 捕获固定像素截图）
  Future<void> savePoster({GlobalKey? repaintKey}) async {
    if (state.currentPoster == null) return;

    try {
      String? imagePath;
      if (repaintKey != null) {
        final boundary = repaintKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
        if (boundary != null) {
          try {
            final image = await boundary.toImage(pixelRatio: 1.0);
            final byteData =
                await image.toByteData(format: ui.ImageByteFormat.png);
            if (byteData != null) {
              imagePath = await _saveBytes(byteData.buffer.asUint8List());
            }
            image.dispose();
          } catch (_) {}
        }
      }

      if (_editingId != null) {
        await _repository.deletePoster(_editingId!);
      }

      final poster = state.currentPoster!.copyWith(imagePath: imagePath);
      await _repository.savePoster(poster);
      await _loadHistory();
    } finally {
      _editingId = null;
      state = state.copyWith(currentPoster: null);
    }
  }

  Future<String> _saveBytes(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = 'poster_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> sharePoster(Poster poster) async {
    if (poster.imagePath != null) {
      final file = File(poster.imagePath!);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: '"${poster.quoteText}" — ${poster.bookTitle ?? ""}',
        );
        return;
      }
    }
    await Share.share(
      '"${poster.quoteText}" — ${poster.bookTitle ?? "ReadMind"}',
    );
  }

  Future<void> saveToGallery(Poster poster) async {
    if (poster.imagePath != null) {
      final file = File(poster.imagePath!);
      if (await file.exists()) {
        try {
          await Gal.putImage(file.path);
          return;
        } catch (_) {}
      }
    }
    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final name = 'poster_gallery_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$name');
      if (poster.imagePath != null) {
        final src = File(poster.imagePath!);
        if (await src.exists()) {
          await src.copy(file.path);
        }
      }
      if (await file.exists()) {
        await Gal.putImage(file.path);
      }
    } catch (_) {
      await sharePoster(poster);
    }
  }

  Future<void> removeFromHistory(String id) async {
    try {
      await _repository.deletePoster(id);
      await _loadHistory();
    } catch (_) {
      state = state.copyWith(
        history: state.history.where((p) => p.id != id).toList(),
      );
    }
  }
}

final posterControllerProvider =
    StateNotifierProvider<PosterController, PosterState>((ref) {
  final repository = ref.watch(posterRepositoryProvider);
  return PosterController(repository);
});

final allPostersStreamProvider = StreamProvider<List<Poster>>((ref) {
  final repository = ref.watch(posterRepositoryProvider);
  return repository.watchAllPosters();
});
