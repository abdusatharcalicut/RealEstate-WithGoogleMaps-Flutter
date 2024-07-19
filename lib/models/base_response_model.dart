class ResponseValidationModel {
  ResponseValidationModel({
    this.error,
  });

  ResponseErrorModel? error;

  factory ResponseValidationModel.fromJson(Map<String, dynamic>? json) =>
      ResponseValidationModel(
        error: ResponseErrorModel.fromJson(json?["error"]),
      );
}

class ResponseErrorModel {
  ResponseErrorModel({
    this.message,
  });

  String? message;

  factory ResponseErrorModel.fromJson(Map<String, dynamic>? json) =>
      ResponseErrorModel(
        message: json?["message"],
      );
}
