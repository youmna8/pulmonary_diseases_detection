import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/add_patients.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';
class UploadAudioScreen extends StatefulWidget {
  final String doctorId;
  final String token;

  UploadAudioScreen({required this.doctorId, required this.token});

  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  File? _selectedFile;
  final Dio _dio = Dio();
  final String _apiUrl = '${Config.baseUrl}/report/store_result';
  late final String _patientsApiUrl;
  List<dynamic> _patients = [];
  dynamic _selectedPatient;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _patientsApiUrl = '${Config.baseUrl}/patients/all/${widget.doctorId}';
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await _dio.get(
        _patientsApiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _patients = response.data['data']['patients'];
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      // Handle errors here
    }
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedFile = File(file.path!);
      });
    }
  }

  Future<void> _uploadAudio() async {
    if (_selectedFile == null || _selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an audio file and choose a patient'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        'audio_path': await MultipartFile.fromFile(
          _selectedFile!.path,
          filename: 'audio_file',
        ),
        'patient_id': _selectedPatient['id'].toString(),
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload audio'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _navigateToAddPatientScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPatientScreen(
          token: widget.token,
          doctorId: widget.doctorId,
        ),
      ),
    );
    _fetchPatients(); // Refresh the patient list after adding a new patient
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(
        children: [
          Positioned(
            top: -40,
            child: Image.asset(
              'assets/images/logo_make_11_06_2023_412.jpg',
              height: 350,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 300),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              width: double.infinity,
              height: 400,
              child: Padding(
                padding: EdgeInsets.only(left: 50, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _selectAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: _selectedFile != null
                            ? Icon(Icons.check)
                            : Text(
                                'Select Audio',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      value: _selectedPatient,
                      items: [
                        ..._patients.map((patient) {
                          return DropdownMenuItem(
                            value: patient,
                            child: Text(patient['fullName']),
                          );
                        }).toList(),
                        DropdownMenuItem(
                          value: 'add_patient',
                          child: Text('Add Patient'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == 'add_patient') {
                          _navigateToAddPatientScreen();
                        } else {
                          setState(() {
                            _selectedPatient = value;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Patient',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _uploadAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff39D2C0),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isUploading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Upload',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:testttt/features/doctor/presentation/views/add_patients.dart';
import 'package:testttt/core/commons/commons.dart';

class UploadAudioScreen extends StatefulWidget {
  final String doctorId;
  final String token;

  UploadAudioScreen({required this.doctorId, required this.token});

  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  final Dio _dio = Dio();
  final String _apiUrl = '${Config.baseUrl}/report/store_result';
  late final String _patientsApiUrl;
  List<dynamic> _patients = [];
  dynamic _selectedPatient;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _patientsApiUrl =
        '${Config.baseUrl}/patients/all/${widget.doctorId}';
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await _dio.get(
        _patientsApiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _patients = response.data['data']['patients'];
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {}
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      if (_audioBytes == null || _selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and choose a patient'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': _selectedPatient['id'].toString(),
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _navigateToAddPatientScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              AddPatientScreen(token: widget.token, doctorId: widget.doctorId)),
    );
    _fetchPatients(); // Refresh the patient list after adding a new patient
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(children: [
        Positioned(
          top: -40,
          child: Image.asset(
            'assets/images/logo_make_11_06_2023_412.jpg',
            height: 350,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _selectAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.check)
                          : Text(
                              'Select Audio',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    value: _selectedPatient,
                    items: [
                      ..._patients.map((patient) {
                        return DropdownMenuItem(
                          value: patient,
                          child: Text(patient['fullName']),
                        );
                      }).toList(),
                      DropdownMenuItem(
                        value: 'add_patient',
                        child: Text('Add Patient'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'add_patient') {
                        _navigateToAddPatientScreen();
                      } else {
                        setState(() {
                          _selectedPatient = value;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Patient',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff39D2C0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUploading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Upload',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}*/

/*import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:proj_app/features/doctor/presentation/views/add_patients.dart';

class UploadAudioScreen extends StatefulWidget {
  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/store_result';
  final String _patientsApiUrl = 'http://127.0.0.1:8000/api/patients/all/1';
  final String _token = 'YOUR_BEARER_TOKEN';
  List<dynamic> _patients = [];
  dynamic _selectedPatient;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await _dio.get(
        _patientsApiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _patients = response.data['data']['patients'];
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      if (_audioBytes == null || _selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and choose a patient'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': _selectedPatient['id'].toString(),
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _navigateToAddPatientScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddPatientScreen(token: _token)),
    );
    _fetchPatients(); // Refresh the patient list after adding a new patient
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(children: [
        Positioned(
          top: -40,
          child: Image.asset(
            'assets/images/logo_make_11_06_2023_412.jpg',
            height: 350,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _selectAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.check)
                          : Text(
                              'Select Audio',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    value: _selectedPatient,
                    items: [
                      ..._patients.map((patient) {
                        return DropdownMenuItem(
                          value: patient,
                          child: Text(patient['fullName']),
                        );
                      }).toList(),
                      DropdownMenuItem(
                        value: 'add_patient',
                        child: Text('Add Patient'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'add_patient') {
                        _navigateToAddPatientScreen();
                      } else {
                        setState(() {
                          _selectedPatient = value;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Patient',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff39D2C0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUploading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Upload',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}*/

/*import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioScreen extends StatefulWidget {
  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/store_result';
  final String _patientsApiUrl = 'http://127.0.0.1:8000/api/patients/all/1';
  final String _token = 'YOUR_BEARER_TOKEN';
  List<dynamic> _patients = [];
  dynamic _selectedPatient;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await _dio.get(
        _patientsApiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _patients = response.data['data']['patients'];
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      if (_audioBytes == null || _selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and choose a patient'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': _selectedPatient['id'].toString(),
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(children: [
        Positioned(
          top: -40,
          child: Image.asset(
            'assets/images/logo_make_11_06_2023_412.jpg',
            height: 350,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _selectAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.check)
                          : Text(
                              'Select Audio',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    value: _selectedPatient,
                    items: _patients.map((patient) {
                      return DropdownMenuItem(
                        value: patient,
                        child: Text(patient['fullName']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPatient = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Patient',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff39D2C0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUploading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Upload',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}*/

/*import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioScreen extends StatefulWidget {
  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/store_result';
  final String _patientsApiUrl = 'http://127.0.0.1:8000/api/patients/all/1';
  final String _token = 'YOUR_BEARER_TOKEN';
  List<dynamic> _patients = [];
  dynamic _selectedPatient;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await _dio.get(
        _patientsApiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _patients = response.data['data']['patients'];
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      if (_audioBytes == null || _selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and choose a patient'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': _selectedPatient['id'].toString(),
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(children: [
        Positioned(
          top: -40,
          child: Image.asset(
            'assets/images/logo_make_11_06_2023_412.jpg',
            height: 350,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _selectAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.check)
                          : Text(
                              'Select Audio',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    value: _selectedPatient,
                    items: _patients.map((patient) {
                      return DropdownMenuItem(
                        value: patient,
                        child: Text(patient['fullName']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPatient = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Patient',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff39D2C0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.cloud_upload)
                          : Text(
                              'Upload',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}*/

/*import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioScreen extends StatefulWidget {
  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  late TextEditingController _patientIdController;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/store_result';
  final String _token = 'YOUR_BEARER_TOKEN';

  @override
  void initState() {
    super.initState();
    _patientIdController = TextEditingController();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      String patientId = _patientIdController.text;

      if (_audioBytes == null || patientId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and enter patient ID'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': patientId,
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(children: [
        Positioned(
          top: -40,
          child: Image.asset(
            'assets/images/logo_make_11_06_2023_412.jpg',
            height: 350,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _selectAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.check)
                          : Text(
                              'Select Audio',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16)),
                    child: TextFormField(
                      controller: _patientIdController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                        labelText: 'Patient ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff39D2C0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.cloud_upload)
                          : Text(
                              'Upload',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}*/
