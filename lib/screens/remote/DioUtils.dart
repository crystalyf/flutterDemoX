import 'package:dio/dio.dart';

import 'DioLogInterceptor.dart';

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
    /// request的param
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });
    print('request url：【' + method + '  ' + url + '】');
    print('request param：' + parameters.toString());
    Dio dio = createInstance();
    var result;
    Response response;
    try {
      //Get请求和Post请求发信的时候，参数param的字段不同，用不同的字段发
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

  ///dio的单例模式
  static Dio createInstance() {
    if (dio == null) {
      var options = BaseOptions(
        connectTimeout: 15000, //连接超时
        receiveTimeout: 15000, //响应超时
        responseType: ResponseType.plain,
        validateStatus: (status) {
          return true;
        },
        baseUrl: BASE_URL,
      );
      dio = Dio(options);
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = ((cert, host, port) => true);
        // //设置代理,return 电脑上charles的代理
        // client.findProxy = (uri) {
        //   //proxy all request to localhost:8888
        //   return "PROXY 192.168.150.61:8889";
        // };
        // you can also create a new HttpClient to dio
      };
    }
    // //添加请求之前的拦截器(可加可不加)
    //  dio.interceptors.add(DioLogInterceptor());
    return dio;
  }

  static void clear() {
    dio = null;
  }
}
