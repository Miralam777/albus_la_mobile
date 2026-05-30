import 'package:albus_la_mobile/constants/consts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SelectedViewIndexCubit extends Cubit<int> {
  final SharedPreferences sp;
  SelectedViewIndexCubit(this.sp)
    : super(sp.getInt(K.lastViewIndexPrefKey) ?? 0);

  void setIndex(int index) async {
    emit(index);
    await saveIndex();
  }

  Future<void> saveIndex() async =>
      await sp.setInt(K.lastViewIndexPrefKey, state);
}
