import 'package:flutter/material.dart';

class Reservation {
  int id;
  int userId;
  String date;
  String time;
  int guests;
  String comments;
  late DateTime dateTime;
  late TimeOfDay timeOfDay;

  Reservation({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.guests,
    this.comments = "",
  }) {
    dateTime = DateTime.parse(date);
    _stringToTimeOfDay(time);
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      date: json['fecha_reserva'],
      time: json['hora_reserva'],
      guests: json['num_personas'],
      comments: json['comentarios'],
      id: json['id_reserva'],
      userId: json['id_usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha_reserva': date,
      'hora_reserva': time,
      'num_personas': guests,
      'comentarios': comments,
    };
  }

  String getFormatedDate() {
    String formated = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return formated;
  }

  void _stringToTimeOfDay(String time) {
    final parts = time.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    timeOfDay = TimeOfDay(hour: hour, minute: minute);
  }
}
