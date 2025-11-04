import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationsController {
  static const String baseUrl = 'http://186.183.171.16:25565/api';
  // 10.0.2.2:3000

  // GET Request
  Future<Map<String, dynamic>> getReservations(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reservas/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // POST Request
  Future<bool> createReservation(
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reservas/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  // PUT - Actualizar reserva
  Future<bool> updateReservation(
    Map<String, dynamic> data,
    int id,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/reservas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        debugPrint('Reserva no encontrada');
        return false;
      } else {
        debugPrint('Error al actualizar reserva: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión: $e');
      return false;
    }
  }

  // DELETE - Eliminar reserva
  Future<bool> cancelReservation(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/reservas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al cancelar reserva: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
