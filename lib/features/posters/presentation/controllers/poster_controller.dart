// poster_controller.dart
// Poster Controller (Riverpod)

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
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

  const PosterState({
    this.currentPoster,
    this.selectedTemplate = PosterTemplate.minimal,
    this.selectedRatio = PosterRatio.square,
    this.history = const [],
    this.isLoading = false,
  });

  PosterState copyWith({
    Poster? currentPoster,
    PosterTemplate? selectedTemplate,
    PosterRatio? selectedRatio,
    List<Poster>? history,
    bool? isLoading,
  }) {
    return PosterState(
      currentPoster: currentPoster ?? this.currentPoster,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 海报控制器
class PosterController extends StateNotifier<PosterState> {
  final PosterRepository _repository;

  PosterController(this._repository) : super(const PosterState()) {
    _loadHistory();
  }

  /// 从数据库加载海报历史
  Future<void> _loadHistory() async {
    state = state.copyWith(isLoading: true);
    try {
      final posters = await _repository.getAllPosters();
      state = state.copyWith(isLoading: false, history: posters);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 创建新海报
  void createPoster({
    required int highlightId,
    required String quoteText,
    String? bookTitle,
    String? author,
  }) {
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

  /// 设置模板
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

  /// 设置比例
  void setRatio(PosterRatio ratio) {
    state = state.copyWith(selectedRatio: ratio);
  }

  /// 保存海报到数据库（可选传入 ScreenshotController 捕获图片）
  Future<void> savePoster({ScreenshotController? screenshotController}) async {
    if (state.currentPoster == null) return;

    try {
      String? imagePath;
      if (screenshotController != null) {
        final imageBytes = await screenshotController.capture(
          delay: const Duration(milliseconds: 100),
          pixelRatio: 3.0,
        );
        if (imageBytes != null) {
          imagePath = await _saveImageToFile(imageBytes);
        }
      }

      final poster = state.currentPoster!.copyWith(imagePath: imagePath);
      await _repository.savePoster(poster);
      await _loadHistory();
      state = state.copyWith(currentPoster: null);
    } catch (_) {
      try {
        await _repository.savePoster(state.currentPoster!);
        await _loadHistory();
        state = state.copyWith(currentPoster: null);
      } catch (_) {}
    }
  }

  /// 将图片字节保存到文件
  Future<String> _saveImageToFile(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'poster_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// 分享海报
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
    // 无图片时分享文本
    await Share.share(
      '"${poster.quoteText}" — ${poster.bookTitle ?? "ReadMeet Quotes"}',
    );
  }

  /// 保存海报到手机相册
  Future<void> saveToGallery(Poster poster) async {
    if (poster.imagePath != null) {
      final file = File(poster.imagePath!);
      if (await file.exists()) {
        try {
          await Gal.putImage(file.path);
          return;
        } catch (_) {
          // gal 失败时回退到生成新图片
        }
      }
    }
    // 无图片或 gal 失败：生成图片后保存
    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final fileName =
          'poster_gallery_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      // 如果已有 imagePath，复制文件
      if (poster.imagePath != null) {
        final srcFile = File(poster.imagePath!);
        if (await srcFile.exists()) {
          await srcFile.copy(file.path);
        }
      }
      if (await file.exists()) {
        await Gal.putImage(file.path);
      }
    } catch (_) {
      // 最后回退：使用系统分享
      await sharePoster(poster);
    }
  }

  /// 从历史中删除海报
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

/// Poster Controller Provider
final posterControllerProvider =
    StateNotifierProvider<PosterController, PosterState>((ref) {
  final repository = ref.watch(posterRepositoryProvider);
  return PosterController(repository);
});
