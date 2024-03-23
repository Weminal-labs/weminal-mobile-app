import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weminal_app/models/topic_model.dart';
import 'package:weminal_app/utilities/page_response.dart';

class ApiService {
  static const String _token =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkY0U25PSlJsZUc2OVFkUHZCNzhocCJ9.eyJpc3MiOiJodHRwczovL3F1aXpsZXQuanAuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTA4MDEyNjE5MzA2MzAyNTU4OTUyIiwiYXVkIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImh0dHBzOi8vcXVpemxldC5qcC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzExMTk1MzY3LCJleHAiOjE3MTEyODE3NjcsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJhenAiOiJmSkI5Tk5BUmQ3bTlqdUxGR2JDYTdybHBXcGcwd3V1biIsInBlcm1pc3Npb25zIjpbXX0.mwlnU0YU6oGwxg1zwIv13XrUK7lTQNLTHo-JtZIdTEEITMXnE-L8YtJxoV1Sz8VUqnhis6uLcmKokDya9qeFvCfV30GiXMi7pFzsHnFnKuWO5h--m6rwt1i-ZxRlwsfqdS5NI-2BeDS4GsuIrBE-ZhecIUinn2LYwhWsEjGY2NLQEbOsLfXiVSmRlLQsRk1zKGzhph96rJEp_99tAj08eaxL0A4gmekR4ACFwDdV7mAbALr1Cy0RDi_cZNPpvxXBB2SbLr6R05hTfe68aROFygt2tr1ysuqM3Ho_odTqEqaZrn7PBgEPMBznBZw8PXkbHg0R7kzxDznLkpzxGragfg';
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };
  static String baseUrl = 'http://10.0.2.2:8080/api/v1/';
  static Future<PageResponse> getPageTopic() async {
    var res = await http.get(Uri.parse('${baseUrl}topics'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      if (kDebugMode) {
        print(response);
      }
      return PageResponse.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  static Future<TopicModel> addTopic(TopicModel topicModel) async {
    var res = await http.post(Uri.parse('${baseUrl}topics'),
        headers: headers, body: jsonEncode(topicModel.toJson()));
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return TopicModel.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }
}
