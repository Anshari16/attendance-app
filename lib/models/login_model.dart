// ignore: file_names
// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.success,
        this.data,
        this.pesan,
    });

    bool? success;
    Data? data;
    String? pesan;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        data : Data.fromJson(json["data"]),
        pesan: json["pesan"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "pesan": pesan,
    };
}

class Data {
    Data({
        required this.user,
        required this.token,
    });

    User user;
    String token;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
    };
}

class User {
    User({
        this.id,
        this.name,
        this.nik,
        this.latitude,
        this.longitude,
        this.accessBy,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? name;
    String? nik;
    String? latitude;
    String? longitude;
    String? accessBy;
    String? email;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nik: json["nik"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        accessBy: json["access_by"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nik": nik,
        "latitude": latitude,
        "longitude": longitude,
        "access_by": accessBy,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
