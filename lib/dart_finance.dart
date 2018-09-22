/// Support for doing something awesome.
///
/// More dartdocs go here.
library dart_finance;
import 'dart:math';

/// Rounder with specified percision
/// 
/// ```dart
/// round(5.3) == 5
/// round(5.3444, 2) == 5.34
/// ``` 
num round(num number, [num ndigit = 0]) {
  if (ndigit == 0) return number.round();

  int dig = pow(10, ndigit);
  return ((number * dig).round() / dig);
}

/// Calculates Percent of Change
/// 
/// To calculate the percentage increase: First: work out the difference (increase) between the two numbers you are comparing. Then: divide the increase by the original number and multiply the answer by 100. If your answer is a negative number then this is a percentage decrease.
num percent_of_change(num num1, num num2) => ((num2 - num1) / num1) * 100;

num net_present_value(List<num> flow, num investment, num irr) {
  num pv;
  int i;
  num divisor;
  int length = flow.length;

  pv = 0.0;
  for (i = 0; i < length; i++) {
    divisor = pow((1.0 + irr), (i + 1));
    pv = pv + (flow[i] / divisor);
  }
  return pv - investment;
}

/// Increments the rate, to make the npv ~= 0 (which is what IRR is)
num _pos_irr_calc(List<num> flow, num investment, num start, num increment) {
  num irr;
  num npv;

  for (irr = start; irr < 1.0; irr += increment) {
    npv = net_present_value(flow, investment, irr);
    if (npv < 0) {
      break;
    }
  }
  irr -= increment;
  return irr;
}

/// Increments the rate, to make the npv ~= 0 (which is what IRR is)
num _neg_irr_calc(List<num> flow, num investment, num start, num increment) {
  num irr;
  num npv;

  for (irr = start; irr > -1.0; irr += increment) {
    npv = net_present_value(flow, investment, irr);
    if (npv > 0) {
      break;
    }
  }
  irr -= increment;
  return irr;
}

num monthly_internal_rate_of_return() {
  throw "NOT IMPLEMENTED";
}

/// Calculates Internal Rate of Return
/// 
/// The internal rate of return is a method of calculating rate of return. The term internal refers to the fact that its calculation does not involve external factors, such as inflation or the cost of capital. It is also called the discounted cash flow rate of return.
/// 
/// Takes the cashflow, the initial investment (as a positive number), and a guess for the irr, use 0.0 if you are unsure.
/// 
/// ```dart
/// internal_rate_of_return([0, 0, 0, 0, 110000.0], 100000.0, 0) == 1.9245
/// ```
num internal_rate_of_return(List<num> flow, num investment, num guess) {
  num irr = guess;
  num increment;
  Function irr_calc;

  if (net_present_value(flow, investment, irr) >
      net_present_value(flow, investment, irr + 1.1)) {
    increment = 1;
    irr_calc = _pos_irr_calc;
  } else {
    increment = -1;
    irr_calc = _neg_irr_calc;
  }

  // max for iterations is 18
  for (int x = 0; x < 10; x += 1) {
    increment /= 10;
    irr = irr_calc(flow, investment, irr, increment);
  }

  irr += increment;
  irr *= 100;
  return round(irr, 4);
}