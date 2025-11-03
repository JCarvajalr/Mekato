import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mekato/data/models/reservation.dart';

class FormToReservate extends StatefulWidget {
  final Key formKey;
  final Reservation? reservation;
  Reservation newReservation;
  FormToReservate({
    super.key,
    required this.formKey,
    this.reservation,
    required this.newReservation,
  });

  @override
  State<FormToReservate> createState() => _FormToReservateState();
}

class _FormToReservateState extends State<FormToReservate> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  late Reservation newReserve;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      _dateController.text = widget.reservation!.getFormatedDate();
      selectedDate = widget.reservation!.dateTime;
      selectedTime = widget.reservation!.timeOfDay;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _timeController.text = widget.reservation!.timeOfDay.format(context);
      });
      _guestsController.text = "${widget.reservation!.guests}";
      _commentsController.text = widget.reservation!.comments;

      // widget.newReservation.id = widget.reservation!.id;
      // widget.newReservation.userId = widget.reservation!.userId;
    }
  }

  void _initTime() {
    selectedTime = widget.reservation!.timeOfDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timeController.text = widget.reservation!.timeOfDay.format(context);
    });
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
      final month = selectedDate!.month.toString().padLeft(2, '0');
      final day = selectedDate!.day.toString().padLeft(2, '0');
      widget.newReservation.date = "${selectedDate!.year}-$month-$day";
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
        widget.newReservation.time = _timeOfDayToString(selectedTime!);
        _timeController.text = picked.format(context);
      });
    }
  }

  String _timeOfDayToString(TimeOfDay time) {
    final hourStr = time.hour.toString().padLeft(2, '0');
    final minuteStr = time.minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr:00'; // segundos fijos en "00"
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
              if (widget.reservation != null &&
                  _dateController.text != widget.reservation!.getFormatedDate())
                IconButton(
                  onPressed: () {
                    _dateController.text = widget.reservation!
                        .getFormatedDate();
                    selectedDate = widget.reservation!.dateTime;
                    final month = selectedDate!.month.toString().padLeft(
                      2,
                      '0',
                    );
                    final day = selectedDate!.day.toString().padLeft(2, '0');
                    widget.newReservation.date =
                        "${selectedDate!.year}-$month-$day";
                    _safeSetState();
                  },
                  icon: Icon(Icons.refresh_outlined),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
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
              ),
              SizedBox(width: 8),
              if (widget.reservation != null &&
                  _timeController.text !=
                      widget.reservation!.timeOfDay.format(context))
                IconButton(
                  onPressed: () {
                    _timeController.text = widget.reservation!.timeOfDay.format(
                      context,
                    );
                    selectedTime = widget.reservation!.timeOfDay;
                    widget.newReservation.time = _timeOfDayToString(
                      selectedTime!,
                    );
                    _safeSetState();
                  },
                  icon: Icon(Icons.refresh_outlined),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _guestsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Solo dígitos
                  ],
                  decoration: InputDecoration(
                    labelText: "Número de personas",
                    prefixIcon: const Icon(Icons.people),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (String text) {
                    int t;
                    if (text.isNotEmpty) {
                      t = int.parse(text);
                    } else {
                      t = 0;
                    }
                    widget.newReservation.guests = t;
                  },
                  validator: (value) {
                    if (value!.isEmpty) return "Ingresa un número";
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) return "Debe ser mayor que 0";
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8),
              if (widget.reservation != null &&
                  _guestsController.text != "${widget.reservation!.guests}")
                IconButton(
                  onPressed: () {
                    _guestsController.text = "${widget.reservation!.guests}";
                    widget.newReservation.guests = widget.reservation!.guests;
                    _safeSetState();
                  },
                  icon: Icon(Icons.refresh_outlined),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _commentsController,
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
                  onChanged: (String text) {
                    widget.newReservation.comments = text;
                  },
                ),
              ),
              SizedBox(width: 8),
              if (widget.reservation != null &&
                  _commentsController.text != widget.reservation!.comments)
                IconButton(
                  onPressed: () {
                    _commentsController.text = widget.reservation!.comments;
                    widget.newReservation.comments =
                        widget.reservation!.comments;
                    _safeSetState();
                  },
                  icon: Icon(Icons.refresh_outlined),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _safeSetState() {
    if (mounted) setState(() {});
  }
}
