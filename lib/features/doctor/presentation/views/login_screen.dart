import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/bottom_navigation_bar.dart';
import 'package:pulmunary_diseases_detection/features/home/presentation/screens/docoradmin.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class DoctorLoginScreen extends StatefulWidget {
  @override
  _DoctorLoginScreenState createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Dio _dio;
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  late String _token;
  late int _doctorId;
  late Map<String, dynamic> _patientData;
  late Map<String, dynamic> _doctorProfile;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
  }

  Future<void> _login() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String loginUrl = '${Config.baseUrl}/doctor_login';

    try {
      final Response response = await _dio.post(
        loginUrl,
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data']['doctor_data'];

        if (data != null && data['token'] != null && data['id'] != null) {
          _token = data['token'];
          _doctorId = data['id'];
          _patientData = response.data['data'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login successfully!',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
          );

          await _fetchDoctorProfile();

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyBottomNavigationBar(
              patientId: _doctorId,
              token: _token,
              patientData: _patientData,
              doctorProfile: _doctorProfile, // Pass the doctor profile data
            ),
          ));
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchDoctorProfile() async {
    final String profileUrl =
        '${Config.baseUrl}/doctors/$_doctorId/show';

    try {
      final Response response = await _dio.get(
        profileUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        _doctorProfile = response.data['data']['doctor'];
      } else {
        throw Exception('Failed to fetch doctor profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch doctor profile.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch doctor profile.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _validateInputs() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password must not be empty';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password must not be empty')),
      );

      return false;
    }

    if (!_emailController.text.endsWith('@gmail.com')) {
      setState(() {
        _errorMessage = 'Email must end with @gmail.com';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email must end with @gmail.com')),
      );

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 70),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return AdminORDoctor();
                            }));
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 35,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Spirax-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                SizedBox(height: 120),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Login',
                            style: TextStyle(color: Colors.white, fontSize: 22)),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff39D2C0)),
                        ),
                      ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
