import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/view_model/patient_model.dart';

class PatientApi {
  final Dio _dio = Dio();

  Future<List<Patient>> getAllPatients(String token) async {
    try {
      final response = await _dio.get(
        'http://127.0.0.1:8000/api/patients/all/1',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final List<dynamic> data = response.data['data']['patients'];
      return data.map((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching patients: $e');
      return [];
    }
  }
}
