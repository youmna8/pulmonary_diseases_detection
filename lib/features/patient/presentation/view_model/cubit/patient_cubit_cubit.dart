import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'patient_cubit_state.dart';


class PatientCubitCubit extends Cubit<PatientCubitState> {
  PatientCubitCubit() : super(PatientCubitInitial());
  GlobalKey<FormState> patientloginKey = GlobalKey<FormState>();
  TextEditingController patientemail = TextEditingController();
  TextEditingController patientPass = TextEditingController();

  bool isvisible = true;
  IconData suffixIcoon = Icons.visibility;
  void changepassVisivility() {
    isvisible = !isvisible;
    suffixIcoon = isvisible ? Icons.visibility : Icons.visibility_off;
    emit(ChangePsssVisState());
  }
}
