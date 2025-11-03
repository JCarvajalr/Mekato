import 'package:flutter/widgets.dart';
import 'package:mekato/data/controllers/reservations_controller.dart';
import 'package:mekato/data/models/reservation.dart';

class ReservationsService {
  ReservationsController controller = ReservationsController();
  late VoidCallback notify = () {};

  addListener(VoidCallback l) {
    notify = l;
  }

  Future<List<Reservation>> getReservations(String token) async {
    final response = await controller.getReservations(token);
    if (response.isNotEmpty) {
      var list = response['data']['reservas'] as List;
      List<Reservation> reservations = list
          .map((e) => Reservation.fromJson(e))
          .toList();

      return reservations;
    } else {
      return [];
    }
  }

  Future<bool> createReservation(Reservation reservation, String token) async {
    final body = reservation.toJson();
    final response = await controller.createReservation(body, token);
    return response;
  }

  Future<bool> updateReservation(Reservation reservation, String token) async {
    final body = reservation.toJson();
    final response = await controller.updateReservation(
      body,
      reservation.id,
      token,
    );
    notify();
    return response;
  }

  Future<bool> cancelReservation(int id, String token) async {
    final response = await controller.cancelReservation(id, token);
    return response;
  }
}
