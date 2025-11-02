import 'package:flutter/material.dart';
import 'package:mekato/ui/screens/reservations/create_reservation_screen.dart';
import 'package:mekato/ui/widgets/buttons/gradient_button.dart';
import 'package:mekato/ui/widgets/reservations/reservations_listview.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});
  final double xpadding = 20;
  final double ypadding = 14;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: xpadding, vertical: ypadding),
      child: Column(
        children: [
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  iconB: Icons.date_range,
                  labelB: 'Crear nueva reserva',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateReservationScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 26),
          Expanded(child: ReservationsListview()),
        ],
      ),
    );
  }
}
