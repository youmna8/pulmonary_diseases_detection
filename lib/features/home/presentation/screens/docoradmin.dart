import 'package:flutter/material.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/login_screen.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_login.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view/patient_login.dart';

class AdminORDoctor extends StatefulWidget {
  const AdminORDoctor({super.key});

  @override
  State<AdminORDoctor> createState() => _AdminORDoctorState();
}

class _AdminORDoctorState extends State<AdminORDoctor> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff39D2C0),
          body: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 208),
                child: Column(children: [
                            Stack(children: [
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/22222.png')),
                        borderRadius: BorderRadius.circular(20)),
                    height: 240,
                    width: 300,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                    ),
                  ),
                )
                            ]),
                            Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white),
                  height: 390,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Please tell us are you ',
                          style: TextStyle(
                              fontSize: 25,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'RobotoMono-VariableFont_wght',
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff39D2C0))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return AdminloginScreen();
                                },
                              ),
                            );
                          },
                          child: Text('Admin',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RobotoMono-VariableFont_wght',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff39D2C0))),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return DoctorLoginScreen();
                            }));
                          },
                          child: Text('Doctor',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RobotoMono-VariableFont_wght',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff39D2C0))),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return PatientLoginScreen();
                            }));
                          },
                          child: Text('Patient',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoMono-VariableFont_wght',
                                  color: Colors.white))),
                    ],
                  ))
                          ]),
              )),
        ));
  }
}
