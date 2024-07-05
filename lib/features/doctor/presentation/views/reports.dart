import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class DoctorReportScreen extends StatefulWidget {
  final int doctorId;
  final String token;

  DoctorReportScreen({
    required this.doctorId,
    required this.token,
  });

  @override
  _DoctorReportScreenState createState() => _DoctorReportScreenState();
}

class _DoctorReportScreenState extends State<DoctorReportScreen> {
  late Future<Map<String, dynamic>> _futureReport;

  @override
  void initState() {
    super.initState();
    _futureReport = _fetchReport();
  }

  Future<Map<String, dynamic>> _fetchReport() async {
    final String apiUrl =
        '${Config.baseUrl}/report/doctor_report/${widget.doctorId}';
    try {
      final Response response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
          validateStatus: (status) {
            return true; // Accept all status codes for handling them in the catch block
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        print('Error response: ${response.data}');
        throw Exception('Failed to load report: ${response.statusMessage}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load report: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureReport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load report: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No report available'));
          } else {
            final reportData = snapshot.data!;
            final doctorName = reportData['doctor_name'];
            final patients = reportData['patients'] as List<dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor: $doctorName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: patients.isEmpty
                        ? Center(
                            child: Text('No patients found',
                                style: TextStyle(fontSize: 18)))
                        : ListView.builder(
                            itemCount: patients.length,
                            itemBuilder: (context, index) {
                              final patient = patients[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: Colors.teal, size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            patient['patient_name'] ??
                                                'Unknown',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal[900],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.badge,
                                              color: Colors.teal, size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            'ID: ${patient['patient_id']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.medical_services,
                                              color: Colors.teal, size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            'Diagnosis: ${patient['diagnosis']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.date_range,
                                              color: Colors.teal, size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            'Date: ${patient['date']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
