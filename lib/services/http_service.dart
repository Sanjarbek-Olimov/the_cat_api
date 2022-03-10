import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:the_cat_api/models/cat_model.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "api.thecatapi.com";
  static String SERVER_PRODUCTION = "api.thecatapi.com";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-api-key': '36e48b9d-cd7b-463f-8730-84c7f1106811'
    };
    return headers;
  }

  static Map<String, String> getUploadHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'x-api-key': '36e48b9d-cd7b-463f-8730-84c7f1106811'
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> MULTIPART(
      String api, String filePath, Map<String, String> body) async {
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('file', filePath,
        contentType: MediaType("image", "jpeg")));
    request.fields.addAll(body);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  static Future<String?> DELETE(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getUploadHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /* Http Apis */
  static String API_LIST = "/v1/images/search";
  static String API_GET_UPLOADS = "/v1/images/";
  static String API_UPLOAD = "/v1/images/upload";
  static String API_DELETE = "/v1/images/"; //{id}

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, String> bodyUpload() {
    Map<String, String> body = {'sub_id': ''};
    return body;
  }

  static Map<String, dynamic> paramsPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({'limit': '25', 'page': pageNumber.toString()});
    return params;
  }

  static Map<String, dynamic> paramsSearch(String search, int pageNumber) {
    Map<String, String> params = {};
    params.addAll(
        {'breed_ids': search, 'limit': '25', 'page': pageNumber.toString()});
    return params;
  }

  /* Http parsing */
  static List<Cat> parseResponse(String response) {
    List json = jsonDecode(response);
    List<Cat> photos = List<Cat>.from(json.map((x) => Cat.fromJson(x)));
    return photos;
  }
}
