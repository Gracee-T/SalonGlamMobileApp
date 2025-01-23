class Appointment {
  final String userId;
  final String userName;
  final String userEmail;
  final String reason;
  final DateTime appointmentDateTime;
  final String stylist;
  final String status;
  final String serviceName;
  final double price;

  Appointment({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.reason,
    required this.appointmentDateTime,
    required this.stylist,
    required this.price,
    required this.serviceName,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'reason': reason,
      'appointmentDateTime': appointmentDateTime,
      'stylist': stylist,
      'status': status,
      'price': price,
    };
  }
}
