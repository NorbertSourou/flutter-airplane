
import 'dart:convert';

List<Vol> volFromJson(String str) => List<Vol>.from(json.decode(str).map((x) => Vol.fromJson(x)));

String volToJson(List<Vol> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vol {
  Vol({
    required this.icao24,
    required this.firstSeen,
    required this.estDepartureAirport,
    required this.lastSeen,
    required this.estArrivalAirport,
    required this.callsign,
    required this.estDepartureAirportHorizDistance,
    required this.estDepartureAirportVertDistance,
    required this.estArrivalAirportHorizDistance,
    required this.estArrivalAirportVertDistance,
    required this.departureAirportCandidatesCount,
    required this.arrivalAirportCandidatesCount,
  });

  String icao24;
  int firstSeen;
  String estDepartureAirport;
  int lastSeen;
  String estArrivalAirport;
  String callsign;
  int estDepartureAirportHorizDistance;
  int estDepartureAirportVertDistance;
  int estArrivalAirportHorizDistance;
  int estArrivalAirportVertDistance;
  int departureAirportCandidatesCount;
  int arrivalAirportCandidatesCount;

  factory Vol.fromJson(Map<String, dynamic> json) => Vol(
    icao24: json["icao24"],
    firstSeen: json["firstSeen"],
    estDepartureAirport: json["estDepartureAirport"],
    lastSeen: json["lastSeen"],
    estArrivalAirport: json["estArrivalAirport"],
    callsign: json["callsign"],
    estDepartureAirportHorizDistance: json["estDepartureAirportHorizDistance"],
    estDepartureAirportVertDistance: json["estDepartureAirportVertDistance"],
    estArrivalAirportHorizDistance: json["estArrivalAirportHorizDistance"],
    estArrivalAirportVertDistance: json["estArrivalAirportVertDistance"],
    departureAirportCandidatesCount: json["departureAirportCandidatesCount"],
    arrivalAirportCandidatesCount: json["arrivalAirportCandidatesCount"],
  );

  Map<String, dynamic> toJson() => {
    "icao24": icao24,
    "firstSeen": firstSeen,
    "estDepartureAirport": estDepartureAirport,
    "lastSeen": lastSeen,
    "estArrivalAirport": estArrivalAirport,
    "callsign": callsign,
    "estDepartureAirportHorizDistance": estDepartureAirportHorizDistance,
    "estDepartureAirportVertDistance": estDepartureAirportVertDistance,
    "estArrivalAirportHorizDistance": estArrivalAirportHorizDistance,
    "estArrivalAirportVertDistance": estArrivalAirportVertDistance,
    "departureAirportCandidatesCount": departureAirportCandidatesCount,
    "arrivalAirportCandidatesCount": arrivalAirportCandidatesCount,
  };
}