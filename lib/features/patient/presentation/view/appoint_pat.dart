import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class AppointmentScreen extends StatefulWidget {
  final int patientId;
  final String token;

  AppointmentScreen({required this.patientId, required this.token});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> appointmentData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final String apiUrl =
        '${Config.baseUrl}/appointments/patient_appointment/${widget.patientId}';
    try {
      final Response response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      setState(() {
        appointmentData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No appointment found';
        _isLoading = false;
      });
    }
  }

  Widget _buildAppointmentDetail(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal[200]!, Colors.greenAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAppointmentDetail(
                                  'Doctor Name',
                                  appointmentData['doctor_name'] ?? 'N/A',
                                  FontAwesomeIcons.userMd,
                                ),
                                Divider(color: Colors.white54),
                                _buildAppointmentDetail(
                                  'Patient Name',
                                  appointmentData['patient_name'] ?? 'N/A',
                                  FontAwesomeIcons.user,
                                ),
                                Divider(color: Colors.white54),
                                _buildAppointmentDetail(
                                  'Refollow Date',
                                  appointmentData['refollow_date'] ?? 'N/A',
                                  FontAwesomeIcons.calendarAlt,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  final int patientId;
  final String token;

  AppointmentScreen({required this.patientId, required this.token});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> appointmentData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/appointments/patient_appointment/${widget.patientId}';
    try {
      final Response response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      setState(() {
        appointmentData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No appointment found';
        _isLoading = false;
      });
    }
  }

  Widget _buildAppointmentDetail(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal[200]!, Colors.greenAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAppointmentDetail(
                                  'Doctor Name',
                                  appointmentData['doctor_name'] ?? 'N/A',
                                  FontAwesomeIcons.userMd,
                                ),
                                Divider(color: Colors.white54),
                                _buildAppointmentDetail(
                                  'Patient Name',
                                  appointmentData['patient_name'] ?? 'N/A',
                                  FontAwesomeIcons.user,
                                ),
                                Divider(color: Colors.white54),
                                _buildAppointmentDetail(
                                  'Refollow Date',
                                  appointmentData['refollow_dates'] ?? 'N/A',
                                  FontAwesomeIcons.calendarAlt,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AppointmentScreen extends StatefulWidget {
  final int patientId;
  final String token;

  AppointmentScreen({required this.patientId, required this.token});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> appointmentData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/appointments/patient_appointment/${widget.patientId}';
    try {
      final Response response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      setState(() {
        appointmentData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No appointment found';
        _isLoading = false;
      });
    }
  }

  Widget _buildAppointmentDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.greenAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAppointmentDetail('Doctor Name',
                                  appointmentData['doctor_name']),
                              Divider(color: Colors.white54),
                              _buildAppointmentDetail('Patient Name',
                                  appointmentData['patient_name']),
                              Divider(color: Colors.white54),
                              _buildAppointmentDetail('Refollow Date',
                                  appointmentData['refollow_dates']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AppointmentScreen extends StatefulWidget {
  final int patientId;
  final String token;

  AppointmentScreen({required this.patientId, required this.token});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> appointmentData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/appointments/patient_appointment/${widget.patientId}';
    try {
      final Response response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      setState(() {
        appointmentData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load appointment details';
        _isLoading = false;
      });
    }
  }

  Widget _buildAppointmentDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildAppointmentDetail(
                          'Doctor Name', appointmentData['doctor_name']),
                      _buildAppointmentDetail(
                          'Patient Name', appointmentData['patient_name']),
                      _buildAppointmentDetail(
                          'Refollow Date', appointmentData['refollow_dates']),
                    ],
                  ),
                ),
    );
  }
}*/
