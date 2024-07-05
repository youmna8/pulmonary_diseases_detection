// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:pulmunary_diseases_detection/core/bloc/cubit/global_state.dart';
import 'package:pulmunary_diseases_detection/core/database/cache_helper.dart';
import 'package:pulmunary_diseases_detection/core/services/service.dart';


class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  String LangCode = 'en';

  void changeLan(String CodeLang) async {
    emit(ChangeLangLoading());

    LangCode = CodeLang;
    await sl<CacheHelper>().cacheLanguage(CodeLang);
    emit(ChangeLangSuccess());
  }

  void getCachedLang() {
    emit(ChangeLangLoading());
    final CachedLang = sl<CacheHelper>().getCachedLanguage();
    LangCode = CachedLang;
    emit(ChangeLangSuccess());
  }
}
