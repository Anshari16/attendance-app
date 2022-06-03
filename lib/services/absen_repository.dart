import 'dart:convert';

import 'package:absen/models/absen_model.dart';
import 'package:absen/services/repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AbsenRepository implements Repository {
  @override
  Future<List<Absen>> getAbsen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var access = pref.getString('access_by');
    var token = pref.getString('token');
    var id = pref.getInt('id').toString();
    List<Absen> absenList = [];
    // String absenURL = 'http://10.0.2.2:8000/api/index/$id';
    if (access == 'public') {
      String absenURL = 'https://bskp.co.id/bskp_attendance/public/api/index/$id';
      var url = Uri.parse(absenURL);
      var response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // ignore: avoid_print
      print('status code : ${response.statusCode}');
      var body = json.decode(response.body)['absen'];
      for (var i = 0; i < body.length; i++) {
        absenList.add(Absen.fromJson(body[i]));
      }
      return absenList;
    } else {
      String absenURL = 'http://192.168.99.6:8000/api/index/$id';
      var url = Uri.parse(absenURL);
      var response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // ignore: avoid_print
      print('status code : ${response.statusCode}');
      var body = json.decode(response.body)['absen'];
      for (var i = 0; i < body.length; i++) {
        absenList.add(Absen.fromJson(body[i]));
      }
      return absenList;
    }
  }
}
