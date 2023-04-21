class HttpException implements Exception {
  final dynamic message;
  final dynamic prefix;

  HttpException([this.message, this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends HttpException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends HttpException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends HttpException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends HttpException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class NotFoundException extends HttpException {
  NotFoundException([String? message]) : super(message, "Not Found: ");
}
