// To parse this JSON data, do
//
//     final uploads = uploadsFromJson(jsonString);

import 'dart:convert';

List<Uploads> uploadsFromJson(String str) =>
    List<Uploads>.from(json.decode(str).map((x) => Uploads.fromJson(x)));

String uploadsToJson(List<Uploads> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Uploads {
  Uploads({
    required this.breeds,
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    required this.subId,
    required this.createdAt,
    required this.originalFilename,
    this.breedIds,
  });

  List<dynamic> breeds;
  String id;
  String url;
  int width;
  int height;
  String subId;
  DateTime createdAt;
  String originalFilename;
  dynamic breedIds;

  factory Uploads.fromJson(Map<String, dynamic> json) => Uploads(
        breeds: json["breeds"].isEmpty
            ? []
            : List<dynamic>.from(json["breeds"].map((x) => x)),
        id: json["id"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
        subId: json["sub_id"],
        createdAt: DateTime.parse(json["created_at"]),
        originalFilename: json["original_filename"],
        breedIds: json["breed_ids"],
      );

  Map<String, dynamic> toJson() => {
        "breeds": List<dynamic>.from(breeds.map((x) => x)),
        "id": id,
        "url": url,
        "width": width,
        "height": height,
        "sub_id": subId,
        "created_at": createdAt.toIso8601String(),
        "original_filename": originalFilename,
        "breed_ids": breedIds,
      };
}
