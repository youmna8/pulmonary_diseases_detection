
class Doctor {
  final int id;
  final String name;
  final String phone;
  final String address;
  final int yearsOfExperience;
  final String? token;
  final String email;
  final String password;
  final String createdAt;
  final String updatedAt;

  Doctor({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.yearsOfExperience,
    required this.token,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      yearsOfExperience: json['years_of_experience'],
      token: json['token'],
      email: json['email'],
      password: json['password'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

/*import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String email;
  final String password;
  final String phone;

  Doctor({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}*/

/*class Doctor {
  String name;
  String specialization;
  dynamic email;
  String phone;
  String password;

  Doctor(
      {required this.name,
      required this.specialization,
      required this.email,
      required this.password,
      required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'email': email,
      'phone': phone,
      'password': password
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      name: map['name'],
      specialization: map['specialization'],
      email: map['email'],
      password: map['email'],
      phone: map['phone'],
    );
  }
}*/
