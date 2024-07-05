import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/features/admin/data/doc_list_model.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class DoctorService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://127.0.0.1:8000';

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final response = await _dio.get('${Config.baseUrl}/doctors/all');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['doctors'];
        return data.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch doctors');
      }
    } catch (e) {
      throw Exception('Failed to fetch doctors: $e');
    }
  }
}

/*import 'package:dio/dio.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';

class DoctorRepository {
  static final Dio _dio = Dio();
  

  static Future<List<Doctor>> fetchDoctors() async {
    try {
      final response = await _dio
          .get('http://127.0.0.1:8000/api/patients/all/1');// /api/patients/all/1   //http://127.0.0.1:8000/api/doctors/all
      final List<dynamic> data = response.data['data']['doctors'];
      return data.map((json) => Doctor.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to load doctors: $error');
    }
  }
}*/

/*import 'package:dio/dio.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';

class DoctorRepository {
  static final Dio _dio = Dio();

  static Future<List<Doctor>> fetchDoctors() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8000/api/doctors/all');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> doctorDataList = responseData['data']['doctors']; // Access the 'doctors' key
        return doctorDataList.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}*/
/*import 'package:dio/dio.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';

class DoctorRepository {
  static final Dio _dio = Dio();

  static Future<List<Doctor>> fetchDoctors() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8000/api/doctors/all');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> doctorDataList = responseData['data']['doctors']; // Access the 'doctors' key
        return doctorDataList.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}*/
/*import 'dart:convert';

import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorRepository {
  static List<Doctor> doctors = [];

  static Future<void> addDoctor(Doctor doctor) async {
    doctors.add(doctor);
    await _saveDoctorsToPrefs();
  }

  static List<Doctor> getDoctors() {
    return doctors;
  }

  static Future<void> removeDoctor(Doctor doctor) async {
    doctors.remove(doctor);
    await _saveDoctorsToPrefs();
  }

  static Future<void> _saveDoctorsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> doctorsJson =
        doctors.map((doc) => json.encode(doc.toMap())).toList();
    prefs.setStringList('doctors', doctorsJson);
  }

  static Future<void> loadDoctorsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? doctorsJson = prefs.getStringList('doctors');

    if (doctorsJson != null) {
      doctors =
          doctorsJson.map((doc) => Doctor.fromMap(json.decode(doc))).toList();
    }
  }
}*/
