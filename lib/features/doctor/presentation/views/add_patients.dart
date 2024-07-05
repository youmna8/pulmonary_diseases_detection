import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';
// Import the configuration file

class AddPatientScreen extends StatefulWidget {
  final String token;
  final String doctorId;

  AddPatientScreen({required this.token, required this.doctorId});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addPatient() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _dio.post(
          '${Config.baseUrl}/patients/store', // Use the base URL from Config
          data: {
            'fullName': _fullNameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'age': _ageController.text,
            'gender': _genderController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'doc_id': widget.doctorId,
          },
          options: Options(
            headers: {'Authorization': 'Bearer ${widget.token}'},
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient Successfully Created'),
              backgroundColor: Color(0xff39D2C0),
            ),
          );
          Navigator.of(context).pop(); // Go back to the previous screen
        } else {
          throw Exception('Patient Successfully Created');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create patient'),
             backgroundColor: Colors.white,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text('Add Patient'),
        backgroundColor: Color(0xff39D2C0),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _fullNameController,
                labelText: 'Full Name',
                icon: Icons.person,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _phoneController,
                labelText: 'Phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _addressController,
                labelText: 'Address',
                icon: Icons.location_on,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _ageController,
                labelText: 'Age',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _genderController,
                labelText: 'Gender',
                icon: Icons.transgender,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPatient,
                child: Text('Add Patient'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff39D2C0),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Color(0xff39D2C0)),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Phone') {
          final phoneRegex = RegExp(r'^01\d{9}$');
          if (!phoneRegex.hasMatch(value)) {
            return 'Please enter a valid phone number';
          }
        }
        if (labelText == 'Email') {
          final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid Gmail email address';
          }
        }
        if (labelText == 'Age') {
          final age = int.tryParse(value);
          if (age == null || age < 1 || age > 110) {
            return 'Please enter a valid age';
          }
        }
        return null;
      },
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddPatientScreen extends StatefulWidget {
  final String token;
  final String doctorId;

  AddPatientScreen({required this.token, required this.doctorId});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final String _apiUrl = 'http://127.0.0.1:8000/api/patients/store';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addPatient() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _dio.post(
          _apiUrl,
          data: {
            'fullName': _fullNameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'age': _ageController.text,
            'gender': _genderController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'doc_id': widget.doctorId,
          },
          options: Options(
            headers: {'Authorization': 'Bearer ${widget.token}'},
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient Successfully Created'),
              backgroundColor: Colors.white,
            ),
          );
          Navigator.of(context).pop(); // Go back to the previous screen
        } else {
          throw Exception('Patient Successfully Created');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient Successfully Created'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text('Add Patient'),
        backgroundColor: Color(0xff39D2C0),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _fullNameController,
                labelText: 'Full Name',
                icon: Icons.person,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _phoneController,
                labelText: 'Phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _addressController,
                labelText: 'Address',
                icon: Icons.location_on,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _ageController,
                labelText: 'Age',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _genderController,
                labelText: 'Gender',
                icon: Icons.transgender,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPatient,
                child: Text('Add Patient'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff39D2C0),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Color(0xff39D2C0)),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Phone') {
          final phoneRegex = RegExp(r'^01\d{9}$');
          if (!phoneRegex.hasMatch(value)) {
            return 'Please enter a valid phone number';
          }
        }
        if (labelText == 'Email') {
          final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid Gmail email address';
          }
        }
        if (labelText == 'Age') {
          final age = int.tryParse(value);
          if (age == null || age < 1 || age > 110) {
            return 'Please enter a valid age';
          }
        }
        return null;
      },
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddPatientScreen extends StatefulWidget {
  final String token;
  final String doctorId;

  AddPatientScreen({required this.token, required this.doctorId});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final String _apiUrl = 'http://127.0.0.1:8000/api/patients/store';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addPatient() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _dio.post(
          _apiUrl,
          data: {
            'fullName': _fullNameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'age': _ageController.text,
            'gender': _genderController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'doc_id': widget.doctorId,
          },
          options: Options(
            headers: {'Authorization': 'Bearer ${widget.token}'},
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient Successfully Created'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Go back to the previous screen
        } else {
          throw Exception('Patient Successfully Created');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient Successfully Created'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      appBar: AppBar(
        title: Text('Add Patient'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  final phoneRegex = RegExp(r'^01\d{9}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 110) {
                    return 'Please enter a valid age ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid Gmail email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPatient,
                child: Text('Add Patient'),
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

class AddPatientScreen extends StatefulWidget {
  final String token;
  final String doctorId;

  AddPatientScreen({required this.token, required this.doctorId});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final String _apiUrl = 'http://127.0.0.1:8000/api/patients/store';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addPatient() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _dio.post(
          _apiUrl,
          data: {
            'fullName': _fullNameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'age': _ageController.text,
            'gender': _genderController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'doc_id': widget.doctorId,
          },
          options: Options(
            headers: {'Authorization': 'Bearer ${widget.token}'},
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient Successfully Created'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Go back to the previous screen
        } else {
          throw Exception('Patient Successfully Created');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient Successfully Created'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      appBar: AppBar(
        title: Text('Add Patient'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPatient,
                child: Text('Add Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
