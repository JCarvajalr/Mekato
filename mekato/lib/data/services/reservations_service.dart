import 'package:mekato/data/controllers/reservations_controller.dart';
import 'package:mekato/data/models/reservation.dart';

class ReservationsService {
  ReservationsController controller = ReservationsController();

  Future<List<Reservation>> getReservations(String token) async {
    final response = await controller.getReservations(token);
    if (response.isNotEmpty) {
      // response = response['data']['reservas'];

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
    print("Update: ");
    print(body);
    final response = await controller.updateReservation(
      body,
      reservation.id,
      token,
    );
    return response;
  }
}
