import 'package:superpower/bloc/app/app_bloc/model/app_preference.dart';

abstract class AppRepository {
  Future<AppPreference> getAppPreference();
}
