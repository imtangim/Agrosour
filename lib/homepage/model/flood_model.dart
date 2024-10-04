class FloodModel {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  DailyUnits? dailyUnits;
  Daily? daily;

  FloodModel({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.dailyUnits,
    this.daily,
  });

  FloodModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    dailyUnits = json['daily_units'] != null
        ? DailyUnits.fromJson(json['daily_units'])
        : null;
    daily = json['daily'] != null ? Daily.fromJson(json['daily']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['generationtime_ms'] = generationtimeMs;
    data['utc_offset_seconds'] = utcOffsetSeconds;
    data['timezone'] = timezone;
    data['timezone_abbreviation'] = timezoneAbbreviation;
    if (dailyUnits != null) {
      data['daily_units'] = dailyUnits!.toJson();
    }
    if (daily != null) {
      data['daily'] = daily!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'FloodModel(latitude: $latitude, longitude: $longitude, generationtimeMs: $generationtimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, dailyUnits: $dailyUnits, daily: $daily)';
  }
}

class DailyUnits {
  String? time;
  String? riverDischarge;

  DailyUnits({this.time, this.riverDischarge});

  DailyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    riverDischarge = json['river_discharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['river_discharge'] = riverDischarge;
    return data;
  }

  @override
  String toString() {
    return 'DailyUnits(time: $time, riverDischarge: $riverDischarge)';
  }
}

class Daily {
  List<String>? time;
  List<double>? riverDischarge;

  Daily({this.time, this.riverDischarge});

  Daily.fromJson(Map<String, dynamic> json) {
    time = List<String>.from(json['time']);
    riverDischarge = List<double>.from(json['river_discharge']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['river_discharge'] = riverDischarge;
    return data;
  }

  @override
  String toString() {
    return 'Daily(time: $time, riverDischarge: $riverDischarge)';
  }
}
