import 'package:dart_finance/dart_finance.dart' as finance;

main() {
  finance.internal_rate_of_return([0, 0, 0, 0, 110000.0], 100000.0, 0) == 1.9245;
}
