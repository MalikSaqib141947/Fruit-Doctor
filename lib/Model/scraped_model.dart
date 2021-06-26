class ScrapeModel {
  List<Data> data;

  ScrapeModel({this.data});

  ScrapeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
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
  String intro;
  String link;

  Data({this.heading, this.intro, this.link});

  Data.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    intro = json['intro'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['intro'] = this.intro;
    data['link'] = this.link;
    return data;
  }
}
