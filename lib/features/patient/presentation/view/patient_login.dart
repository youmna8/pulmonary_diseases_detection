import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/patient_homepage_screen.dart';
import 'package:pulmunary_diseases_detection/features/home/presentation/screens/docoradmin.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/report.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/profile.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class PatientLoginScreen extends StatefulWidget {
  @override
  _PatientLoginScreenState createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Dio _dio;
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  late String _token;
  late int _patientId;
  late Map<String, dynamic> _patientData;

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

    final String apiUrl = '${Config.baseUrl}/patient_login';

    try {
      final Response response = await _dio.post(
        apiUrl,
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer YOUR_BEARER_TOKEN',
          },
        ),
      );

      final data = response.data['data']['patient_data'];
      _token = data['token'];
      _patientId = data['id'];
      _patientData = data;

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
      );

      // Navigate to PatientReportScreen and pass the patient ID, token, and data
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PatientHome(
          patientId: _patientId,
          token: _token,
          patientData: _patientData,
        ),
      ));
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });

      // Show error snackbar
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
          child:  SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 230),
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
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      const Padding(
                        
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
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
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
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
