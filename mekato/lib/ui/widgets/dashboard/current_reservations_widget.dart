import 'package:flutter/material.dart';
import 'package:mekato/data/models/reservation.dart';
import 'package:mekato/data/services/auth_service.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/data/utils/date_formater.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/widgets/cards/item_card_m.dart';

class CurrentReservationsWidget extends StatefulWidget {
  final double xpadding;

  const CurrentReservationsWidget({super.key, required this.xpadding});

  @override
  State<CurrentReservationsWidget> createState() =>
      _CurrentReservationsWidgetState();
}

class _CurrentReservationsWidgetState extends State<CurrentReservationsWidget> {
  ReservationsService service = ReservationsService();
  List<Reservation> _reservations = [];
  final DateFormater _formater = DateFormater();

  @override
  void initState() {
    _initList();
    super.initState();
  }

  _initList() async {
    _reservations = await service.getReservations(AuthService().authToken);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: widget.xpadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Text("Reservas en curso", style: MekatoStyles.textTitle1),
              SizedBox(width: 20),
              Icon(Icons.arrow_right_alt_rounded, color: Colors.black),
            ],
          ),
          SizedBox(height: 8),
          _reservations.isNotEmpty ?
            SizedBox(
              height: 165,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ItemCardM(
                        imagePath: "assets/images/res.jpg",
                        title: _formater.formatDate(_reservations[index].date),
                        subtitle: _reservations[index].timeOfDay.format(
                          context,
                        ),
                      ),
                      SizedBox(width: 14),
                    ],
                  );
                },
              ),
            ) : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Ahora mismo no tienes reservas activas.", style: TextStyle(fontWeight: FontWeight.w500),),
                ],
              ),
            ),
          Text(
            "Para obtener información mas detallada usa el panel de “reservas”.",
            style: MekatoStyles.textBody,
          ),
        ],
      ),
    );
  }
}
