class Doctor {
  final int id;
  final String name;
  final String email;
  final String address;

  Doctor(
      {required this.id,
      required this.name,
      required this.email,
      required this.address});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
    );
  }
}
