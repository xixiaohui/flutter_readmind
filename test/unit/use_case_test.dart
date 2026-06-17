// use_case_test.dart
// Use Case 单元测试

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_readmind/core/use_case/use_case.dart';
import 'package:flutter_readmind/core/use_case/no_params.dart';

/// 测试用 UseCase 实现
class _TestUseCase implements UseCase<String, String> {
  @override
  Future<String> call(String params) async {
    return 'Result: $params';
  }
}

class _FailingUseCase implements UseCase<String, String> {
  @override
  Future<String> call(String params) async {
    throw Exception('Test error');
  }
}

void main() {
  group('UseCase', () {
    test('executes successfully', () async {
      final useCase = _TestUseCase();
      final result = await useCase.call('input');
      expect(result, 'Result: input');
    });

    test('throws error', () async {
      final useCase = _FailingUseCase();
      expect(() => useCase.call('test'), throwsException);
    });
  });

  group('NoParams', () {
    test('instance is accessible', () {
      expect(noParams, isNotNull);
    });
  });
}
