// error_handler.dart
// 错误处理器

import 'failure.dart';

/// 错误处理工具
class ErrorHandler {
  /// 将异常转换为 Failure
  static Failure handleException(Object exception) {
    if (exception is FormatException) {
      return const ValidationFailure('数据格式错误');
    }

    if (exception is TypeError) {
      return const ValidationFailure('数据类型错误');
    }

    // 默认返回未知错误
    return ValidationFailure('未知错误: ${exception.toString()}');
  }

  /// 获取用户友好的错误消息
  static String getUserFriendlyMessage(Failure failure) {
    if (failure is ValidationFailure) {
      return failure.message;
    }

    if (failure is NetworkFailure) {
      return '网络连接失败，请检查网络设置';
    }

    if (failure is DatabaseFailure) {
      return '数据库操作失败';
    }

    if (failure is ImportFailure) {
      return '导入失败: ${failure.message}';
    }

    if (failure is ParseFailure) {
      return '解析失败: ${failure.message}';
    }

    if (failure is ShareFailure) {
      return '分享失败: ${failure.message}';
    }

    if (failure is PurchaseFailure) {
      return '购买失败: ${failure.message}';
    }

    return failure.message;
  }
}
