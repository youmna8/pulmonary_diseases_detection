import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulmunary_diseases_detection/core/bloc/cubit/global_cubit.dart';
import 'package:pulmunary_diseases_detection/core/bloc/cubit/global_state.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';
import 'package:pulmunary_diseases_detection/core/locale/local.dart';
import 'package:pulmunary_diseases_detection/core/utiles/app_strings.dart';
import 'package:pulmunary_diseases_detection/core/widget/elevated_button.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/login_screen.dart';

class CangeLangScreen extends StatelessWidget {
  const CangeLangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.fill,
              color: Colors.green[200],
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                      child: Text(
                    AppStrings.welcometobreathapp.tr(context),
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(
                    height: 70.h,
                  ),
                  Text(
                    AppStrings.lan.tr(context),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 23),
                  ),
                  SizedBox(
                    height: 110.h,
                  ),
                  BlocBuilder<GlobalCubit, GlobalState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          MyElevatedButton(
                              text: 'English',
                              onPressed: () {
                                BlocProvider.of<GlobalCubit>(context)
                                    .changeLan('en');
                              }),
                          SizedBox(
                            width: 180,
                          ),
                          MyElevatedButton(
                              text: 'Arabic',
                              onPressed: () {
                                BlocProvider.of<GlobalCubit>(context)
                                    .changeLan('ar');
                              })
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xff447055),
                    child: IconButton(
                      onPressed: () {
                        //navigate(context: context, screen: DoctorLoginScreen());
                      },
                      icon: Icon(
                        Icons.forward,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
