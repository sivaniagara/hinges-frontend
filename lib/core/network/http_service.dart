
abstract class HttpService {
  Future<Map<String, dynamic>> get(
      String url, {
        Map<String, String>? headers,
        Map<String, dynamic>? queryParams,
      });

  Future<Map<String, dynamic>> post(
      String url, {
        Map<String, String>? headers,
        Object? body,
      });

  Future<Map<String, dynamic>> put(
      String url, {
        Map<String, String>? headers,
        Object? body,
      });

  Future<Map<String, dynamic>> delete(
      String url, {
        Map<String, String>? headers,
      });
}
