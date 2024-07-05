import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulmunary_diseases_detection/features/doctor/data/doctor_login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController adminLogin = TextEditingController();
  TextEditingController adminPass = TextEditingController();

  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isvisible = true;
  IconData suffixIcoon = Icons.visibility;
  void changepassVisivility() {
    isvisible = !isvisible;
    suffixIcoon = isvisible ? Icons.visibility : Icons.visibility_off;
    emit(ChangePsssVisState());
  }
}
