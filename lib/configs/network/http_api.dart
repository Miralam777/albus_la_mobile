import 'package:albus_la_mobile/configs/services/user_agent_service.dart';
import 'package:albus_la_mobile/env/env.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

@injectable
class HttpApi {
  static final Map<String, String> _headers = {
    "Content-type": "application/json",
    "Authorization": "Api-Key ${Env.apiKey}",
    "User-Agent": "${UserAgentService().userAgentForApiHeader}",
  };

  // @factoryMethod
  // Future<Response> get(String url) async =>
  // await http.Client().get(Uri.parse(url), headers: _headers);

  // @factoryMethod
  Future<Response> post(String url, Object body) async =>
      await http.Client().post(Uri.parse(url), headers: _headers, body: body);

  // Future<Response> get(String url, Object body) async =>
  // await http.Client().get(Uri.parse(url), headers: _headers, body: body);

  Future<Response> put(String url, Object body) async =>
      await http.Client().put(Uri.parse(url), headers: _headers, body: body);

  Future<Response> delete(String url, Object body) async =>
      await http.Client().delete(Uri.parse(url), headers: _headers, body: body);
}
