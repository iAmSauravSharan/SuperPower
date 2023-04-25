import 'package:superpower/util/logging.dart';
import 'package:http_interceptor/http_interceptor.dart';

final log = Logging('http');

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    log.d(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    log.d(data.toString());
    return data;
  }
}
