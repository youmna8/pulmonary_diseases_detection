import 'package:flutter/material.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/appointment.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/reports.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/doc_info.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/patientsss_list_api.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/upload_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/login_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> doctorProfile;
  final Map<String, dynamic> patientData;

  MyBottomNavigationBar({
    required this.patientId,
    required this.token,
    required this.doctorProfile,
    required this.patientData,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  static const List<String> _appBarTitle = [
    'Upload audio',
    'Doctor Report',
    'Doctor Information',
    'Patient list',
    'Appointments'
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      UploadAudioScreen(
        doctorId: widget.patientId.toString(),
        token: widget.token,
      ),
      DoctorReportScreen(
        doctorId: widget.patientId,
        token: widget.token,
      ),
      Setting(
        patientId: widget.patientId,
        token: widget.token,
        patientData: widget.patientData,
        doctorProfile: widget.doctorProfile,
      ),
      PatientListScreen(
        token: widget.token,
        doctorId: widget.patientId,
      ),
      DoctorAppointmentsScreen(
        token: widget.token,
        doctorId: widget.patientId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff39D2C0),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return DoctorLoginScreen();
                }));
              },
              icon: (Icon(Icons.arrow_back_ios))),
          elevation: 2,
          centerTitle: true,
          title: Text(
            _appBarTitle[_currentIndex],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Spirax-Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _pages[_currentIndex],
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
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.cloud_upload,
                color: Color(0xff39D2C0),
              ),
              label: 'Upload audio',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(FontAwesomeIcons.microphone, color: Color(0xff39D2C0)),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person, color: Color(0xff39D2C0)),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(FontAwesomeIcons.bars, color: Color(0xff39D2C0)),
              label: 'Patients list',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(FontAwesomeIcons.calendarCheck,
                  color: Color(0xff39D2C0)),
              label: 'Appointment',
            ),
          ],
        ),
      ),
    );
  }
}
