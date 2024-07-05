/*import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/login_screen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff39D2C0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color.fromARGB(255, 100, 205, 179),
                  ),
                ),
              ),
            ),
            Text(
              'Doctor Profile',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Spirax-Regular'),
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 350,
                  width: 410,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
                Positioned(
                  top: -50,
                  left: 30,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 340,
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      foregroundDecoration: BoxDecoration(
                                          image: const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/healthcare-workers-medical-insurance-pandemic-covid-19-concept-handsome-smiling-doctor-white-coat-glasses-holding-medicine-hand-advice-use-medication-antibiotics.jpg')),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Dr. John Smith ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Divider(
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Yomna Hashem',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Text(
                                        'youmna@gmail.com',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Text(
                                        '234567',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                width: 150,
                                height: 40,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 169, 241, 223))),
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Text(
                                          'Log out',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        /*IconButton(
                                            onPressed: () {
                                               Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return LoginScreen();
                                              }));
                                            }(),
                                            icon: Icon(Icons.exit_to_app)),*/
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}*/
