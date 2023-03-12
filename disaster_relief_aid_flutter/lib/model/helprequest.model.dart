class HelpRequest {
  final String message;
  final String uid;
  final String distance;
  final double longitude;
  final double latitude;
  HelpRequest(
      {required this.message,
      required this.uid,
      required this.distance,
      required this.longitude,
      required this.latitude});
}
