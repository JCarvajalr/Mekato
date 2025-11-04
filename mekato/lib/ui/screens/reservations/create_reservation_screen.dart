import 'package:flutter/material.dart';
import 'package:mekato/data/models/reservation.dart';
import 'package:mekato/data/services/auth_service.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/widgets/reservations/form_to_reservate.dart';

class CreateReservationScreen extends StatefulWidget {
  final ReservationsService service;
  const CreateReservationScreen({super.key, required this.service});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final String _authToken = AuthService().authToken;
  final _formKey = GlobalKey<FormState>();
  late Reservation newReservation;

  @override
  void initState() {
    newReservation = Reservation(
      id: 1,
      userId: 1,
      date: "",
      time: "",
      guests: 0,
    );
    super.initState();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.service.createReservation(newReservation, _authToken);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.add_box_rounded),
            const SizedBox(width: 8),
            const Text(
              "Crear Reserva",
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
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.redAccent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        side: BorderSide(color: Colors.redAccent, width: 2),
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                    ),
                  ),
                  child: Text("Cancelar"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    label: const Text(
                      "Confirmar Reserva",
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
                      backgroundColor: Colors.green,
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
