import 'base_exception.dart';

class HttpException extends AppException {
  final int statusCode;

  const HttpException(super.message, {required this.statusCode});

  @override
  String toString() => 'HTTP Error $statusCode: $message';
}
