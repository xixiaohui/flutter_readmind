// failure.dart
// 失败类层次结构

/// 失败基类
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/// 服务器失败
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// 缓存失败
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// 网络失败
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// 数据库失败
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

/// 验证失败
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(
    super.message, {
    super.code,
    this.fieldErrors,
  });
}

/// 未授权失败
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code});
}

/// 未找到失败
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

/// 导入失败
class ImportFailure extends Failure {
  const ImportFailure(super.message, {super.code});
}

/// 解析失败
class ParseFailure extends Failure {
  const ParseFailure(super.message, {super.code});
}

/// 分享失败
class ShareFailure extends Failure {
  const ShareFailure(super.message, {super.code});
}

/// 购买失败
class PurchaseFailure extends Failure {
  const PurchaseFailure(super.message, {super.code});
}
