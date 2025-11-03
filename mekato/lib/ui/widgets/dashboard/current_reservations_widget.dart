import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/widgets/cards/item_card_m.dart';

class CurrentReservationsWidget extends StatelessWidget {
  final double xpadding;

  const CurrentReservationsWidget({super.key, required this.xpadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: xpadding),
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
          SizedBox(height: 15),
          SizedBox(
            height: 165,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    ItemCardM(
                      imagePath: "assets/images/res.jpg",
                      title: "Miercoles 22 de octubre",
                      subtitle: "22/10/2025",
                    ),
                    SizedBox(width: 14),
                  ],
                );
              },
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
