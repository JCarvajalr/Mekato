import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/widgets/reservations/form_to_reservate.dart';

class EditReservationScreen extends StatefulWidget {
  const EditReservationScreen({super.key});

  @override
  State<EditReservationScreen> createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reserva modificada exitosamente 🎉")),
      );
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
                initialDate: "5/11/2025",
              ),
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 10),
            width: double.infinity,
            child: Row(
              children: [
                // TextButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   style: ButtonStyle(
                //     padding: WidgetStatePropertyAll(
                //       const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                //     ),
                //     foregroundColor: WidgetStatePropertyAll(Colors.redAccent),
                //     shape: WidgetStatePropertyAll(
                //       RoundedRectangleBorder(
                //         side: BorderSide(color: Colors.redAccent, width: 2),
                //         borderRadius: BorderRadiusGeometry.circular(12),
                //       ),
                //     ),
                //   ),
                //   child: Text("Cancelar"),
                // ),
                // SizedBox(width: 12),
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
