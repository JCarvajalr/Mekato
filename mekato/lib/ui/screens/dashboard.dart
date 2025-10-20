import 'package:flutter/material.dart';
import 'package:mekato/ui/widgets/current_reservations_widget.dart';
import 'package:mekato/ui/widgets/menu_widget.dart';
import 'package:mekato/ui/widgets/offers_widget.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double xpadding = 20;
    final double ypadding = 14;

    return ListView(
      // mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: ypadding),
        CurrentReservationsWidget(xpadding: xpadding),
        SizedBox(height: 20),
        OffersWidget(xpadding: xpadding),
        SizedBox(height: 20),
        MenuWidget(xpadding: xpadding),
        SizedBox(height: 30),
      ],
    );
  }
}
