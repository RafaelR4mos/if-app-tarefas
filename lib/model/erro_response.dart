class ErroResponse {
  final int status;
  final String error;
  final String message;
  final int timestamp;

  ErroResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.timestamp,
  });

  factory ErroResponse.fromJson(Map<String, dynamic> json) {
    return ErroResponse(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}
