import 'package:flutter/material.dart';

class PatientProfileScreen extends StatelessWidget {
  final Map<String, dynamic> patientData;

  PatientProfileScreen({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff39D2C0), Color(0xffE8F6F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Icon(
                        Icons.person_2,
                        color: Color(0xff39D2C0),
                        size: 85,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${patientData['fullName']}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.email, 'Email', patientData['email']),
                    SizedBox(height: 10),
                    _buildInfoRow(
                        Icons.location_on, 'Address', patientData['address']),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.phone, 'Phone', patientData['phone']),
                    SizedBox(height: 10),
                    _buildInfoRow(
                        Icons.cake, 'Age', patientData['age'].toString()),
                    SizedBox(height: 10),
                    _buildInfoRow(
                        Icons.person, 'Gender', patientData['gender']),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal, size: 24),
        SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

/*import 'package:flutter/material.dart';

class PatientProfileScreen extends StatelessWidget {
  final Map<String, dynamic> patientData;

  PatientProfileScreen({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // Placeholder for patient's profile picture
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${patientData['fullName']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${patientData['email']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${patientData['address']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${patientData['phone']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Age: ${patientData['age']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Gender: ${patientData['gender']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}*/
