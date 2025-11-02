import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';

class CreateReservationScreen extends StatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reserva creada exitosamente 🎉")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Reserva",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: MekatoColors.main,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detalles de la reserva",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Fecha",
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: _pickDate,
                      validator: (value) =>
                          value!.isEmpty ? "Selecciona una fecha" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Hora",
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: _pickTime,
                      validator: (value) =>
                          value!.isEmpty ? "Selecciona una hora" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _guestsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Número de personas",
                        prefixIcon: const Icon(Icons.people),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Ingresa un número";
                        final n = int.tryParse(value);
                        if (n == null || n <= 0) return "Debe ser mayor que 0";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Comentarios adicionales',
                        hintText: 'Escribe aquí tus comentarios...',
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: TextStyle(color: Colors.black38),
                      ),
                    ),
                  ],
                ),
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
                    // icon: const Icon(Icons.check_circle_outline),
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
