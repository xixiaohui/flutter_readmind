// local_storage_service.dart
// 本地存储服务

import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务接口
abstract class LocalStorageService {
  /// 保存字符串
  Future<bool> saveString(String key, String value);

  /// 获取字符串
  String? getString(String key);

  /// 保存整数
  Future<bool> saveInt(String key, int value);

  /// 获取整数
  int? getInt(String key);

  /// 保存布尔值
  Future<bool> saveBool(String key, bool value);

  /// 获取布尔值
  bool? getBool(String key);

  /// 保存双精度浮点数
  Future<bool> saveDouble(String key, double value);

  /// 获取双精度浮点数
  double? getDouble(String key);

  /// 保存字符串列表
  Future<bool> saveStringList(String key, List<String> value);

  /// 获取字符串列表
  List<String>? getStringList(String key);

  /// 删除指定键
  Future<bool> remove(String key);

  /// 清除所有数据
  Future<bool> clear();

  /// 检查是否包含指定键
  bool containsKey(String key);
}

/// 本地存储服务实现
class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageServiceImpl(this._prefs);

  @override
  Future<bool> saveString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> saveDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  @override
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  Future<bool> saveStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  @override
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return _prefs.clear();
  }

  @override
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
