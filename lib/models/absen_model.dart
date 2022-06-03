
// ignore_for_file: non_constant_identifier_names

// ignore: duplicate_ignore
class Absen {
  int? id;
  int? user_id;
  DateTime? date;
  DateTime? start_work;
  String? start_work_info;
  String? start_work_info_url;
  DateTime? end_work;
  String? end_work_info;
  String? end_work_info_url;
  String? desc;
  User? user;

  Absen({
    this.id,
    this.user_id,
    this.date,
    this.start_work,
    this.start_work_info,
    this.start_work_info_url,
    this.end_work,
    this.end_work_info,
    this.end_work_info_url,
    this.desc,
    this.user,
  });

  Absen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    date = DateTime.parse(json['date']);
    start_work = json['start_work'] != null ? DateTime.parse(json['start_work']) : null;
    start_work_info = json['start_work_info'];
    start_work_info_url = json['start_work_info_url'];
    end_work = json['end_work'] != null ? DateTime.parse(json['end_work']) : null;
    end_work_info = json['end_work_info'];
    end_work_info_url = json['end_work_info_url'];
    desc = json['desc'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = user_id;
    data['date'] = date;
    data['start_work'] = start_work;
    data['start_work_info'] = start_work_info;
    data['start_work_info_url'] = start_work_info_url;
    data['end_work'] = end_work;
    data['end_work_info'] = end_work_info;
    data['end_work_info_url'] = end_work_info_url;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }

}

class User {
  int? id;
  String? name;
  DateTime? start_work_user;
  DateTime? end_work_user;

  User({this.id, this.name, this.start_work_user, this.end_work_user});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    start_work_user = json['start_work_user'] != null ? DateTime.parse(json['start_work_user']) : null;
    end_work_user = json['end_work_user'] != null ? DateTime.parse(json['end_work_user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['start_work_user'] = start_work_user;
    data['end_work_user'] = end_work_user;
    return data;
  }
}
