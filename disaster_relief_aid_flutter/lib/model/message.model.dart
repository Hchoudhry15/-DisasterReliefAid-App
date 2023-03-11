class Message {
  final String emailFrom;
  final String messageDetails;
  final int timestamp;

  Message(
      {required this.emailFrom,
      required this.messageDetails,
      required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      emailFrom: json['emailFrom'] ?? '',
      messageDetails: json['messageDetails'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }
}
