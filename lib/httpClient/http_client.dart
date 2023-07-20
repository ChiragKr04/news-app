import "dart:convert";
import "dart:developer";
import "package:http/http.dart" as http;

class HttpClient {
  /// Multiple api keys for fail safe if any key gets exhausted
  final List<String> apiKeys = [
    "012eb44829354db794d0dce210214d30",
    "8c172569db9c4be2a6e20e2c7e2e3cbf",
    "a04505ca94934bfda99742064f06dc1d",
    "ebdbdbeff585400bbb09813ec48b68d0",
  ];
  int _currentApiKeyIndex = 0;

  Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "X-Api-Key": apiKeys[_currentApiKeyIndex],
        ...?headers,
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401 && _isApiKeyError(response)) {
      // Handle invalid or exhausted API key error
      bool switched = _switchApiKey();
      if (switched) {
        // Retry the request with the new API key
        return get(url: url, headers: headers);
      } else {
        // All API keys exhausted, return the response as it is.
        return response;
      }
    } else {
      // Handle other status codes or errors if needed
      return response;
    }
  }

  bool _isApiKeyError(http.Response response) {
    try {
      var body = jsonDecode(response.body);
      return body['status'] == 'error' ||
          (body['code'] == 'apiKeyInvalid' ||
              body['code'] == 'apiKeyExhausted');
    } catch (e) {
      return false;
    }
  }

  bool _switchApiKey() {
    if (_currentApiKeyIndex < apiKeys.length - 1) {
      _currentApiKeyIndex++;
      return true;
    } else {
      // All API keys exhausted
      log("All API key exhausted");
      return false;
    }
  }
}
