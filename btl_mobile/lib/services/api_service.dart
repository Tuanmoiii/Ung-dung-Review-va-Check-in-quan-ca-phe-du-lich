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

  // Lấy danh sách coffee shops
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

  // Lấy danh sách trending shops
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

  // Lấy chi tiết coffee shop
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

  // Check-in
  static Future<Map<String, dynamic>?> checkIn(
    int coffeeShopId, {
    int? userId,
    String? note,
  }) async {
    try {
      final currentUserId = userId ?? _currentUser?['id'];

      if (currentUserId == null) {
        print('User not logged in');
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/checkins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': currentUserId,
          'coffeeShopId': coffeeShopId,
          'note': note,
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

  // Lấy danh sách yêu thích
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

  // Thêm yêu thích
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

  // Xóa yêu thích
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

  // Kiểm tra yêu thích
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

  // Tạo review mới
  static Future<Map<String, dynamic>?> createReview(
    int coffeeShopId,
    int rating,
    String content,
    List<String>? images, {
    int? userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');

      if (userStr == null) {
        print('User not logged in!');
        return null;
      }

      final user = jsonDecode(userStr);
      final currentUserId = userId ?? user['id'];

      final body = {
        'userId': currentUserId,
        'coffeeShopId': coffeeShopId,
        'rating': rating,
        'content': content,
        'images': images ?? [],
      };

      print('Creating review with body: $body');

      final response = await http.post(
        Uri.parse('$baseUrl/api/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating review: $e');
      return null;
    }
  }

  // Cập nhật review
  static Future<Map<String, dynamic>?> updateReview(
    int reviewId,
    int rating,
    String content,
    List<String>? images,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');

      if (userStr == null) {
        print('User not logged in!');
        return null;
      }

      final body = {
        'rating': rating,
        'content': content,
        'images': images ?? [],
      };

      print('Updating review $reviewId with body: $body');

      final response = await http.put(
        Uri.parse('$baseUrl/api/reviews/$reviewId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error updating review: $e');
      return null;
    }
  }

  // Lấy danh sách reviews theo coffee shop
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

  // ==================== POSTS ====================

  // Lấy danh sách posts
  static Future<List<dynamic>> getPosts({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/posts?page=$page&pageSize=$pageSize'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  // Lấy posts theo user
  static Future<List<dynamic>> getPostsByUser(
    int userId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/posts/user/$userId?page=$page&pageSize=$pageSize',
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error getting posts by user: $e');
      return [];
    }
  }

  // Tạo post mới
  static Future<Map<String, dynamic>?> createPost({
    required int userId,
    required String content,
    List<String>? images,
    int? coffeeShopId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'content': content,
          'images': images,
          'coffeeShopId': coffeeShopId,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }

  // Cập nhật post
  static Future<Map<String, dynamic>?> updatePost(
    int postId,
    String content,
    List<String>? images,
    int? coffeeShopId,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': content,
          'images': images,
          'coffeeShopId': coffeeShopId,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error updating post: $e');
      return null;
    }
  }

  // Like post
  static Future<bool> likePost(int postId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts/$postId/like'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error liking post: $e');
      return false;
    }
  }

  // Xóa post
  static Future<bool> deletePost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/posts/$postId'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  // ==================== COMMENTS ====================

  // Lấy danh sách comments của post
  static Future<List<dynamic>> getComments(
    int postId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/posts/$postId/comments?page=$page&pageSize=$pageSize',
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error getting comments: $e');
      return [];
    }
  }

  // Tạo comment mới
  static Future<Map<String, dynamic>?> createComment({
    required int postId,
    required int userId,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'content': content}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating comment: $e');
      return null;
    }
  }

  // ==================== REVIEWS ====================

  // Lấy reviews theo user
  static Future<List<dynamic>> getReviewsByUser(
    int userId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/reviews/user/$userId?page=$page&pageSize=$pageSize',
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error getting user reviews: $e');
      return [];
    }
  }

  // ==================== FAVORITES (cập nhật) ====================

  // Lấy danh sách yêu thích với userId
  static Future<List<dynamic>> getFavoritesWithUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites?userId=$userId'),
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

  // Thêm yêu thích với userId
  static Future<bool> addFavoriteWithUserId(
    int coffeeShopId,
    int userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/$coffeeShopId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Xóa yêu thích với userId
  static Future<bool> removeFavoriteWithUserId(
    int coffeeShopId,
    int userId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/$coffeeShopId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Kiểm tra yêu thích với userId
  static Future<bool> isFavoriteWithUserId(int coffeeShopId, int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/check/$coffeeShopId?userId=$userId'),
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

  // ==================== DAILY CODES ====================

  static Future<bool> validateCode(int coffeeShopId, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/dailycodes/validate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'coffeeShopId': coffeeShopId, 'code': code}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error validating code: $e');
      return false;
    }
  }
}
