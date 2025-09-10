class ErrorModel {
  final String message;
  final int code;

  ErrorModel({
    required this.message,
    required this.code,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    return ErrorModel(
      message: map['message'] ?? '',
      code: map['code'] ?? '',
    );
  }
  @override
  String toString() {
    return 'ErrorModel(message: $message, code: $code)';
  }
}
