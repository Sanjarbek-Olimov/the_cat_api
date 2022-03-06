// To parse this JSON data, do
//
// final upload = uploadFromJson(jsonString);

import 'dart:convert';

Upload uploadFromJson(String str) => Upload.fromJson(json.decode(str));

String uploadToJson(Upload data) => json.encode(data.toJson());

class Upload {
  Upload({
    required this.id,
    required this.url,
    this.width,
    this.height,
    required this.originalFilename,
    required this.pending,
    required this.approved,
  });

  String id;
  String url;
  int? width;
  int? height;
  String originalFilename;
  int pending;
  int approved;

  factory Upload.fromJson(Map<String, dynamic> json) => Upload(
        id: json["id"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
        originalFilename: json["original_filename"],
        pending: json["pending"],
        approved: json["approved"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "width": width,
        "height": height,
        "original_filename": originalFilename,
        "pending": pending,
        "approved": approved,
      };
}
