// network_info.dart
// 网络信息检测

import 'package:connectivity_plus/connectivity_plus.dart';

/// 网络信息接口
abstract class NetworkInfo {
  /// 检查是否有网络连接
  Future<bool> get isConnected;
}

/// 网络信息实现
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
