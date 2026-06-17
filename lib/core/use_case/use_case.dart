// use_case.dart
// Use Case 基础抽象类

/// Use Case 基础抽象类
///
/// T: 返回类型
/// P: 参数类型
abstract class UseCase<T, P> {
  /// 执行 use case
  Future<T> call(P params);
}

/// 无参数的 Use Case
abstract class NoParamsUseCase<T> {
  /// 执行 use case（无参数）
  Future<T> call();
}
