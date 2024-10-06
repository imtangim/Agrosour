// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PointModel {
  String id;
  String label;
  Color color;
  LatLng position;
  String source;
  PointModel({
    required this.id,
    required this.label,
    required this.color,
    required this.position,
    required this.source,
  });
}
