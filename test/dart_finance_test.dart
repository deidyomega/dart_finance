import 'package:dart_finance/dart_finance.dart' as finance;
import 'package:test/test.dart';

void main() {
  group('Internal Rate of Return - ', () {
    test('Simple Test', () {
      expect(finance.internal_rate_of_return([0, 0, 0, 0, 110000.0], 100000.0, 0), 1.9245);
    });

    test('Simple Test - Zero Investment', () {
      expect(finance.internal_rate_of_return([-100000.0, 0, 0, 0, 0, 110000.0], 0, 0), 1.9245);
    });
  });
}
