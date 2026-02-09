import 'dart:convert';

enum QueryParamTypes { args }

class QueryParamsUtils {
  static String encodeParamContent(String content) {
    return base64Url.encode(utf8.encode(content));
  }

  static String? decodeParamContent(String? content) {
    if (content == null) return null;
    try {
      String result = utf8.decode(base64Url.decode(content));
      return result;
    } catch (e) {
      return null;
    }
  }
}
