import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Add this line to use Font Awesome icons
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class PatientReportScreen extends StatefulWidget {
  final int patientId;
  final String token;

  PatientReportScreen({required this.patientId, required this.token});

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> reportData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchPatientReport();
  }

  Future<void> fetchPatientReport() async {
    final String apiUrl =
        '${Config.baseUrl}/report/patient_report/${widget.patientId}';
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
        reportData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No Report';
        _isLoading = false;
      });
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Patient Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildReportItem('Patient Name', reportData['patient_name']),
                _buildReportItem('Doctor Name', reportData['doctor_name']),
                _buildReportItem('Diagnosis', reportData['diagnosis']),
                _buildReportItem('Date', reportData['date']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Print'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIconForLabel(label),
            color: Colors.black54,
          ),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Patient Name':
        return Icons.person;
      case 'Doctor Name':
        return Icons.medical_services;
      case 'Diagnosis':
        return FontAwesomeIcons.stethoscope; // Pulmonary related icon
      case 'Date':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8F6F3),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff39D2C0), Color(0xffE8F6F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
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
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Report',
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
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReportItem(
                                    'Patient Name', reportData['patient_name']),
                                _buildReportItem(
                                    'Doctor Name', reportData['doctor_name']),
                                _buildReportItem(
                                    'Diagnosis', reportData['diagnosis']),
                                _buildReportItem('Date', reportData['date']),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24)),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff39D2C0)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: _showReportDialog,
                            icon: Icon(Icons.print, color: Colors.white),
                            label: Text(
                              'Print Report',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientReportScreen extends StatefulWidget {
  final int patientId;
  final String token;

  PatientReportScreen({required this.patientId, required this.token});

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> reportData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchPatientReport();
  }

  Future<void> fetchPatientReport() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/report/patient_report/${widget.patientId}';
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
        reportData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No Report';
        _isLoading = false;
      });
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Patient Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildReportItem('Patient Name', reportData['patient_name']),
                _buildReportItem('Doctor Name', reportData['doctor_name']),
                _buildReportItem('Diagnosis', reportData['diagnosis']),
                _buildReportItem('Date', reportData['date']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Print'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
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
      backgroundColor: Color(0xffE8F6F3),
      appBar: AppBar(
        title: Text('Patient Report'),
        backgroundColor: Color(0xff39D2C0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff39D2C0), Color(0xffE8F6F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
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
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Report',
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
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReportItem(
                                    'Patient Name', reportData['patient_name']),
                                _buildReportItem(
                                    'Doctor Name', reportData['doctor_name']),
                                _buildReportItem(
                                    'Diagnosis', reportData['diagnosis']),
                                _buildReportItem('Date', reportData['date']),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24)),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff39D2C0)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: _showReportDialog,
                            icon: Icon(Icons.print, color: Colors.white),
                            label: Text(
                              'Print Report',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientReportScreen extends StatefulWidget {
  final int patientId;
  final String token;

  PatientReportScreen({required this.patientId, required this.token});

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> reportData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchPatientReport();
  }

  Future<void> fetchPatientReport() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/report/patient_report/${widget.patientId}';
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
        reportData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No Report';
        _isLoading = false;
      });
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Patient Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildReportItem('Patient Name', reportData['patient_name']),
                _buildReportItem('Doctor Name', reportData['doctor_name']),
                _buildReportItem('Diagnosis', reportData['diagnosis']),
                _buildReportItem('Date', reportData['date']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Print'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff39D2C0), Color(0xffE8F6F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Report',
                          style: TextStyle(
                            fontSize: 24,
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
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReportItem(
                                    'Patient Name', reportData['patient_name']),
                                _buildReportItem(
                                    'Doctor Name', reportData['doctor_name']),
                                _buildReportItem(
                                    'Diagnosis', reportData['diagnosis']),
                                _buildReportItem('Date', reportData['date']),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24)),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff39D2C0)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: _showReportDialog,
                            child: Text(
                              'Print Report',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientReportScreen extends StatefulWidget {
  final int patientId;
  final String token;

  PatientReportScreen({required this.patientId, required this.token});

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> reportData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchPatientReport();
  }

  Future<void> fetchPatientReport() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/report/patient_report/${widget.patientId}';
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
        reportData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No Report';
        _isLoading = false;
      });
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildReportItem('Patient Name', reportData['patient_name']),
                _buildReportItem('Doctor Name', reportData['doctor_name']),
                _buildReportItem('Diagnosis', reportData['diagnosis']),
                _buildReportItem('Date', reportData['date']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Print'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportItem(String label, String value) {
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
                      Text(
                        'Patient Report',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildReportItem(
                          'Patient Name', reportData['patient_name']),
                      _buildReportItem(
                          'Doctor Name', reportData['doctor_name']),
                      _buildReportItem('Diagnosis', reportData['diagnosis']),
                      _buildReportItem('Date', reportData['date']),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff39D2C0)),
                        ),
                        onPressed: _showReportDialog,
                        child: Text('Print Report'),
                      ),
                    ],
                  ),
                ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientReportScreen extends StatefulWidget {
  final int patientId;
  final String token;

  PatientReportScreen({required this.patientId, required this.token});

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  late Dio _dio;
  bool _isLoading = true;
  Map<String, dynamic> reportData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchPatientReport();
  }

  Future<void> fetchPatientReport() async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/report/patient_report/${widget.patientId}';
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
        reportData = response.data['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch report';
        _isLoading = false;
      });
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Patient Name: ${reportData['patient_name']}'),
                Text('Doctor Name: ${reportData['doctor_name']}'),
                Text('Diagnosis: ${reportData['diagnosis']}'),
                Text('Date: ${reportData['date']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Print'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                      Text(
                        'Patient Name: ${reportData['patient_name']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Doctor Name: ${reportData['doctor_name']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Diagnosis: ${reportData['diagnosis']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date: ${reportData['date']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: _showReportDialog,
                        child: Text(
                          'Print Report',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}*/
