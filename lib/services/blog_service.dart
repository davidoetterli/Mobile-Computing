import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogService {
  final String baseUrl = "http://10.0.2.2:8080";

  BlogService();

  Future<List<dynamic>> getBlogs({String? searchStr}) async {
    final uri = Uri.parse('$baseUrl/blogs').replace(queryParameters: searchStr != null ? {'searchStr': searchStr} : null);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<dynamic> getBlog(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/blogs/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load blog');
    }
  }

  Future<void> addBlog(Map<String, dynamic> blog) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(blog),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add blog');
    }
  }

  Future<void> updateBlog(int id, Map<String, dynamic> blog) async {
    final response = await http.put(
      Uri.parse('$baseUrl/blogs/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(blog),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update blog');
    }
  }

  Future<void> deleteBlog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/blogs/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete blog');
    }
  }

  Future<void> likeBlog(int id, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogs/$id/like?username=$username'),
    );

    if (response.statusCode != 200) {
      final errorMessage = json.decode(response.body)['message'] ?? 'Failed to like blog';
      throw Exception(errorMessage);
    }
  }
}
