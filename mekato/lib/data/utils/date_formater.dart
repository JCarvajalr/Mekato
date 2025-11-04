import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormater {
  static final DateFormater _intance = DateFormater._();

  DateFormater._() {
    _init();
  }

  factory DateFormater() {
    return _intance;
  }

  String formatDate(String date) {
    DateTime fecha = DateTime.parse(date);

    String fechaFormateada = DateFormat(
      'EEEE, d MMMM y',
      'es_ES',
    ).format(fecha);
    return fechaFormateada;
  }

  void _init() async {
    await initializeDateFormatting('es_ES', null);
  }
}
