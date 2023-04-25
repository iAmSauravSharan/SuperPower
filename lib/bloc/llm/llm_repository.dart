import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_data.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/user_llm_preference.dart';

abstract class LLMRepository {
  Future<UserLLMPreference> getUserLLMPreference();

  Future<Object> updateVendor(String vendor);
  Future<Object> updateModel(String model);
  Future<Object> updateCreativityLevel(String creativityLevel);
  Future<Object> updateAccessKey(Map<String, String> accessKeys);

  Future<List<LLM>> getLLMs();
  Future<Object> updateUserLLMPreference();
}
