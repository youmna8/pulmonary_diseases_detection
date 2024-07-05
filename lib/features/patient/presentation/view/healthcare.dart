import 'package:flutter/material.dart';

void main() {
  runApp(HealthCare());
}

class HealthCare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disease Info',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DiseaseGridScreen(),
    );
  }
}

class DiseaseGridScreen extends StatelessWidget {
  final List<Map<String, dynamic>> diseases = [
    {
      'name': 'Bronchiolitis',
      'icon': Icons.air,
      'description':
          'Bronchiolitis is a common lung infection in young children and infants. It causes swelling and irritation and a buildup of mucus in the small airways of the lung. These small airways are called bronchioles. A virus almost always causes bronchiolitis.Symptoms For the first few days, the symptoms of bronchiolitis are much like a cold:Runny nose.Stuffy nose.Cough.Sometimes a slight feverLater, your child may have a week or more of working harder than usual to breathe, which may include wheezing.'
    },
    {
      'name': 'COPD',
      'icon': Icons.smoke_free,
      'description':
          'Chronic Obstructive Pulmonary Disease (COPD) is a chronic inflammatory lung disease. Chronic obstructive pulmonary disease (COPD) is a chronic inflammatory lung disease that causes obstructed airflow from the lungs. Symptoms include breathing difficulty, cough, mucus (sputum) production, and wheezing. Its typically caused by long-term exposure to irritating gases or particulate matter Symptoms Signs and symptoms of COPD may include: •	Shortness of breath, especially during physical activities •	Wheezing •	Chest tightness •	Frequent respiratory infections •	Lack of energy '
    },
    {
      'name': 'Pneumonia',
      'icon': Icons.local_hospital,
      'description':
          'Pneumonia is an infection that inflames the air sacs in one or both lungs, causing cough with phlegm or pus, fever, chills Symptoms The signs and symptoms of pneumonia vary from mild to severe, depending on factors such as the type of germ causing the infection Signs and symptoms of pneumonia may include:•	Chest pain when you breathe or cough •	Confusion or changes in mental awareness (in adults age 65 and older) •	Cough, which may produce phlegm •	Fever, sweating and shaking chills •	Nausea, vomiting or diarrhea'
    },
    {
      'name': 'URTI',
      'icon': Icons.thermostat,
      'description':
          'Upper Respiratory Tract Infection (URTI) refers to acute infections affecting the upper respiratory tract.including the nose, sinuses pharynx, larynx, or trachea. This commonly includes nasal obstruction, sore throat, tonsillitis, pharyngitis, laryngitis, sinusitis, otitis media, and the common cold symptoms You may get symptoms, including: •	Cough •	Fever. •	Hoarse voice. •	Fatigue and lack of energy. •	Red eyes •	Runny nose. •	Sore throat.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: diseases.length,
          itemBuilder: (context, index) {
            final disease = diseases[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiseaseDetailScreen(disease: disease),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(
                          disease['icon'],
                          size: 80,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          disease['name']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DiseaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> disease;

  DiseaseDetailScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return HealthCare();
                      }));
                    },
                    icon: (Icon(Icons.arrow_back_ios))),
                Text(
                  disease['name']!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              disease['description']!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

void main() {
  runApp(HealthCare());
}

class HealthCare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disease Info',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DiseaseGridScreen(),
    );
  }
}

class DiseaseGridScreen extends StatelessWidget {
  final List<Map<String, String>> diseases = [
    {
      'name': 'Bronchiolitis',
      'image': 'Frame.png',
      'description':
          'Bronchiolitis is a common lung infection in young children and infants. It causes swelling and irritation and a buildup of mucus in the small airways of the lung. These small airways are called bronchioles. A virus almost always causes bronchiolitis.Symptoms For the first few days, the symptoms of bronchiolitis are much like a cold:Runny nose.Stuffy nose.Cough.Sometimes a slight feverLater, your child may have a week or more of working harder than usual to breathe, which may include wheezing.'


    },
    {
      'name': 'COPD',
      'image': '2.PNG',
      'description':
          'Chronic Obstructive Pulmonary Disease (COPD) is a chronic inflammatory lung disease.'
    },
    {
      'name': 'Pneumonia',
      'image': '3.PNG',
      'description':
          'Pneumonia is an infection that inflames the air sacs in one or both lungs.'
    },
    {
      'name': 'URTI',
      'image': '4.PNG',
      'description':
          'Upper Respiratory Tract Infection (URTI) refers to acute infections affecting the upper respiratory tract.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: diseases.length,
          itemBuilder: (context, index) {
            final disease = diseases[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiseaseDetailScreen(disease: disease),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          disease['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          disease['name']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DiseaseDetailScreen extends StatelessWidget {
  final Map<String, String> disease;

  DiseaseDetailScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              disease['name']!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            Text(
              disease['description']!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
