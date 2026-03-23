// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5233';
  // Nếu dùng Android emulator, thay bằng: http://10.0.2.2:5233
  // Nếu dùng điện thoại thật, thay bằng IP máy tính: http://192.168.x.x:5233

  static Map<String, dynamic>? _currentUser;

  static Map<String, dynamic>? get currentUser => _currentUser;

  // Lưu user vào local
  static Future<void> saveUserToLocal(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
    _currentUser = user;
  }

  // Load user từ local
  static Future<Map<String, dynamic>?> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      _currentUser = jsonDecode(userStr);
      return _currentUser;
    }
    return null;
  }

  // Xóa user (đăng xuất)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _currentUser = null;
  }

  // Đăng nhập
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveUserToLocal(data);
        return data;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Đăng ký
  static Future<Map<String, dynamic>?> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveUserToLocal(data);
        return data;
      }
      return null;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // Lấy thông tin user
  static Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  // Các API khác giữ nguyên...
  static Future<List<dynamic>> getCoffeeShops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/coffeeshops'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getTrendingShops({int limit = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/coffeeshops/trending?limit=$limit'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getCoffeeShopDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/coffeeshops/$id'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> checkIn(
    int coffeeShopId, {
    String? note,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/checkins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'coffeeShopId': coffeeShopId, 'note': note}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getFavorites() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/favorites'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<bool> addFavorite(int coffeeShopId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/$coffeeShopId'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> removeFavorite(int coffeeShopId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/$coffeeShopId'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> isFavorite(int coffeeShopId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/check/$coffeeShopId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> createReview(
    int coffeeShopId,
    int rating,
    String content,
    List<String>? images,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'coffeeShopId': coffeeShopId,
          'rating': rating,
          'content': content,
          'images': images,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getReviewsByCoffeeShop(
    int coffeeShopId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/reviews/coffeeshop/$coffeeShopId?page=$page&pageSize=$pageSize',
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
