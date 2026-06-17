// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ReadMeet Quotes';

  @override
  String get library => 'ライブラリ';

  @override
  String get highlights => 'ハイライト';

  @override
  String get posters => 'ポスター';

  @override
  String get settings => '設定';

  @override
  String get import => 'インポート';

  @override
  String get importBook => '本をインポート';

  @override
  String get selectFile => 'ファイルを選択';

  @override
  String get importing => 'インポート中...';

  @override
  String get importSuccess => 'インポート成功';

  @override
  String get importFailed => 'インポート失敗';

  @override
  String get read => '読む';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get share => 'シェア';

  @override
  String get createHighlight => 'ハイライト作成';

  @override
  String get highlight => 'ハイライト';

  @override
  String get createPoster => 'ポスター作成';

  @override
  String get copy => 'コピー';

  @override
  String get chooseHighlightColor => 'ハイライト色を選択';

  @override
  String get posterAll => '全てポスター化';

  @override
  String get posterPreview => 'ポスタープレビュー';

  @override
  String get posterSaved => 'ポスターを保存しました。ポスタータブで確認してください。';

  @override
  String get selectTextToHighlight => 'テキストを選択してハイライトを作成';

  @override
  String get noPosterToPreview => 'プレビューするポスターがありません';

  @override
  String get template => 'テンプレート';

  @override
  String get ratio => '比率';

  @override
  String get noContent => 'コンテンツなし';

  @override
  String get noContentAvailable => '利用可能なコンテンツがありません';

  @override
  String get decreaseFontSize => 'フォントを小さく';

  @override
  String get increaseFontSize => 'フォントを大きく';

  @override
  String get prevChapter => '前の章';

  @override
  String get nextChapter => '次の章';

  @override
  String get templateMinimal => 'ミニマル';

  @override
  String get templatePaper => 'ペーパー';

  @override
  String get templateDark => 'ダーク';

  @override
  String get templateCover => 'カバー';

  @override
  String postersCreatedCount(int count) =>
      '${count}枚のポスターを作成しました。ポスタータブで確認してください。';

  @override
  String get addNote => 'ノート追加';

  @override
  String get generatePoster => 'ポスター生成';

  @override
  String get noBooks => '本がありません';

  @override
  String get noHighlights => 'ハイライトがありません';

  @override
  String get noPosters => 'ポスターがありません';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get sepiaMode => 'セピアモード';

  @override
  String get lightMode => 'ライトモード';

  @override
  String get theme => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日本語';

  @override
  String get purchase => '購入';

  @override
  String get restorePurchase => '購入復元';

  @override
  String get proVersion => 'プロ版';

  @override
  String get upgradeToPro => 'プロ版にアップグレード';

  @override
  String get search => '検索';

  @override
  String get webDatabaseUnavailable => 'Web版ではデータベースを利用できません。\nすべての機能はネイティブアプリでご利用ください。';
}
