// no_params.dart
// 无参数单例

/// 无参数单例对象
class NoParams {
  const NoParams._();

  /// 单例实例
  static const instance = NoParams._();
}

/// 便利常量
const NoParams noParams = NoParams.instance;
