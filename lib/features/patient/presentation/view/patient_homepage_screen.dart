import 'package:flutter/material.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/setting.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/upload_audio.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/healthcare.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/report.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/profile.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/appoint_pat.dart'; // Import AppointmentScreen
import 'package:dio/dio.dart';

void main() {
  runApp(HealthCare());
}

class PatientHome extends StatefulWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> patientData;

  PatientHome({
    required this.patientId,
    required this.token,
    required this.patientData,
  });

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  static const List<String> _appBarTitles = [
    'Report',

    'Profile',
    'Appointments',
    'Health care', // Add title for Appointments
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      PatientReportScreen(patientId: widget.patientId, token: widget.token),

      PatientProfileScreen(patientData: widget.patientData),
      AppointmentScreen(patientId: widget.patientId, token: widget.token),
      HealthCare(), // Pass necessary data
    ];
  }

  List<Widget> get _screens => [
        PatientReportScreen(patientId: widget.patientId, token: widget.token),

        PatientProfileScreen(patientData: widget.patientData),
        AppointmentScreen(patientId: widget.patientId, token: widget.token),
        HealthCare(), // Pass necessary data
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff39D2C0),
        elevation: 2,
        centerTitle: true,
        title: Text(
          _appBarTitles[_currentIndex],
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Spirax-Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.notesMedical,
              color: Color(0xff39D2C0),
            ),
            label: 'Medical report',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.user,
              color: Color(0xff39D2C0),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.calendarAlt,
              color: Color(0xff39D2C0),
            ),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.handHoldingMedical,
              color: Color(0xff39D2C0),
            ),
            label: 'Health care',
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/presentation/views/admin_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/admin/presentation/views/setting.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';
import 'package:proj_app/features/patient/presentation/view/healthcare.dart';
import 'package:proj_app/features/patient/presentation/view/report.dart';
import 'package:proj_app/features/patient/presentation/view/profile.dart';
import 'package:proj_app/features/patient/presentation/view/appoint_pat.dart'; // Import AppointmentScreen
import 'package:dio/dio.dart';

void main() {
  runApp(HealthCare());
}

class PatientHome extends StatefulWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> patientData;

  PatientHome({
    required this.patientId,
    required this.token,
    required this.patientData,
  });

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  static const List<String> _appBarTitles = [
    'Report',
    'Health care',
    'Profile',
    'Appointments', // Add title for Appointments
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      PatientReportScreen(patientId: widget.patientId, token: widget.token),
      HealthCare(),
      PatientProfileScreen(patientData: widget.patientData),
      AppointmentScreen(), // Add AppointmentScreen to pages
    ];
  }

  List<Widget> get _screens => [
        PatientReportScreen(patientId: widget.patientId, token: widget.token),
        HealthCare(),
        PatientProfileScreen(patientData: widget.patientData),
        AppointmentScreen(), // Add AppointmentScreen to screens
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff39D2C0),
        elevation: 2,
        centerTitle: true,
        title: Text(
          _appBarTitles[_currentIndex],
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Spirax-Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(color: Color(0xff447055)),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.notesMedical,
              color: Color(0xff447055),
            ),
            label: 'Medical report',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 147, 166, 155),
            icon: Icon(
              FontAwesomeIcons.handHoldingMedical,
              color: Color(0xff447055),
            ),
            label: 'Health care',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 147, 166, 155),
            icon: Icon(
              FontAwesomeIcons.user,
              color: Color(0xff447055),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 147, 166, 155),
            icon: Icon(
              FontAwesomeIcons.calendarAlt,
              color: Color(0xff447055),
            ),
            label: 'Appointments',
          ),
        ],
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';

import 'package:proj_app/features/admin/presentation/views/admin_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/admin/presentation/views/setting.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';
import 'package:proj_app/features/patient/presentation/view/healthcare.dart';
import 'package:proj_app/features/patient/presentation/view/report.dart';
import 'package:proj_app/features/patient/presentation/view/profile.dart';
import 'package:dio/dio.dart';

class PatientHome extends StatefulWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> patientData; // Add patientData here

  PatientHome({
    required this.patientId,
    required this.token,
    required this.patientData, // Receive patientData from DoctorLoginScreen
  });

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  static const List<String> _appBarTitles = [
    'Report',
    'Health care',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      PatientReportScreen(patientId: widget.patientId, token: widget.token),
      HealthCare(),
      // Pass patient data to the profile screen
      PatientProfileScreen(patientData: widget.patientData),
    ];
  }

  List<Widget> get _screens => [
        PatientReportScreen(patientId: widget.patientId, token: widget.token),
        HealthCare(),
        PatientProfileScreen(patientData: widget.patientData),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff39D2C0),
        elevation: 2,
        centerTitle: true,
        title: Text(
          _appBarTitles[_currentIndex],
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Spirax-Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(color: Color(0xff447055)),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.notesMedical,
              color: Color(0xff447055),
            ),
            label: 'Medical report',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 147, 166, 155),
            icon: Icon(
              FontAwesomeIcons.handHoldingMedical,
              color: Color(0xff447055),
            ),
            label: 'Health care',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 147, 166, 155),
            icon: Icon(
              FontAwesomeIcons.user,
              color: Color(0xff447055),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}*/
