class Profile {
  String? email, password;
  DateTime? birthdate;
  List<String>? vulnerabilities;

  Profile({this.email, this.password, this.birthdate, this.vulnerabilities});

  @override
  String toString() {
    return 'Profile{email: $email, password: $password, birthdate: $birthdate, vulnerabilities: $vulnerabilities.toString()}';
  }
}
