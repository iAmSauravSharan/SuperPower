import 'package:http_interceptor/http_interceptor.dart';
import 'package:superpower/data/source/cache/cache_data_source.dart';
import 'package:superpower/data/source/remote/remote_data_source.dart';
import 'package:superpower/util/constants.dart';

class AppendHeadersInterceptor implements InterceptorContract {
  final _cache = CacheDataSource();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.params['units'] = 'metric';
      data.headers["Content-Type"] = "application/json; charset=UTF-8";
      data.headers["Access-Control-Allow-Origin"] = "*";
      data.headers["Accept"] = "*/*";
      if (RemoteDataSource.idToken) {
        data.headers[TokenType.Authorization.name] =
            await _cache.getToken(TokenType.idToken);
      }
      if (RemoteDataSource.accessToken) {
        data.headers[TokenType.Authorization.name] =
            await _cache.getToken(TokenType.accessToken);
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
