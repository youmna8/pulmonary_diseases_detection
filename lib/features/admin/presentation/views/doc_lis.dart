import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulmunary_diseases_detection/features/admin/data/doc_list_model.dart';
import 'package:pulmunary_diseases_detection/features/admin/data/rep.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_manage_doctor.dart'; // Import AdminScreen
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

import 'admin_manage_doctor.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late Future<List<Doctor>> _futureDoctors;
  final DoctorService _doctorService = DoctorService();
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000';

  Future<void> _deleteDoctor(int id) async {
    try {
      final response = await _dio.delete(
        '${Config.baseUrl}/doctors/destroy/$id',
        queryParameters: {'_method': 'DELETE'},
        options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
      );
      if (response.statusCode == 200) {
        // Doctor deleted successfully, refresh the list
        setState(() {
          _futureDoctors = _doctorService.fetchDoctors();
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
      '${Config.baseUrl}/doctors/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['doctor'];

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
                        initialValue: data['name'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['name'] = value;
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
                       TextFormField(
                        initialValue: data['password'],
                        decoration: InputDecoration(
                          labelText: 'password',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['password'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
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
                                '${Config.baseUrl}/doctors/update?_method=PUT',
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
                                  _futureDoctors =
                                      _doctorService.fetchDoctors();
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return AdminScreen();
                                })); // Close the dialog
                              } else {
                                throw Exception('Doctor updated successfully');
                                setState(() {
                                  _futureDoctors =
                                      _doctorService.fetchDoctors();
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return DoctorListScreen();
                                }));
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
                                _futureDoctors = _doctorService.fetchDoctors();
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DoctorListScreen();
                              }));
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
  void initState() {
    super.initState();
    _futureDoctors = _doctorService.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Doctors List',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff39D2C0),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return AdminScreen();
                }));
              },
              icon: (Icon(Icons.arrow_back_ios))),
        ),
        backgroundColor: Color(0xff39D2C0),
        body: FutureBuilder<List<Doctor>>(
            future: _futureDoctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final doctors = snapshot.data!;
                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Dismissible(
                      key: Key(doctor.id.toString()),
                      onDismissed: (_) => _deleteDoctor(doctor.id as int),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _editDoctor(doctor.id),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: 400,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.userMd,
                                        size: 30,
                                        color: Colors.teal,
                                      ),
                                      title: Text(
                                        doctor.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Email: ${doctor.email}'),
                                          Text('Phone: ${doctor.phone}'),
                                          Text('Address: ${doctor.address}'),
                                          Text(
                                              'Years of Experience: ${doctor.yearsOfExperience}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }));
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
      home: DoctorListScreen(),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';
import 'package:proj_app/features/admin/presentation/views/admin_manage_doctor.dart'; // Import AdminScreen

import 'admin_manage_doctor.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late Future<List<Doctor>> _futureDoctors;
  final DoctorService _doctorService = DoctorService();
  final Dio _dio = Dio();
  final String _baseUrl = 'http://127.0.0.1:8000';

  Future<void> _deleteDoctor(int id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/doctors/destroy/$id',
        queryParameters: {'_method': 'DELETE'},
        options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
      );
      if (response.statusCode == 200) {
        // Doctor deleted successfully, refresh the list
        setState(() {
          _futureDoctors = _doctorService.fetchDoctors();
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
      '$_baseUrl/api/doctors/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['doctor'];

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
                        initialValue: data['name'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['name'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['email'],
                        decoration: InputDecoration(labelText: 'email'),
                        onChanged: (value) {
                          // Update name in data map
                          data['email'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['address'],
                        decoration: InputDecoration(labelText: 'address'),
                        onChanged: (value) {
                          // Update name in data map
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
                                '$_baseUrl/api/doctors/update?_method=PUT',
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
                                    content:
                                        Text('Doctor updated successfully'),
                                  ),
                                );
                                // Refresh the doctor list after updating
                                setState(() {
                                  _futureDoctors =
                                      _doctorService.fetchDoctors();
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return AdminScreen();
                                })); // Close the dialog
                              } else {
                                throw Exception('Doctor updated successfully');
                              }
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(' Doctor updated successfully'),
                                ),
                              );
                              Navigator.of(context).pop();
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
  void initState() {
    super.initState();
    _futureDoctors = _doctorService.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Doctors List',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff39D2C0),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return AdminScreen();
                }));
              },
              icon: (Icon(Icons.arrow_back_ios))),
        ),
        backgroundColor: Color(0xff39D2C0),
        body: FutureBuilder<List<Doctor>>(
            future: _futureDoctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final doctors = snapshot.data!;
                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Dismissible(
                      key: Key(doctor.id.toString()),
                      onDismissed: (_) => _deleteDoctor(doctor.id as int),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _editDoctor(doctor.id),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: 400,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${doctor.name}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Email: ${doctor.email}'),
                                    Text('Phone: ${doctor.phone}'),
                                    Text('address: ${doctor.address}'),
                                    Text(
                                        'Years of Experience: ${doctor.yearsOfExperience}'),
                                    //Text('password: ${doctor.password}'),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 380,
                              top: 30,
                              child: Image.asset(
                                'assets/images/Stetoscope.png',
                                width: 100,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }));
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
      home: DoctorListScreen(),
    );
  }
}*/
