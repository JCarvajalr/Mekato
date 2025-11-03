import 'package:flutter/material.dart';
import 'package:mekato/data/models/reservation.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/screens/reservations/edit_reversation_screen.dart';
import 'package:mekato/ui/widgets/cards/reservation_card.dart';

class ReservationsListview extends StatefulWidget {
  const ReservationsListview({super.key});

  @override
  State<ReservationsListview> createState() => _ReservationsListviewState();
}

class _ReservationsListviewState extends State<ReservationsListview> {
  ReservationsService service = ReservationsService();
  bool _isLoading = false;
  List<Reservation> _currentList = [];

  void _getReservations() async {
    _isLoading = true;
    _safeSetState();
    _currentList = await service.getReservations(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqdWFuY2FybG9zQGV4YW1wbGUuY29tIiwiZXhwIjoxNzYyMTk2NDIxfQ.umZ4qgtzNPjH89cz9Apbfg0tWQHcEb2Pt9VZfu0-jkk",
    );
    _isLoading = false;
    _safeSetState();
  }

  @override
  void initState() {
    _getReservations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reservas activas:", style: MekatoStyles.textTitle1),
        SizedBox(height: 12),
        Expanded(
          child: (_isLoading)
              ? Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  itemCount: _currentList.length,
                  itemBuilder: (context, index) {
                    return ReservationCard(
                      reservation: _currentList[index],
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditReservationScreen(
                              reservation: _currentList[index],
                              service: service,
                            ),
                          ),
                        );
                      },
                      onCancel: () {
                        // service.cancelReservation(_currentList[index].id);
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

  void _safeSetState() {
    if (mounted) setState(() {});
  }
}
