class Ban {
  final String id;
  final String imageurl;
  final String linkpath;
  final bool active;

  Ban(
      {required this.id,
      required this.imageurl,
      required this.linkpath,
      required this.active
    });

  factory Ban.fromJson(Map<String, dynamic> json) {
    return Ban(
      id: json['id'] ?? '',
      imageurl: json['imageurl'] ?? '',
      linkpath: json['linkpath'] ?? '',
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['imageurl'] = imageurl;
    data['linkpath'] = linkpath;
    data['active'] = active;
    return data;
  }
}
