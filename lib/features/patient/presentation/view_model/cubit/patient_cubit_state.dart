part of 'patient_cubit_cubit.dart';

@immutable
sealed class PatientCubitState {}

final class PatientCubitInitial extends PatientCubitState {}
final class PatientLoginLoading extends PatientCubitState {}
final class PatientLoginSuccess extends PatientCubitState {}
final class PatientLoginFailuer extends PatientCubitState {}
final class ChangePsssVisState extends PatientCubitState {}
