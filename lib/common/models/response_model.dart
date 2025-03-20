class ResponseModel {
  final ResponseType type;
  final String message;

  ResponseModel({
    required this.type,
    required this.message,
  });
}

enum ResponseType {
  success,
  error,
}
