class UserProfile {
  String? userId;
  String? fullName;
  String? userEmail;
  String? phoneNumber;

  UserProfile({
    required this.userId,
    required this.fullName,
    required this.userEmail,
    required this.phoneNumber,
  });

  UserProfile.fromMap(Map<String, dynamic> map) {
    fullName = map['fullName'];
    userId = map['userId'];
    userEmail = map['email'];
    phoneNumber = map['phone'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userId'] = userId;
    data['fullName'] = fullName;
    data['email'] = userEmail;
    data['phone'] = phoneNumber;
    return data;
  }
}
