class BasicResponse<T> {
  final bool success;
  final String message;
  final T? data;

  BasicResponse({required this.success, required this.message, this.data});

  factory BasicResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BasicResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
