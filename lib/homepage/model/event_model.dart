class NasaEvenData {
  String? title;
  String? description;
  String? link;
  List<EventsName>? events;

  NasaEvenData({this.title, this.description, this.link, this.events});

  NasaEvenData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    link = json['link'];
    if (json['events'] != null) {
      events = <EventsName>[];
      json['events'].forEach((v) {
        events!.add(EventsName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventsName {
  String? id;
  String? title;
  String? description;
  String? link;
  List<Categories>? categories;
  List<Sources>? sources;
  List<Geometries>? geometries;

  EventsName(
      {this.id,
      this.title,
      this.description,
      this.link,
      this.categories,
      this.sources,
      this.geometries});

  EventsName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['sources'] != null) {
      sources = <Sources>[];
      json['sources'].forEach((v) {
        sources!.add(Sources.fromJson(v));
      });
    }
    if (json['geometries'] != null) {
      geometries = <Geometries>[];
      json['geometries'].forEach((v) {
        geometries!.add(Geometries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (sources != null) {
      data['sources'] = sources!.map((v) => v.toJson()).toList();
    }
    if (geometries != null) {
      data['geometries'] = geometries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? title;

  Categories({this.id, this.title});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Sources {
  String? id;
  String? url;

  Sources({this.id, this.url});

  Sources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class Geometries {
  String? date;
  String? type;
  List<num>? coordinates;

  Geometries({this.date, this.type, this.coordinates});

  Geometries.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    type = json['type'];
    coordinates = (json['coordinates']).cast<num>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
