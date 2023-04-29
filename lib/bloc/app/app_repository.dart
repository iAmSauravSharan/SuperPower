import 'package:superpower/bloc/app/app_bloc/model/app_preference.dart';
import 'package:superpower/bloc/app/app_bloc/model/faq.dart';

abstract class AppRepository {
  Future<AppPreference> getAppPreference();
  Future<List<FAQ>> getFAQs();
  Future<void> submitFeedback(double rating, String feedback);
}
