import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulmunary_diseases_detection/features/admin/data/doc_list_model.dart';
import 'package:pulmunary_diseases_detection/features/admin/data/rep.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_manage_doctor.dart'; // Import AdminScreen
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class PatientListScreen extends StatefulWidget {
  final String token;
  final int doctorId;
  PatientListScreen({required this.token, required this.doctorId});
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _noPatientsFound = false;
  final DoctorService _doctorService = DoctorService();
  final Dio _dio = Dio();
  final String _baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();

    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final String url =
        '${Config.baseUrl}/patients/all/${widget.doctorId}';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Doctor Has No Patients') {
          setState(() {
            _noPatientsFound = true;
          });
        } else {
          List<dynamic> patientsJson = response.data['data']['patients'];
          setState(() {
            _patients =
                patientsJson.map((json) => Patient.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load patients');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDoctor(int id) async {
    try {
      final response = await _dio.delete(
        '${Config.baseUrl}/patients/destroy/$id',
        queryParameters: {'_method': 'DELETE'},
        options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
      );
      if (response.statusCode == 200) {
        // Doctor deleted successfully, refresh the list
        setState(() {
          _fetchPatients();
        });
      } else {
        throw Exception('Failed to delete doctor');
      }
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  Future<void> _editDoctor(int id) async {
    // Fetch the doctor's details
    final response = await _dio.get(
      '${Config.baseUrl}/patients/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['patient'];

      // Open a dialog to edit doctor details
      await showDialog(
        context: context,
        builder: (context) {
          bool isSaving = false; // Track if saving is in progress
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Doctor'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: data['fullName'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['fullName'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['email'],
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (value) {
                          // Update email in data map
                          data['email'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['address'],
                        decoration: InputDecoration(labelText: 'Address'),
                        onChanged: (value) {
                          // Update address in data map
                          data['address'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['phone'],
                        decoration: InputDecoration(labelText: 'Phone'),
                        onChanged: (value) {
                          // Update phone in data map
                          data['phone'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Add other fields as needed (address, years_of_experience, email, password)
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            // Prevent multiple save requests
                            setState(() {
                              isSaving = true;
                            });
                            try {
                              final updateResponse = await _dio.post(
                                '${Config.baseUrl}/patients/update?_method=PUT',
                                data: data,
                                options: Options(
                                  headers: {
                                    'Authorization': 'Bearer your_token_here'
                                  },
                                ),
                              );
                              if (updateResponse.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.white,
                                    content:
                                        Text('Doctor updated successfully'),
                                  ),
                                );
                                // Refresh the doctor list after updating
                                setState(() {
                                  _fetchPatients();
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return AdminScreen();
                                })); // Close the dialog
                              } else {
                                throw Exception('Doctor updated successfully');
                                setState(() {
                                  _fetchPatients();
                                });
                              }
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text('Doctor updated successfully'),
                                ),
                              );

                              Navigator.of(context).pop();
                              setState(() {
                                _fetchPatients();
                              });
                            }
                          },
                    child: isSaving
                        ? const CircularProgressIndicator()
                        : Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      throw Exception('Failed to fetch doctor details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _noPatientsFound
                ? Center(child: Text('No patients found for this doctor.'))
                : ListView.builder(
                    itemCount: _patients.length,
                    itemBuilder: (context, index) {
                      final patient = _patients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(
                              patient.fullName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text('Phone: ${patient.phone}'),
                                SizedBox(height: 4),
                                Text('Address: ${patient.address}'),
                                SizedBox(height: 4),
                                Text('Age: ${patient.age}'),
                                SizedBox(height: 4),
                                Text('Gender: ${patient.gender}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Patient'),
                                      content: Text(
                                        'Are you sure you want to delete ${patient.fullName}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await _deleteDoctor(patient.id);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              _editDoctor(patient.id);
                            },
                          ),
                        ),
                      );
                    },
                  ));
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: DoctorListScreen(),
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String email;
  final String password;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    required this.email,
    required this.password,
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
      password: json['password'],
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientListScreen extends StatefulWidget {
  final String token;
  final int doctorId;

  PatientListScreen({required this.token, required this.doctorId});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _noPatientsFound = false;

  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final String url =
        'http://127.0.0.1:8000/api/patients/all/${widget.doctorId}';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Doctor Has No Patients') {
          setState(() {
            _noPatientsFound = true;
          });
        } else {
          List<dynamic> patientsJson = response.data['data']['patients'];
          setState(() {
            _patients =
                patientsJson.map((json) => Patient.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load patients');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePatient(int patientId) async {
    final String url = 'http://127.0.0.1:8000/api/patients/destroy/$patientId';
    try {
      final Response response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) {
            return true; // Accept all status codes for handling them in the catch block
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Deleted') {
          // Refresh the patient list
          _fetchPatients();
        } else {
          throw Exception('Failed to delete patient');
        }
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to delete patient');
    }
  }

  Future<void> _updatePatient({
    required int id,
    required String fullName,
    required String phone,
    required String address,
    required int age,
    required String gender,
    required String email,
    required String password,
  }) async {
    final String url = 'http://127.0.0.1:8000/api/patients/update?_method=PUT';
    try {
      final Response response = await _dio.put(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
        data: {
          'id': id,
          'fullName': fullName,
          'phone': phone,
          'address': address,
          'age': age,
          'gender': gender,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Updated') {
          // Optionally: Perform actions after successful update
          // Refresh patient list or show success message
          _fetchPatients();
        } else {
          throw Exception('Failed to update patient');
        }
      } else {
        throw Exception('Failed to update patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to update patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _noPatientsFound
              ? Center(child: Text('No patients found for this doctor.'))
              : ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            patient.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Phone: ${patient.phone}'),
                              SizedBox(height: 4),
                              Text('Address: ${patient.address}'),
                              SizedBox(height: 4),
                              Text('Age: ${patient.age}'),
                              SizedBox(height: 4),
                              Text('Gender: ${patient.gender}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Patient'),
                                    content: Text(
                                      'Are you sure you want to delete ${patient.fullName}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _deletePatient(patient.id);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          onTap: () {
                            _showUpdateDialog(patient);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showUpdateDialog(Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String _fullName = patient.fullName;
        String _phone = patient.phone;
        String _address = patient.address;
        int _age = patient.age;
        String _gender = patient.gender;
        String _email = patient.email;
        String _password = patient.password;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Patient'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Full Name'),
                      onChanged: (value) => _fullName = value,
                      controller: TextEditingController(text: _fullName),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Phone'),
                      onChanged: (value) => _phone = value,
                      controller: TextEditingController(text: _phone),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Address'),
                      onChanged: (value) => _address = value,
                      controller: TextEditingController(text: _address),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Age'),
                      onChanged: (value) => _age = int.tryParse(value) ?? _age,
                      controller: TextEditingController(text: _age.toString()),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Gender'),
                      onChanged: (value) => _gender = value,
                      controller: TextEditingController(text: _gender),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (value) => _email = value,
                      controller: TextEditingController(text: _email),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      onChanged: (value) => _password = value,
                      controller: TextEditingController(text: _password),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await _updatePatient(
                        id: patient.id,
                        fullName: _fullName,
                        phone: _phone,
                        address: _address,
                        age: _age,
                        gender: _gender,
                        email: _email,
                        password: _password,
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update patient'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String email;
  final String password;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    required this.email,
    required this.password,
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
      password: json['password'],
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientListScreen extends StatefulWidget {
  final String token;
  final int doctorId;

  PatientListScreen({required this.token, required this.doctorId});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _noPatientsFound = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final String url =
        'http://127.0.0.1:8000/api/patients/all/${widget.doctorId}';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Doctor Has No Patients') {
          setState(() {
            _noPatientsFound = true;
          });
        } else {
          List<dynamic> patientsJson = response.data['data']['patients'];
          setState(() {
            _patients =
                patientsJson.map((json) => Patient.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load patients');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePatient(int patientId) async {
    final String url = 'http://127.0.0.1:8000/api/patients/destroy/$patientId';
    try {
      final Response response = await Dio().delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) {
            return true; // Accept all status codes for handling them in the catch block
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Deleted') {
          // Refresh the patient list
          _fetchPatients();
        } else {
          throw Exception('Failed to delete patient');
        }
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to delete patient');
    }
  }

  Future<void> _editPatient(Patient patient) async {
    TextEditingController nameController =
        TextEditingController(text: patient.fullName);
    TextEditingController phoneController =
        TextEditingController(text: patient.phone);
    TextEditingController addressController =
        TextEditingController(text: patient.address);
    TextEditingController ageController =
        TextEditingController(text: patient.age.toString());
    TextEditingController genderController =
        TextEditingController(text: patient.gender);
    TextEditingController emailController =
        TextEditingController(text: patient.email);
    TextEditingController passwordController =
        TextEditingController(text: patient.password);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Patient'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                Navigator.of(context).pop();
                final String url =
                    'http://127.0.0.1:8000/api/patients/update?_method=PUT';
                try {
                  final Response response = await Dio().post(
                    url,
                    data: {
                      'id': patient.id,
                      'fullName': nameController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'age': int.parse(ageController.text),
                      'gender': genderController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                    },
                    options: Options(
                      headers: {
                        'Authorization': 'Bearer ${widget.token}',
                      },
                    ),
                  );

                  if (response.statusCode == 200) {
                    final data = response.data;
                    if (data['message'] == 'Patient Successfully Updated') {
                      _fetchPatients();
                    } else {
                      throw Exception('Failed to update patient');
                    }
                  } else {
                    throw Exception('Failed to update patient');
                  }
                } catch (e) {
                  print(e);
                  throw Exception('Failed to update patient');
                }
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
          : _noPatientsFound
              ? Center(child: Text('No patients found for this doctor.'))
              : ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            patient.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Phone: ${patient.phone}'),
                              SizedBox(height: 4),
                              Text('Address: ${patient.address}'),
                              SizedBox(height: 4),
                              Text('Age: ${patient.age}'),
                              SizedBox(height: 4),
                              Text('Gender: ${patient.gender}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editPatient(patient);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Patient'),
                                        content: Text(
                                          'Are you sure you want to delete ${patient.fullName}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await _deletePatient(patient.id);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String? token;
  final String email;
  final String password;
  final int docId;
  final String createdAt;
  final String updatedAt;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    this.token,
    required this.email,
    required this.password,
    required this.docId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
      token: json['token'],
      email: json['email'],
      password: json['password'],
      docId: json['doc_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientListScreen extends StatefulWidget {
  final String token;
  final int doctorId;

  PatientListScreen({required this.token, required this.doctorId});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _noPatientsFound = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final String url =
        'http://127.0.0.1:8000/api/patients/all/${widget.doctorId}';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Doctor Has No Patients') {
          setState(() {
            _noPatientsFound = true;
          });
        } else {
          List<dynamic> patientsJson = response.data['data']['patients'];
          setState(() {
            _patients =
                patientsJson.map((json) => Patient.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load patients');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePatient(int patientId) async {
    final String url = 'http://127.0.0.1:8000/api/patients/destroy/$patientId';
    try {
      final Response response = await Dio().delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) {
            return true; // Accept all status codes for handling them in the catch block
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Deleted') {
          // Refresh the patient list
          _fetchPatients();
        } else {
          throw Exception('Failed to delete patient');
        }
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to delete patient');
    }
  }

  Future<void> _editPatient(Patient patient) async {
    TextEditingController nameController =
        TextEditingController(text: patient.fullName);
    TextEditingController phoneController =
        TextEditingController(text: patient.phone);
    TextEditingController addressController =
        TextEditingController(text: patient.address);
    TextEditingController ageController =
        TextEditingController(text: patient.age.toString());
    TextEditingController genderController =
        TextEditingController(text: patient.gender);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Patient'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                Navigator.of(context).pop();
                final String url =
                    'http://127.0.0.1:8000/api/patients/${patient.id}/edit';
                try {
                  final Response response = await Dio().put(
                    url,
                    data: {
                      'fullName': nameController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'age': int.parse(ageController.text),
                      'gender': genderController.text,
                    },
                    options: Options(
                      headers: {
                        'Authorization': 'Bearer ${widget.token}',
                      },
                    ),
                  );

                  if (response.statusCode == 200) {
                    final data = response.data;
                    if (data['message'] == 'Patient Successfully Updated') {
                      _fetchPatients();
                    } else {
                      throw Exception('Failed to update patient');
                    }
                  } else {
                    throw Exception('Failed to update patient');
                  }
                } catch (e) {
                  print(e);
                  throw Exception('Failed to update patient');
                }
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
          : _noPatientsFound
              ? Center(child: Text('No patients found for this doctor.'))
              : ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            patient.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Phone: ${patient.phone}'),
                              SizedBox(height: 4),
                              Text('Address: ${patient.address}'),
                              SizedBox(height: 4),
                              Text('Age: ${patient.age}'),
                              SizedBox(height: 4),
                              Text('Gender: ${patient.gender}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editPatient(patient);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Patient'),
                                        content: Text(
                                          'Are you sure you want to delete ${patient.fullName}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await _deletePatient(patient.id);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String? token;
  final String email;
  final String password;
  final int docId;
  final String createdAt;
  final String updatedAt;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    this.token,
    required this.email,
    required this.password,
    required this.docId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
      token: json['token'],
      email: json['email'],
      password: json['password'],
      docId: json['doc_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientListScreen extends StatefulWidget {
  final String token;
  final int doctorId;

  PatientListScreen({required this.token, required this.doctorId});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _noPatientsFound = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final String url =
        'http://127.0.0.1:8000/api/patients/all/${widget.doctorId}';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Doctor Has No Patients') {
          setState(() {
            _noPatientsFound = true;
          });
        } else {
          List<dynamic> patientsJson = response.data['data']['patients'];
          setState(() {
            _patients =
                patientsJson.map((json) => Patient.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load patients');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePatient(int patientId) async {
    final String url = 'http://127.0.0.1:8000/api/patients/destroy/$patientId';
    try {
      final Response response = await Dio().delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) {
            return true; // Accept all status codes for handling them in the catch block
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Deleted') {
          // Refresh the patient list
          _fetchPatients();
        } else {
          throw Exception('Failed to delete patient');
        }
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to delete patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _noPatientsFound
              ? Center(child: Text('No patients found for this doctor.'))
              : ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            patient.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Phone: ${patient.phone}'),
                              SizedBox(height: 4),
                              Text('Address: ${patient.address}'),
                              SizedBox(height: 4),
                              Text('Age: ${patient.age}'),
                              SizedBox(height: 4),
                              Text('Gender: ${patient.gender}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Patient'),
                                    content: Text(
                                      'Are you sure you want to delete ${patient.fullName}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _deletePatient(patient.id);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String? token;
  final String email;
  final String password;
  final int docId;
  final String createdAt;
  final String updatedAt;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    this.token,
    required this.email,
    required this.password,
    required this.docId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
      token: json['token'],
      email: json['email'],
      password: json['password'],
      docId: json['doc_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientListScreen extends StatefulWidget {
  final String token;
  final int doctorId;

  PatientListScreen({required this.token, required this.doctorId});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _noPatientsFound = false;

  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final String url =
        'http://127.0.0.1:8000/api/patients/all/${widget.doctorId}';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Doctor Has No Patients') {
          setState(() {
            _noPatientsFound = true;
          });
        } else {
          List<dynamic> patientsJson = response.data['data']['patients'];
          setState(() {
            _patients =
                patientsJson.map((json) => Patient.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load patients');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePatient(int patientId) async {
    final String url = 'http://127.0.0.1:8000/api/patients/destroy/$patientId';
    try {
      final Response response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) {
            return true; // Accept all status codes for handling them in the catch block
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Deleted') {
          // Refresh the patient list
          _fetchPatients();
        } else {
          throw Exception('Failed to delete patient');
        }
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to delete patient');
    }
  }

  Future<void> _updatePatient({
    required int id,
    required String fullName,
    required String phone,
    required String address,
    required int age,
    required String gender,
    required String email,
    required String password,
  }) async {
    final String url = 'http://127.0.0.1:8000/api/patients/update?_method=PUT';
    try {
      final Response response = await _dio.put(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
        data: {
          'id': id,
          'fullName': fullName,
          'phone': phone,
          'address': address,
          'age': age,
          'gender': gender,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Patient Successfully Updated') {
          // Optionally: Perform actions after successful update
          // Refresh patient list or show success message
          _fetchPatients();
        } else {
          throw Exception('Failed to update patient');
        }
      } else {
        throw Exception('Failed to update patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to update patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _noPatientsFound
              ? Center(child: Text('No patients found for this doctor.'))
              : ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            patient.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Phone: ${patient.phone}'),
                              SizedBox(height: 4),
                              Text('Address: ${patient.address}'),
                              SizedBox(height: 4),
                              Text('Age: ${patient.age}'),
                              SizedBox(height: 4),
                              Text('Gender: ${patient.gender}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Patient'),
                                    content: Text(
                                      'Are you sure you want to delete ${patient.fullName}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _deletePatient(patient.id);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          onTap: () {
                            _showUpdateDialog(patient);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showUpdateDialog(Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String _fullName = patient.fullName;
        String _phone = patient.phone;
        String _address = patient.address;
        int _age = patient.age;
        String _gender = patient.gender;
        String _email = patient.email;
        String _password = patient.password;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Patient'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Full Name'),
                      onChanged: (value) => _fullName = value,
                      controller: TextEditingController(text: _fullName),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Phone'),
                      onChanged: (value) => _phone = value,
                      controller: TextEditingController(text: _phone),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Address'),
                      onChanged: (value) => _address = value,
                      controller: TextEditingController(text: _address),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Age'),
                      onChanged: (value) => _age = int.tryParse(value) ?? _age,
                      controller: TextEditingController(text: _age.toString()),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Gender'),
                      onChanged: (value) => _gender = value,
                      controller: TextEditingController(text: _gender),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (value) => _email = value,
                      controller: TextEditingController(text: _email),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      onChanged: (value) => _password = value,
                      controller: TextEditingController(text: _password),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await _updatePatient(
                        id: patient.id,
                        fullName: _fullName,
                        phone: _phone,
                        address: _address,
                        age: _age,
                        gender: _gender,
                        email: _email,
                        password: _password,
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update patient'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final int age;
  final String gender;
  final String email;
  final String password;

  Patient({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    required this.email,
    required this.password,
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
      password: json['password'],
    );
  }
}*/
