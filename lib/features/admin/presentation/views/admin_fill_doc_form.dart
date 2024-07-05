import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_login.dart'; // Import AdminScreen
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_manage_doctor.dart'; // Import AdminScreen
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible = false;

  Future<void> addDoctor() async {
    final String apiUrl = '${Config.baseUrl}/doctors/store';
    final String token = 'YOUR_AUTH_TOKEN'; // Replace with your actual token

    final Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Perform field validations
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        experienceController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // Validate phone number
    if (!phoneController.text.startsWith('0') ||
        phoneController.text.length != 11) {
      _showSnackBar('Phone number must start with 0 and be 11 digits long');
      return;
    }

    // Validate years of experience
    final int? yearsOfExperience = int.tryParse(experienceController.text);
    if (yearsOfExperience == null ||
        yearsOfExperience < 1 ||
        yearsOfExperience > 70) {
      _showSnackBar('Years of experience must be an integer between 1 and 70');
      return;
    }

    // Validate email format
    if (!emailController.text.endsWith('@gmail.com')) {
      _showSnackBar('Email must end with @gmail.com');
      return;
    }

    // Validate password length
    if (passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters long');
      return;
    }

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'years_of_experience': experienceController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      // Handle the response here
      _showSnackBar('Doctor added successfully');
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return AddDoctorScreen();
      }));
    } catch (error) {
      // Handle the error here
      _showSnackBar('Failed to add doctor');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff39D2C0),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return AdminScreen();
              }));
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: Color(0xff39D2C0),
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png',
              width: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50, left: 5, right: 5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: experienceController,
                      decoration: InputDecoration(
                        labelText: 'Years of Experience',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff39D2C0)),
                      ),
                      onPressed: addDoctor,
                      child: Text(
                        'Add Doctor',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
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

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/features/admin/presentation/views/admin_login.dart'; // Import AdminScreen
import 'package:proj_app/features/admin/presentation/views/admin_manage_doctor.dart'; // Import AdminScreen

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> addDoctor() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/doctors/store';
    final String token = 'YOUR_AUTH_TOKEN'; // Replace with your actual token

    final Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Perform field validations
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        experienceController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // Validate phone number
    if (!phoneController.text.startsWith('0') ||
        phoneController.text.length != 11) {
      _showSnackBar('Phone number must be 11 digits');
      return;
    }

    // Validate years of experience
    final int? yearsOfExperience = int.tryParse(experienceController.text);
    if (yearsOfExperience == null ||
        yearsOfExperience < 1 ||
        yearsOfExperience > 100) {
      _showSnackBar('Years of experience must be an integer between 1 and 100');
      return;
    }

    // Validate email format
    if (!emailController.text.endsWith('@gmail.com')) {
      _showSnackBar('Invalid email format');
      return;
    }

    // Validate password length
    if (passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'years_of_experience': experienceController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      // Handle the response here
      // You can show a success message or navigate to another screen
      _showSnackBar('Doctor added successfully');
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return AdminloginScreen(); // Replace with actual doctorId
      }));
    } catch (error) {
      // Handle the error here
      _showSnackBar('Failed to add doctor');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png',
              width: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  TextField(
                    controller: experienceController,
                    decoration: InputDecoration(
                      labelText: 'Years of Experience',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff39D2C0))),
                    onPressed: addDoctor,
                    child: Text(
                      'Add Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/core/commons/commons.dart';
import 'package:proj_app/features/admin/presentation/views/admin_manage_doctor.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> addDoctor() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/doctors/store';
    final String token = 'YOUR_AUTH_TOKEN'; // Replace with your actual token

    final Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Perform field validations
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        experienceController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // Validate phone number
    if (!phoneController.text.startsWith('0') ||
        phoneController.text.length != 11) {
      _showSnackBar('Phone number must be 11 digits');
      return;
    }

    // Validate years of experience
    final int? yearsOfExperience = int.tryParse(experienceController.text);
    if (yearsOfExperience == null ||
        yearsOfExperience < 1 ||
        yearsOfExperience > 100) {
      _showSnackBar('Years of experience must be an integer between 1 and 100');
      return;
    }

    // Validate email format
    if (!emailController.text.endsWith('@gmail.com')) {
      _showSnackBar('Invalid email format');
      return;
    }

    // Validate password length
    if (passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'years_of_experience': experienceController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      // Handle the response here
      // You can show a success message or navigate to another screen
      _showSnackBar('Doctor added successfully');
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return AdminScreen();
      }));
    } catch (error) {
      // Handle the error here
      _showSnackBar('Failed to add doctor');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        key: _scaffoldKey,
        body: Center(
            child: Stack(children: [
          Positioned(
            child: Image.asset(
              'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png',
              width: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 170,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: experienceController,
                    decoration: InputDecoration(
                        labelText: 'Years of Experience',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff39D2C0))),
                    onPressed: addDoctor,
                    child: Text(
                      'Add Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }
}*/
