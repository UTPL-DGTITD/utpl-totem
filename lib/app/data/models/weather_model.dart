// // To parse this JSON data, do
// //
// //     final weahter = weahterFromJson(jsonString);

// import 'dart:convert';

// WeatherModel weahterFromJson(String str) =>
//     WeatherModel.fromJson(json.decode(str));

// String weahterToJson(WeatherModel data) => json.encode(data.toJson());

// class WeatherModel {
//   WeatherModel({
//     this.status = 0,
//     this.location = '',
//     this.url = '',
//     this.day,
//   });

//   int status;
//   String location;
//   String url;
//   Map<String, Day>? day;

//   factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
//         status: json["status"],
//         location: json["location"],
//         url: json["url"],
//         day: Map.from(json["day"])
//             .map((k, v) => MapEntry<String, Day>(k, Day.fromJson(v))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "location": location,
//         "url": url,
//         "day": Map.from(day!)
//             .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//       };
// }

// class Day {
//   Day({
//     this.date = '',
//     this.name = '',
//     this.month = '',
//     this.symbolValue = '',
//     this.symbolDescription = '',
//     this.symbolValue2 = '',
//     this.symbolDescription2 = '',
//     this.tempmin = '',
//     this.tempmax = '',
//     this.wind,
//     this.rain = '',
//     this.humidity = '',
//     this.pressure = '',
//     this.snowline = '',
//     this.uvIndexMax = '',
//     this.sun,
//     this.moon,
//     this.units,
//     this.localTime = '',
//     this.localTimeOffset = 0,
//     this.hour,
//   });

//   String date;
//   String name;
//   String month;
//   String symbolValue;
//   String symbolDescription;
//   String symbolValue2;
//   String symbolDescription2;
//   String tempmin;
//   String tempmax;
//   Wind? wind;
//   String rain;
//   String humidity;
//   String pressure;
//   String snowline;
//   String uvIndexMax;
//   Sun? sun;
//   Moon? moon;
//   Units? units;
//   String localTime;
//   int localTimeOffset;
//   List<Hour>? hour;

//   factory Day.fromJson(Map<String, dynamic> json) => Day(
//         date: json["date"],
//         name: json["name"],
//         month: json["month"],
//         symbolValue: json["symbol_value"],
//         symbolDescription: json["symbol_description"],
//         symbolValue2: json["symbol_value2"],
//         symbolDescription2: json["symbol_description2"],
//         tempmin: json["tempmin"],
//         tempmax: json["tempmax"],
//         wind: Wind.fromJson(json["wind"]),
//         rain: json["rain"],
//         humidity: json["humidity"],
//         pressure: json["pressure"],
//         snowline: json["snowline"],
//         uvIndexMax: json["uv_index_max"],
//         sun: Sun.fromJson(json["sun"]),
//         moon: Moon.fromJson(json["moon"]),
//         units: Units.fromJson(json["units"]),
//         localTime: json["local_time"],
//         localTimeOffset: json["local_time_offset"],
//         hour: List<Hour>.from(json["hour"].map((x) => Hour.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "date": date,
//         "name": name,
//         "month": month,
//         "symbol_value": symbolValue,
//         "symbol_description": symbolDescription,
//         "symbol_value2": symbolValue2,
//         "symbol_description2": symbolDescription2,
//         "tempmin": tempmin,
//         "tempmax": tempmax,
//         "wind": wind?.toJson(),
//         "rain": rain,
//         "humidity": humidity,
//         "pressure": pressure,
//         "snowline": snowline,
//         "uv_index_max": uvIndexMax,
//         "sun": sun?.toJson(),
//         "moon": moon?.toJson(),
//         "units": units?.toJson(),
//         "local_time": localTime,
//         "local_time_offset": localTimeOffset,
//         "hour": List<dynamic>.from(hour!.map((x) => x.toJson())),
//       };
// }

// class Hour {
//   Hour({
//     this.interval = '',
//     this.temp = '',
//     this.symbolValue = '',
//     this.symbolDescription = '',
//     this.symbolValue2 = '',
//     this.symbolDescription2 = '',
//     this.wind,
//     this.rain = '',
//     this.humidity = '',
//     this.pressure = '',
//     this.clouds = '',
//     this.snowline = '',
//     this.windchill = '',
//     this.uvIndex = '',
//   });

//   String interval;
//   String temp;
//   String symbolValue;
//   String symbolDescription;
//   String symbolValue2;
//   String symbolDescription2;
//   Wind? wind;
//   String rain;
//   String humidity;
//   String pressure;
//   String clouds;
//   String snowline;
//   String windchill;
//   String uvIndex;

//   factory Hour.fromJson(Map<String, dynamic> json) => Hour(
//         interval: json["interval"],
//         temp: json["temp"],
//         symbolValue: json["symbol_value"],
//         symbolDescription: json["symbol_description"],
//         symbolValue2: json["symbol_value2"],
//         symbolDescription2: json["symbol_description2"],
//         wind: Wind.fromJson(json["wind"]),
//         rain: json["rain"],
//         humidity: json["humidity"],
//         pressure: json["pressure"],
//         clouds: json["clouds"],
//         snowline: json["snowline"],
//         windchill: json["windchill"],
//         uvIndex: json["uv_index"],
//       );

//   Map<String, dynamic> toJson() => {
//         "interval": interval,
//         "temp": temp,
//         "symbol_value": symbolValue,
//         "symbol_description": symbolDescription,
//         "symbol_value2": symbolValue2,
//         "symbol_description2": symbolDescription2,
//         "wind": wind?.toJson(),
//         "rain": rain,
//         "humidity": humidity,
//         "pressure": pressure,
//         "clouds": clouds,
//         "snowline": snowline,
//         "windchill": windchill,
//         "uv_index": uvIndex,
//       };
// }

// class Wind {
//   Wind({
//     this.speed = '',
//     this.dir = '',
//     this.symbol = '',
//     this.symbolB = '',
//     this.gusts = '',
//   });

//   String speed;
//   String dir;
//   String symbol;
//   String symbolB;
//   String gusts;

//   factory Wind.fromJson(Map<String, dynamic> json) => Wind(
//         speed: json["speed"],
//         dir: json["dir"],
//         symbol: json["symbol"],
//         symbolB: json["symbolB"],
//         gusts: json["gusts"],
//       );

//   Map<String, dynamic> toJson() => {
//         "speed": speed,
//         "dir": dir,
//         "symbol": symbol,
//         "symbolB": symbolB,
//         "gusts": gusts,
//       };
// }

// class Moon {
//   Moon({
//     this.moonIn = '',
//     this.out = '',
//     this.lumi = '',
//     this.desc = '',
//     this.symbol = '',
//   });

//   String moonIn;
//   String out;
//   String lumi;
//   String desc;
//   String symbol;

//   factory Moon.fromJson(Map<String, dynamic> json) => Moon(
//         moonIn: json["in"],
//         out: json["out"],
//         lumi: json["lumi"],
//         desc: json["desc"],
//         symbol: json["symbol"],
//       );

//   Map<String, dynamic> toJson() => {
//         "in": moonIn,
//         "out": out,
//         "lumi": lumi,
//         "desc": desc,
//         "symbol": symbol,
//       };
// }

// class Sun {
//   Sun({
//     this.sunIn = '',
//     this.mid = '',
//     this.out = '',
//   });

//   String sunIn;
//   String mid;
//   String out;

//   factory Sun.fromJson(Map<String, dynamic> json) => Sun(
//         sunIn: json["in"],
//         mid: json["mid"],
//         out: json["out"],
//       );

//   Map<String, dynamic> toJson() => {
//         "in": sunIn,
//         "mid": mid,
//         "out": out,
//       };
// }

// class Units {
//   Units({
//     this.temp = '',
//     this.wind = '',
//     this.rain = '',
//     this.pressure = '',
//     this.snowline = '',
//   });

//   String temp;
//   String wind;
//   String rain;
//   String pressure;
//   String snowline;

//   factory Units.fromJson(Map<String, dynamic> json) => Units(
//         temp: json["temp"],
//         wind: json["wind"],
//         rain: json["rain"],
//         pressure: json["pressure"],
//         snowline: json["snowline"],
//       );

//   Map<String, dynamic> toJson() => {
//         "temp": temp,
//         "wind": wind,
//         "rain": rain,
//         "pressure": pressure,
//         "snowline": snowline,
//       };
// }

// To parse this JSON data, do
//
//     final weahter = weahterFromJson(jsonString);

// import 'dart:convert';

// WeatherModel weahterFromJson(String str) =>
//     WeatherModel.fromJson(json.decode(str));

// String weahterToJson(WeatherModel data) => json.encode(data.toJson());

// class WeatherModel {
//   WeatherModel({
//     this.status = 0,
//     this.location = '',
//     this.url = '',
//     this.day,
//   });

//   int status;
//   String location;
//   String url;
//   Map<String, Day>? day;

//   factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
//         status: json["status"],
//         location: json["location"],
//         url: json["url"],
//         day: Map.from(json["day"])
//             .map((k, v) => MapEntry<String, Day>(k, Day.fromJson(v))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "location": location,
//         "url": url,
//         "day": Map.from(day!)
//             .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//       };
// }

// class Day {
//   Day({
//     required this.date,
//     required this.name,
//     required this.month,
//     required this.symbolValue,
//     required this.symbolDescription,
//     required this.symbolValue2,
//     required this.symbolDescription2,
//     required this.tempmin,
//     required this.tempmax,
//     required this.wind,
//     required this.rain,
//     required this.humidity,
//     required this.pressure,
//     required this.snowline,
//     required this.uvIndexMax,
//     required this.sun,
//     required this.moon,
//     required this.units,
//     required this.localTime,
//     required this.localTimeOffset,
//     required this.hour,
//   });

//   String date;
//   String name;
//   String month;
//   String symbolValue;
//   String symbolDescription;
//   String symbolValue2;
//   String symbolDescription2;
//   String tempmin;
//   String tempmax;
//   Wind wind;
//   String rain;
//   String humidity;
//   String pressure;
//   String snowline;
//   String uvIndexMax;
//   Sun sun;
//   Moon moon;
//   Units units;
//   String localTime;
//   int localTimeOffset;
//   List<Hour> hour;

//   factory Day.fromJson(Map<String, dynamic> json) => Day(
//         date: json["date"],
//         name: json["name"],
//         month: json["month"],
//         symbolValue: json["symbol_value"],
//         symbolDescription: json["symbol_description"],
//         symbolValue2: json["symbol_value2"],
//         symbolDescription2: json["symbol_description2"],
//         tempmin: json["tempmin"],
//         tempmax: json["tempmax"],
//         wind: Wind.fromJson(json["wind"]),
//         rain: json["rain"],
//         humidity: json["humidity"],
//         pressure: json["pressure"],
//         snowline: json["snowline"],
//         uvIndexMax: json["uv_index_max"],
//         sun: Sun.fromJson(json["sun"]),
//         moon: Moon.fromJson(json["moon"]),
//         units: Units.fromJson(json["units"]),
//         localTime: json["local_time"],
//         localTimeOffset: json["local_time_offset"],
//         hour: List<Hour>.from(json["hour"].map((x) => Hour.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "date": date,
//         "name": name,
//         "month": month,
//         "symbol_value": symbolValue,
//         "symbol_description": symbolDescription,
//         "symbol_value2": symbolValue2,
//         "symbol_description2": symbolDescription2,
//         "tempmin": tempmin,
//         "tempmax": tempmax,
//         "wind": wind.toJson(),
//         "rain": rain,
//         "humidity": humidity,
//         "pressure": pressure,
//         "snowline": snowline,
//         "uv_index_max": uvIndexMax,
//         "sun": sun.toJson(),
//         "moon": moon.toJson(),
//         "units": units.toJson(),
//         "local_time": localTime,
//         "local_time_offset": localTimeOffset,
//         "hour": List<dynamic>.from(hour.map((x) => x.toJson())),
//       };
// }

// class Hour {
//   Hour({
//     required this.interval,
//     required this.temp,
//     required this.symbolValue,
//     required this.symbolDescription,
//     required this.symbolValue2,
//     required this.symbolDescription2,
//     required this.wind,
//     required this.rain,
//     required this.humidity,
//     required this.pressure,
//     required this.clouds,
//     required this.snowline,
//     required this.windchill,
//     required this.uvIndex,
//   });

//   String interval;
//   String temp;
//   String symbolValue;
//   String symbolDescription;
//   String symbolValue2;
//   String symbolDescription2;
//   Wind wind;
//   String rain;
//   String humidity;
//   String pressure;
//   String clouds;
//   String snowline;
//   String windchill;
//   String uvIndex;

//   factory Hour.fromJson(Map<String, dynamic> json) => Hour(
//         interval: json["interval"],
//         temp: json["temp"],
//         symbolValue: json["symbol_value"],
//         symbolDescription: json["symbol_description"],
//         symbolValue2: json["symbol_value2"],
//         symbolDescription2: json["symbol_description2"],
//         wind: Wind.fromJson(json["wind"]),
//         rain: json["rain"],
//         humidity: json["humidity"],
//         pressure: json["pressure"],
//         clouds: json["clouds"],
//         snowline: json["snowline"],
//         windchill: json["windchill"],
//         uvIndex: json["uv_index"],
//       );

//   Map<String, dynamic> toJson() => {
//         "interval": interval,
//         "temp": temp,
//         "symbol_value": symbolValue,
//         "symbol_description": symbolDescription,
//         "symbol_value2": symbolValue2,
//         "symbol_description2": symbolDescription2,
//         "wind": wind.toJson(),
//         "rain": rain,
//         "humidity": humidity,
//         "pressure": pressure,
//         "clouds": clouds,
//         "snowline": snowline,
//         "windchill": windchill,
//         "uv_index": uvIndex,
//       };
// }

// class Wind {
//   Wind({
//     required this.speed,
//     this.dir,
//     required this.symbol,
//     required this.symbolB,
//     required this.gusts,
//   });

//   String speed;
//   String? dir;
//   String symbol;
//   String symbolB;
//   String gusts;

//   factory Wind.fromJson(Map<String, dynamic> json) => Wind(
//         speed: json["speed"],
//         dir: json["dir"],
//         symbol: json["symbol"],
//         symbolB: json["symbolB"],
//         gusts: json["gusts"],
//       );

//   Map<String, dynamic> toJson() => {
//         "speed": speed,
//         "dir": dir,
//         "symbol": symbol,
//         "symbolB": symbolB,
//         "gusts": gusts,
//       };
// }

// class Moon {
//   Moon({
//     required this.moonIn,
//     required this.out,
//     required this.lumi,
//     required this.desc,
//     required this.symbol,
//   });

//   String moonIn;
//   String out;
//   String lumi;
//   String desc;
//   String symbol;

//   factory Moon.fromJson(Map<String, dynamic> json) => Moon(
//         moonIn: json["in"],
//         out: json["out"],
//         lumi: json["lumi"],
//         desc: json["desc"],
//         symbol: json["symbol"],
//       );

//   Map<String, dynamic> toJson() => {
//         "in": moonIn,
//         "out": out,
//         "lumi": lumi,
//         "desc": desc,
//         "symbol": symbol,
//       };
// }

// class Sun {
//   Sun({
//     required this.sunIn,
//     required this.mid,
//     required this.out,
//   });

//   String sunIn;
//   String mid;
//   String out;

//   factory Sun.fromJson(Map<String, dynamic> json) => Sun(
//         sunIn: json["in"],
//         mid: json["mid"],
//         out: json["out"],
//       );

//   Map<String, dynamic> toJson() => {
//         "in": sunIn,
//         "mid": mid,
//         "out": out,
//       };
// }

// class Units {
//   Units({
//     required this.temp,
//     required this.wind,
//     required this.rain,
//     required this.pressure,
//     required this.snowline,
//   });

//   String temp;
//   String wind;
//   String rain;
//   String pressure;
//   String snowline;

//   factory Units.fromJson(Map<String, dynamic> json) => Units(
//         temp: json["temp"],
//         wind: json["wind"],
//         rain: json["rain"],
//         pressure: json["pressure"],
//         snowline: json["snowline"],
//       );

//   Map<String, dynamic> toJson() => {
//         "temp": temp,
//         "wind": wind,
//         "rain": rain,
//         "pressure": pressure,
//         "snowline": snowline,
//       };
// }

// To parse this JSON data, do
//
//     final weatherModel = weatherModelFromJson(jsonString);

import 'dart:convert';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  WeatherModel({
    this.day,
    this.tempMax,
    this.tempMin,
    this.description,
    this.hours,
  });

  String? day = '';
  String? tempMax = '';
  String? tempMin = '';
  String? description = '';
  List<Hour>? hours = [];

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        day: json["day"],
        tempMax: json["temp_max"],
        tempMin: json["temp_min"],
        description: json["description"],
        hours: List<Hour>.from(json["hours"].map((x) => Hour.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "temp_max": tempMax,
        "temp_min": tempMin,
        "description": description,
        "hours": List<dynamic>.from(hours!.map((x) => x.toJson())),
      };
}

class Hour {
  Hour({
    required this.interval,
    required this.temp,
    required this.symbolValue,
    required this.symbolDescription,
    required this.symbolValue2,
    required this.symbolDescription2,
    required this.wind,
    required this.rain,
    required this.humidity,
    required this.pressure,
    required this.clouds,
    required this.snowline,
    required this.windchill,
    required this.uvIndex,
  });

  String interval;
  String temp;
  String symbolValue;
  String symbolDescription;
  String symbolValue2;
  String symbolDescription2;
  Wind wind;
  String rain;
  String humidity;
  String pressure;
  String clouds;
  String snowline;
  String windchill;
  String uvIndex;

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
        interval: json["interval"],
        temp: json["temp"],
        symbolValue: json["symbol_value"],
        symbolDescription: json["symbol_description"],
        symbolValue2: json["symbol_value2"],
        symbolDescription2: json["symbol_description2"],
        wind: Wind.fromJson(json["wind"]),
        rain: json["rain"],
        humidity: json["humidity"],
        pressure: json["pressure"],
        clouds: json["clouds"],
        snowline: json["snowline"],
        windchill: json["windchill"],
        uvIndex: json["uv_index"],
      );

  Map<String, dynamic> toJson() => {
        "interval": interval,
        "temp": temp,
        "symbol_value": symbolValue,
        "symbol_description": symbolDescription,
        "symbol_value2": symbolValue2,
        "symbol_description2": symbolDescription2,
        "wind": wind.toJson(),
        "rain": rain,
        "humidity": humidity,
        "pressure": pressure,
        "clouds": clouds,
        "snowline": snowline,
        "windchill": windchill,
        "uv_index": uvIndex,
      };
}

class Wind {
  Wind({
    required this.speed,
    required this.dir,
    required this.symbol,
    required this.symbolB,
    required this.gusts,
  });

  String speed;
  String dir;
  String symbol;
  String symbolB;
  String gusts;

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"],
        dir: json["dir"],
        symbol: json["symbol"],
        symbolB: json["symbolB"],
        gusts: json["gusts"],
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "dir": dir,
        "symbol": symbol,
        "symbolB": symbolB,
        "gusts": gusts,
      };
}
