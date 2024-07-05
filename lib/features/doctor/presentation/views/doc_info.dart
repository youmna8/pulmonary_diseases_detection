import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic>? doctorProfile;

  Setting({
    required this.patientId,
    required this.token,
    required this.patientData,
    this.doctorProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: doctorProfile != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorInfoCard(
                    icon: Icons.person,
                    label: 'Doctor Name',
                    value: doctorProfile!['name'],
                  ),
                  _buildDoctorInfoCard(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: doctorProfile!['phone'],
                  ),
                  _buildDoctorInfoCard(
                    icon: Icons.location_on,
                    label: 'Address',
                    value: doctorProfile!['address'],
                  ),
                  _buildDoctorInfoCard(
                    icon: Icons.timer,
                    label: 'Years of Experience',
                    value: doctorProfile!['years_of_experience'].toString(),
                  ),
                ],
              )
            : Center(
                child: Text(
                  'Doctor information not available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDoctorInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 30),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic>? doctorProfile;

  Setting({
    required this.patientId,
    required this.token,
    required this.patientData,
    this.doctorProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: doctorProfile != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Doctor ID: ${doctorProfile!['id']}'),
                  Text('Doctor Name: ${doctorProfile!['name']}'),
                  Text('Phone: ${doctorProfile!['phone']}'),
                  Text('Address: ${doctorProfile!['address']}'),
                  Text(
                      'Years of Experience: ${doctorProfile!['years_of_experience']}'),
                ],
              )
            : Center(
                child: Text(
                  'Doctor information not available',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}*/
