
import 'package:dartz/dartz.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}

extension StringExtension on String {
  String get capitalize =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  double priceToDouble() {
    var onlyDigits = replaceAll(RegExp('[^0-9]'), '');
    return double.parse(onlyDigits) / 100;
  }
  }