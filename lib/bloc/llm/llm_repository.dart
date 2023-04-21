import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_data.dart';

abstract class LLMRepository {
  Future<LLM> getUserLLMPreference();

  Future<Object> updateVendor(String vendor);
  Future<Object> updateModel(String model);
  Future<Object> updateCretivityLevel(String creativityLevel);
  Future<Object> updateAccessKey(String accessKey);

  Future<List<LLM>> getLLMs();
  // Future<String> getAccessKey();
}
