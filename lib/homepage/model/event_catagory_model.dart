class NasaEventCatagoryData {
  String? title;
  String? description;
  String? link;
  List<CataCatagories>? categories;

  NasaEventCatagoryData(
      {this.title, this.description, this.link, this.categories});

  NasaEventCatagoryData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    link = json['link'];
    if (json['categories'] != null) {
      categories = <CataCatagories>[];
      json['categories'].forEach((v) {
        categories!.add(CataCatagories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CataCatagories {
  int? id;
  String? title;
  String? link;
  String? description;
  String? layers;

  CataCatagories(
      {this.id, this.title, this.link, this.description, this.layers});

  CataCatagories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    description = json['description'];
    layers = json['layers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['link'] = link;
    data['description'] = description;
    data['layers'] = layers;
    return data;
  }
}
