import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  final String token;
  final int doctorId;

  DoctorAppointmentsScreen({required this.token, required this.doctorId});

  @override
  _DoctorAppointmentsScreenState createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  final Dio _dio = Dio();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Form variables
  TextEditingController _refollowDateController = TextEditingController();
  int? _selectedPatientId;
  List<Patient> _patientList = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _fetchDoctorAppointments();
    _fetchPatientList();
  }

  Future<void> _fetchDoctorAppointments() async {
    setState(() {
      _isLoading = true;
    });

    final String url =
        '${Config.baseUrl}/appointments/doctor_appointments/${widget.doctorId}';

    try {
      final Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> appointmentsJson =
            response.data['data']['refollow_dates'];
        setState(() {
          _appointments = appointmentsJson
              .map((json) => Appointment.fromJson(json))
              .toList();
        });
      } else {
        throw Exception('Failed to load doctor appointments');
      }
    } catch (e) {
      print('Error fetching doctor appointments: $e');
      _showSnackBar('Failed to load doctor appointments');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPatientList() async {
    final String url =
        '${Config.baseUrl}/patients/all/${widget.doctorId}';

    try {
      final Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> patientsJson = response.data['data']['patients'];
        setState(() {
          _patientList =
              patientsJson.map((json) => Patient.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load patient list');
      }
    } catch (e) {
      print('Error fetching patient list: $e');
      _showSnackBar('Failed to load patient list');
    }
  }

  Future<void> _addAppointment() async {
    if (_selectedPatientId == null || _refollowDateController.text.isEmpty) {
      _showSnackBar('Please select a patient and a refollow date');
      return;
    }

    final String url = '${Config.baseUrl}/appointments/store';

    try {
      final Response response = await _dio.post(
        url,
        data: {
          'patient_id': _selectedPatientId,
          'refollow_date': _refollowDateController.text,
          'doc_id': widget.doctorId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        _refollowDateController.clear();
        _selectedPatientId = null;
        _fetchDoctorAppointments(); // Refresh appointments after adding
        _showSnackBar('Appointment Successfully Created', success: true);
      } else {
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      print('Error creating appointment: $e');
      _showSnackBar('Failed to create appointment');
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff39D2C0),
        title: Text(
          'Doctor Appointments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchDoctorAppointments,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? Center(child: Text('No appointments found'))
              : RefreshIndicator(
                  onRefresh: _fetchDoctorAppointments,
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _appointments.length,
                    itemBuilder: (context, index, animation) {
                      final appointment = _appointments[index];
                      return _buildAppointmentItem(
                          appointment, animation, index);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAppointmentDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentItem(
      Appointment appointment, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Text('Patient: ${appointment.patientName}'),
          subtitle: Text('Refollow Date: ${appointment.refollowDate}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAppointment(index);
            },
          ),
        ),
      ),
    );
  }

  void _deleteAppointment(int index) async {
    if (index < 0 || index >= _appointments.length) {
      _showSnackBar('Invalid appointment index');
      return;
    }

    final appointment = _appointments[index];
    final String url =
        '${Config.baseUrl}/appointments/destroy/${appointment.appointmentId}?_method=DELETE';

    try {
      final Response response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          final removedAppointment = _appointments.removeAt(index);
          _listKey.currentState!.removeItem(
            index,
            (context, animation) =>
                _buildAppointmentItem(removedAppointment, animation, index),
          );
        });
        _showSnackBar('Appointment Deleted Successfully', success: true);
      } else {
        throw Exception('Failed to delete appointment');
      }
    } catch (e) {
      print('Error deleting appointment: $e');
      _showSnackBar('Failed to delete appointment');
    }
  }

  Future<void> _showAddAppointmentDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField<int>(
                  value: _selectedPatientId,
                  items: _buildPatientDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPatientId = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Patient',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _refollowDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _refollowDateController.text =
                            pickedDate.toString().split(' ')[0];
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Refollow Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addAppointment();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<int>> _buildPatientDropdownItems() {
    List<DropdownMenuItem<int>> items = [];
    for (var patient in _patientList) {
      items.add(
        DropdownMenuItem<int>(
          value: patient.id,
          child: Text(patient.fullName),
        ),
      );
    }
    return items;
  }
}

class Appointment {
  final int appointmentId;
  final int patientId;
  final String patientName;
  final String refollowDate;

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.refollowDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      refollowDate: json['refollow_date'],
    );
  }
}

class Patient {
  final int id;
  final String fullName;

  Patient({
    required this.id,
    required this.fullName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
    );
  }
}
