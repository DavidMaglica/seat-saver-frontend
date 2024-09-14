class BasicResponse {
  final bool success;
  final String message;

  BasicResponse({required this.success, required this.message});

  factory BasicResponse.fromJson(Map<String, dynamic> json) {
    return BasicResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}
