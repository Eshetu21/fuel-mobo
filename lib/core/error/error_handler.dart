import 'dart:io';

import 'package:flutter/services.dart';

class SkException implements Exception {
  final String message;

  const SkException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends SkException {
  NetworkException()
    : super('Please ensure that you are connected to the internet');
}

SkException errorHandler(dynamic e) {
  if (e is SkException) {
    return e;
  } else if (e is SocketException) {
    return NetworkException();
  } else if (e is PlatformException) {
    if (e.code == "network_error") {
      return NetworkException();
    } else {
      return SkException(e.message ?? "An unexpected error occurred");
    }
  } else if (e is TypeError ||
      e is ArgumentError ||
      e is RangeError ||
      e is FormatException ||
      e is UnsupportedError) {
    return const SkException("Something went wrong. Please try again.");
  }

  return const SkException("An unknown error occurred");
}

