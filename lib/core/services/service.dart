
import 'package:get_it/get_it.dart';
import 'package:pulmunary_diseases_detection/core/bloc/cubit/global_cubit.dart';
import 'package:pulmunary_diseases_detection/core/database/cache_helper.dart';
import 'package:pulmunary_diseases_detection/features/doctor/data/doctor_login_cubit/login_cubit.dart';
import 'package:pulmunary_diseases_detection/features/patient/presentation/view_model/cubit/patient_cubit_cubit.dart';

final sl = GetIt.instance;
void initServiceIndicator() {
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => LoginCubit());
  sl.registerLazySingleton(() => PatientCubitCubit());
}
