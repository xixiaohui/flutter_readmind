// failure_test.dart
// Failure 类单元测试

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_readmind/core/errors/failure.dart';
import 'package:flutter_readmind/core/errors/error_handler.dart';

void main() {
  group('Failure', () {
    test('ServerFailure creates correctly', () {
      const failure = ServerFailure('Server error', code: '500');
      expect(failure.message, 'Server error');
      expect(failure.code, '500');
      expect(failure.toString(), contains('Server error'));
    });

    test('ValidationFailure creates correctly', () {
      const failure = ValidationFailure(
        'Invalid input',
        fieldErrors: {'name': 'Required'},
      );
      expect(failure.message, 'Invalid input');
      expect(failure.fieldErrors, {'name': 'Required'});
    });

    test('NetworkFailure creates correctly', () {
      const failure = NetworkFailure('No internet');
      expect(failure.message, 'No internet');
    });

    test('DatabaseFailure creates correctly', () {
      const failure = DatabaseFailure('DB write failed');
      expect(failure.message, 'DB write failed');
    });

    test('ImportFailure creates correctly', () {
      const failure = ImportFailure('Parse error');
      expect(failure.message, 'Parse error');
    });

    test('ParseFailure creates correctly', () {
      const failure = ParseFailure('Malformed file');
      expect(failure.message, 'Malformed file');
    });

    test('NotFoundFailure creates correctly', () {
      const failure = NotFoundFailure('Book not found');
      expect(failure.message, 'Book not found');
    });

    test('ShareFailure creates correctly', () {
      const failure = ShareFailure('Share failed');
      expect(failure.message, 'Share failed');
    });
  });

  group('ErrorHandler', () {
    test('handles FormatException as ValidationFailure', () {
      final failure = ErrorHandler.handleException(
        const FormatException('Bad format'),
      );
      expect(failure, isA<ValidationFailure>());
    });

    test('handles TypeError as ValidationFailure', () {
      final failure = ErrorHandler.handleException(
        TypeError(),
      );
      expect(failure, isA<ValidationFailure>());
    });

    test('getUserFriendlyMessage for NetworkFailure', () {
      const failure = NetworkFailure('No connection');
      final msg = ErrorHandler.getUserFriendlyMessage(failure);
      expect(msg, contains('网络'));
    });

    test('getUserFriendlyMessage for DatabaseFailure', () {
      const failure = DatabaseFailure('Write error');
      final msg = ErrorHandler.getUserFriendlyMessage(failure);
      expect(msg, contains('数据库'));
    });

    test('getUserFriendlyMessage for ImportFailure', () {
      const failure = ImportFailure('Corrupt file');
      final msg = ErrorHandler.getUserFriendlyMessage(failure);
      expect(msg, contains('导入失败'));
    });

    test('getUserFriendlyMessage for ValidationFailure', () {
      const failure = ValidationFailure('Missing field');
      final msg = ErrorHandler.getUserFriendlyMessage(failure);
      expect(msg, 'Missing field');
    });
  });
}
