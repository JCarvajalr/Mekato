import 'package:flutter/material.dart';

class FormToReservate extends StatefulWidget {
  final formKey;
  final String? initialDate;
  const FormToReservate({super.key, required this.formKey, this.initialDate});

  @override
  State<FormToReservate> createState() => _FormToReservateState();
}

class _FormToReservateState extends State<FormToReservate> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    _dateController.text = widget.initialDate ?? "";
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
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
          Row(
            children: [
              Expanded(
                child: TextFormField(
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
              ),
              SizedBox(width: 8),
              if (widget.initialDate != null &&
                  _dateController.text != widget.initialDate)
                IconButton(
                  onPressed: () {
                    _dateController.text = widget.initialDate!;
                    _safeSetState();
                  },
                  icon: Icon(Icons.refresh_outlined),
                ),
            ],
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
            validator: (value) => value!.isEmpty ? "Selecciona una hora" : null,
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
    );
  }

  void _safeSetState() {
    if (mounted) setState(() {});
  }
}
