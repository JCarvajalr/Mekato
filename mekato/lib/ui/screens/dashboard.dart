import 'package:flutter/material.dart';
import 'package:mekato/ui/widgets/dashboard/current_reservations_widget.dart';
import 'package:mekato/ui/widgets/dashboard/menu_widget.dart';
import 'package:mekato/ui/widgets/dashboard/offers_widget.dart';

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
        SizedBox(height: 10),
        OffersWidget(xpadding: xpadding),
        SizedBox(height: 10),
        MenuWidget(xpadding: xpadding),
        SizedBox(height: 30),
      ],
    );
  }
}
