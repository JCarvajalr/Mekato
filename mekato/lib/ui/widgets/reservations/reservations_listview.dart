import 'package:flutter/material.dart';
import 'package:mekato/data/models/reservation.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/screens/reservations/edit_reversation_screen.dart';
import 'package:mekato/ui/widgets/cards/reservation_card.dart';

class ReservationsListview extends StatefulWidget {
  final ReservationsService service;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqdWFuY2FybG9zQGV4YW1wbGUuY29tIiwiZXhwIjoxNzYyMjAyMTA3fQ.QEdxy4NThYIxSALajVH4Ask2LDxSxaiH4BwcCgpR_n0";
  const ReservationsListview({super.key, required this.service});

  @override
  State<ReservationsListview> createState() => _ReservationsListviewState();
}

class _ReservationsListviewState extends State<ReservationsListview> {
  bool _isLoading = false;
  List<Reservation> _currentList = [];

  void _getReservations() async {
    _isLoading = true;
    _safeSetState();
    _currentList = await widget.service.getReservations(widget.token);
    _isLoading = false;
    _safeSetState();
  }

  @override
  void initState() {
    _getReservations();
    widget.service.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    widget.service.addListener(() {});
    super.dispose();
  }

  void update() {
    _getReservations();
    _safeSetState();
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
                              service: widget.service,
                            ),
                          ),
                        );
                      },
                      onCancel: _cancelReservation,
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _cancelReservation(int id) async {
    await widget.service.cancelReservation(id, widget.token);
    await Future.delayed(Duration(seconds: 1));
    update();
  }

  void _safeSetState() {
    if (mounted) setState(() {});
  }
}
