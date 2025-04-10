import 'base_exception.dart';

class HttpException extends AppException {
  final int statusCode;

  const HttpException(
    String message, {
    required this.statusCode,
  }) : super(message);

  @override
  String toString() => 'HTTP Error $statusCode: $message';
}
