import 'package:dio/dio.dart';

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String email;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    required this.email,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
    );
  }
}

