class ApiSensorDataModel {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  double? elevation;
  HourlyUnits? hourlyUnits;
  Hourly? hourly;

  ApiSensorDataModel({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.hourlyUnits,
    this.hourly,
  });

  ApiSensorDataModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    hourlyUnits = json['hourly_units'] != null
        ? HourlyUnits.fromJson(json['hourly_units'])
        : null;
    hourly =
        json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['generationtime_ms'] = generationtimeMs;
    data['utc_offset_seconds'] = utcOffsetSeconds;
    data['timezone'] = timezone;
    data['timezone_abbreviation'] = timezoneAbbreviation;
    data['elevation'] = elevation;
    if (hourlyUnits != null) {
      data['hourly_units'] = hourlyUnits!.toJson();
    }
    if (hourly != null) {
      data['hourly'] = hourly!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ApiSensorDataModel(latitude: $latitude, longitude: $longitude, generationtimeMs: $generationtimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, hourlyUnits: $hourlyUnits, hourly: $hourly)';
  }
}

class HourlyUnits {
  String? time;
  String? soilTemperature54cm;
  String? soilMoisture27To81cm;

  HourlyUnits({this.time, this.soilTemperature54cm, this.soilMoisture27To81cm});

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    soilTemperature54cm = json['soil_temperature_54cm'];
    soilMoisture27To81cm = json['soil_moisture_27_to_81cm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['soil_temperature_54cm'] = soilTemperature54cm;
    data['soil_moisture_27_to_81cm'] = soilMoisture27To81cm;
    return data;
  }

  @override
  String toString() {
    return 'HourlyUnits(time: $time, soilTemperature54cm: $soilTemperature54cm, soilMoisture27To81cm: $soilMoisture27To81cm)';
  }
}

class Hourly {
  List<String>? time;
  List<double>? soilTemperature54cm;
  List<double>? soilMoisture27To81cm;

  Hourly({this.time, this.soilTemperature54cm, this.soilMoisture27To81cm});

  Hourly.fromJson(Map<String, dynamic> json) {
    time = List<String>.from(json['time']);
    soilTemperature54cm = List<double>.from(json['soil_temperature_54cm']);
    soilMoisture27To81cm = List<double>.from(json['soil_moisture_27_to_81cm']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['soil_temperature_54cm'] = soilTemperature54cm;
    data['soil_moisture_27_to_81cm'] = soilMoisture27To81cm;
    return data;
  }

  @override
  String toString() {
    return 'Hourly(time: $time, soilTemperature54cm: $soilTemperature54cm, soilMoisture27To81cm: $soilMoisture27To81cm)';
  }
}
