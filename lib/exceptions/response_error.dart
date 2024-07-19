class ResponseError implements Exception {
  ResponseError({required this.message});

  String? message;
}
