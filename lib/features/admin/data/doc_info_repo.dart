import 'package:dio/dio.dart';
import 'doc_inf_class.dart'; // Adjust the path as necessary
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl =
      '${Config.baseUrl}'; // Replace with your API base URL

  Future<Doctor> fetchDoctorInfo(int doctorId, String token) async {
    try {
      // Set up Dio instance with headers
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // Make GET request
      final response = await _dio.get('${Config.baseUrl}/doctors/$doctorId/show');

      // Handle success case
      if (response.statusCode == 200) {
        return Doctor.fromJson(response.data['data']['doctor']);
      } else {
        // Handle other HTTP status codes
        print('Failed to fetch doctor info: ${response.statusCode}');
        return null!;
      }
    } catch (e) {
      // Handle Dio errors
      print('Error fetching doctor info: $e');
      return null!;
    }
  }
}
