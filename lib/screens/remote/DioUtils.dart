import 'package:dio/dio.dart';

class DioUtils {
  /// global dio object
  static Dio dio;
  static const String BASE_URL = "http://52.197.39.218:8080";
  //每一个API接口名：
  static const String forget = "/forget";

  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  ///Get （没用上）
  static void getHttp() async {
    try {
      Response response = await Dio().get("http://www.google.cn");
      print("response$response");
    } catch (e) {
      print(e);
    }
  }

  ///Post （没用上）
  static void postHttp<T>(
    String url, {
    parameters,
    Map<String, dynamic> headers,
    Function(T t) onSuccess,
    Function(String error) onError,
  }) async {
    ///request param
    parameters = parameters ?? {};
    //param
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    try {
      Response response;
      var dio = createInstance();
      response = await dio.post(url,
          data: parameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess(response.data);
        }
      } else {
        throw Exception('statusCode:${response.statusCode}');
      }
      print('response：' + response.toString());
    } catch (e) {
      print('error：' + e.toString());
      onError(e.toString());
    }
  }

  ///发起请求
  static request<T>(String url,
      {parameters,
      method,
      Map<String, dynamic> headers,
      Function(T t) onSuccess,
      Function(String error) onError}) async {
    parameters = parameters ?? {};
    method = method ?? 'GET';
    /// param
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });
    print('request url：【' + method + '  ' + url + '】');
    print('request param：' + parameters.toString());
    Dio dio = createInstance();
    //result
    var result;
    Response response;
    try {
      if(method == GET){
        response = await dio.request(url,
            queryParameters: parameters,
            options: new Options(method: method, headers: headers));
      } else {
        response = await dio.request(url,
            data: parameters,
            options: new Options(method: method, headers: headers));
      }
      result = response.data;
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess(result);
        }
      } else {
        throw Exception('statusCode:${response.statusCode}');
      }
      print('response data：' + response.toString());
    } on DioError catch (e) {
      print('response data：' + e.toString());
      onError(e.toString());
    } catch (e) {
      onError(e.toString());
    }
  }

  /// createInstance
  static Dio createInstance() {
    if (dio == null) {
      /// Global attributes: request prefix, connection timeout, response timeout
      var options = BaseOptions(
        connectTimeout: 15000,
        receiveTimeout: 15000,
        responseType: ResponseType.plain,
        validateStatus: (status) {
          // Do not use http status code to determine the status, use Adapter Interceptor to process (suitable for standard REST style)
          return true;
        },
        baseUrl: BASE_URL,
      );

      dio = Dio(options);
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = ((cert, host, port) => true);
        // client.findProxy = (uri) {
        //   //proxy all request to localhost:8888
        //   return "PROXY 192.168.150.61:8889";
        // };
        // you can also create a new HttpClient to dio
      };
    }
    // dio.interceptors.add(DioLogInterceptor());

    return dio;
  }

  static void clear() {
    dio = null;
  }
}
