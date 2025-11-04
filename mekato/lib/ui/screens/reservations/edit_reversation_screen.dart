import 'package:flutter/material.dart';
import 'package:mekato/data/models/reservation.dart';
import 'package:mekato/data/services/auth_service.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/widgets/reservations/form_to_reservate.dart';

class EditReservationScreen extends StatefulWidget {
  final Reservation reservation;
  final ReservationsService service;
  const EditReservationScreen({
    super.key,
    required this.reservation,
    required this.service,
  });

  @override
  State<EditReservationScreen> createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final String _authToken = AuthService().authToken;
  final _formKey = GlobalKey<FormState>();
  late Reservation newReservation;
  @override
  void initState() {
    newReservation = Reservation(
      id: widget.reservation.id,
      userId: widget.reservation.userId,
      date: widget.reservation.date,
      time: widget.reservation.time,
      guests: widget.reservation.guests,
      comments: widget.reservation.comments,
    );
    super.initState();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.service.updateReservation(
        newReservation,
        _authToken,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.edit_calendar_rounded),
            const SizedBox(width: 8),
            const Text(
              "Modificar Reserva",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: MekatoColors.main,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FormToReservate(
                formKey: _formKey,
                reservation: widget.reservation,
                newReservation: newReservation,
              ),
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 10),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    label: const Text(
                      "Confirmar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
