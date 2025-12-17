import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../models/task.dart';
import '../models/task_status_count.dart';

class ApiService {
  // ================= TOKEN =================
  static Future<String?> _getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  // ================= REGISTRATION =================
  static Future<bool> register({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("${AppConstants.baseUrl}/Registration"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email.trim(),
        "firstName": firstName.trim(),
        "lastName": lastName.trim(),
        "mobile": mobile.trim(),
        "password": password.trim(),
      }),
    );

    print("REGISTER RESPONSE: ${res.body}");

    final data = jsonDecode(res.body);
    return data['status'] == "success";
  }

  // ================= LOGIN =================
  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("${AppConstants.baseUrl}/Login"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    print("LOGIN RESPONSE: ${res.body}");

    final data = jsonDecode(res.body);

    if (data['status'] == "success") {
      final pref = await SharedPreferences.getInstance();
      await pref.setString('token', data['token']);
      return true;
    }
    return false;
  }

  // ================= CREATE TASK =================
  static Future<bool> createTask(String title, String description) async {
    final token = await _getToken();

    final res = await http.post(
      Uri.parse("${AppConstants.baseUrl}/createTask"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "token": token!,
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "status": "New",
      }),
    );

    final data = jsonDecode(res.body);
    return data['status'] == "success";
  }

  // ================= TASK LIST =================
  static Future<List<Task>> listTaskByStatus(String status) async {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse("${AppConstants.baseUrl}/listTaskByStatus/$status"),
      headers: {
        "Accept": "application/json",
        "token": token!,
      },
    );

    final data = jsonDecode(res.body);
    return (data['data'] as List)
        .map((e) => Task.fromJson(e))
        .toList();
  }

  // ================= UPDATE TASK STATUS =================
  static Future<void> updateTaskStatus(String id, String status) async {
    final token = await _getToken();

    await http.get(
      Uri.parse("${AppConstants.baseUrl}/updateTaskStatus/$id/$status"),
      headers: {
        "Accept": "application/json",
        "token": token!,
      },
    );
  }

  // ================= DELETE TASK =================
  static Future<void> deleteTask(String id) async {
    final token = await _getToken();

    await http.get(
      Uri.parse("${AppConstants.baseUrl}/deleteTask/$id"),
      headers: {
        "Accept": "application/json",
        "token": token!,
      },
    );
  }

  // ================= TASK STATUS COUNT =================
  static Future<List<TaskStatusCount>> taskStatusCount() async {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse("${AppConstants.baseUrl}/taskStatusCount"),
      headers: {
        "Accept": "application/json",
        "token": token!,
      },
    );

    final data = jsonDecode(res.body);
    return (data['data'] as List)
        .map((e) => TaskStatusCount.fromJson(e))
        .toList();
  }
}
