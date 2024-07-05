import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulmunary_diseases_detection/core/widget/elevated_button.dart';
import 'package:pulmunary_diseases_detection/core/widget/text_form.dart';
import 'package:pulmunary_diseases_detection/features/doctor/data/doctor_login_cubit/login_cubit.dart';
import 'package:pulmunary_diseases_detection/features/doctor/data/doctor_login_cubit/login_state.dart';
import 'package:pulmunary_diseases_detection/features/admin/presentation/views/admin_manage_doctor.dart';
import 'package:pulmunary_diseases_detection/features/home/presentation/screens/docoradmin.dart';

class AdminloginScreen extends StatelessWidget {
  const AdminloginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff39D2C0),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(left: 30,top: 100),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return AdminORDoctor();
                          }));
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 35,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Spirax-Regular',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    final loginBlocProvide =
                        BlocProvider.of<LoginCubit>(context);
                    return Form(
                      key: loginBlocProvide.loginKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 80.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                CustomTextForm(
                                  validate: (data) {
                                    if (data!.isEmpty ||
                                        !data.contains('ahmedd@gmail.com')) {
                                      return 'please Enter Valid Email';
                                    }
                                  },
                                  hintText: 'Email',
                                  controller: loginBlocProvide.adminLogin,
                                  onpressed: () {},
                                  label: 'Email',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomTextForm(
                                  hintText: 'Password',
                                  controller: loginBlocProvide.adminPass,
                                  label: 'Password',
                                  onpressed: () {
                                    loginBlocProvide.changepassVisivility();
                                  },
                                  isPassword: loginBlocProvide.isvisible,
                                  validate: (data) {
                                    if (data!.length < 5 ||
                                        data.isEmpty ||
                                        !data.contains('12345')) {
                                      return 'please Enter Valid Password';
                                    }
                                    return null;
                                  },
                                  icon: loginBlocProvide.suffixIcoon,
                                ),
                                SizedBox(
                                  height: 120,
                                ),
                                MyElevatedButton(
                                  text: 'Log in',
                                  onPressed: () {
                                    if (loginBlocProvide.loginKey.currentState!
                                        .validate()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return AdminScreen();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 55,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
