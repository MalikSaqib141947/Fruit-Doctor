class InternationalNewsModel {
  List<Data> data;

  InternationalNewsModel({this.data});

  InternationalNewsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String heading;
  String img;
  String intro;
  String link;

  Data({this.heading, this.img, this.intro, this.link});

  Data.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    img = json['img'];
    intro = json['intro'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['img'] = this.img;
    data['intro'] = this.intro;
    data['link'] = this.link;
    return data;
  }
}
