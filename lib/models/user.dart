class User {
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobile: json['mobile'],
    );
  }
}
