abstract class Failure {}

class ServerFailure extends Failure {}

class NetworkFailure extends Failure {}

class ParsingFailure extends Failure {}

class UnknownFailure extends Failure {}

abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ParsingException extends AppException {
  ParsingException(super.message);
}

class ConnectionException extends AppException {
  ConnectionException(super.message);
}

class BadRequestException extends AppException {
  BadRequestException(super.message);
}

class UnknownException extends AppException {
  UnknownException(super.message);
}

