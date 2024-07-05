/*import 'package:flutter/material.dart';

void main() {
  runApp(SignUp());
}

class SignUp extends StatelessWidget {
  SignUp({super.key});
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Breathe',
                        style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(
                              255,
                              77,
                              142,
                              79,
                            ),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Add Doctor',
                        style: TextStyle(
                            color: Color.fromARGB(
                              255,
                              77,
                              142,
                              79,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Full Name',
                              labelText: 'Name',
                              suffixIcon: Icon(Icons.person)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Email',
                              labelText: 'email',
                              suffixIcon: Icon(Icons.email)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Phone',
                              labelText: 'phone',
                              suffixIcon: Icon(Icons.phone)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Password',
                              labelText: 'password',
                              suffixIcon: Icon(Icons.remove_red_eye),
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  ),
                              hintText: 'Confirm Password',
                              labelText: 'confirm password',
                              suffixIcon: Icon(Icons.remove_red_eye),
                              ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}*/
