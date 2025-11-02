import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/screens/reservations/edit_reversation_screen.dart';
import 'package:mekato/ui/widgets/cards/reservation_card.dart';

class ReservationsListview extends StatefulWidget {
  const ReservationsListview({super.key});

  @override
  State<ReservationsListview> createState() => _ReservationsListviewState();
}

class _ReservationsListviewState extends State<ReservationsListview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reservas activas:", style: MekatoStyles.textTitle1),
        SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return ReservationCard(
                date: "5 de Noviembre, 2025",
                time: "7:30 PM",
                guests: 2,
                location: "Cra 10 #25-80, Bogotá",
                onEdit: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReservationScreen(),
                      ),
                    );
                },
                onCancel: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reserva cancelada')),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
