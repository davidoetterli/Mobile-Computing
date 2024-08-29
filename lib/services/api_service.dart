import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blog.dart';
import '../models/comment.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8080'; // Basis-URL des Backends

  // Methode zum Abrufen der Blogs
  Future<List<Blog>> fetchBlogs({String? searchStr}) async {
    final uri = Uri.parse('$baseUrl/blogs').replace(
        queryParameters: searchStr != null ? {'searchStr': searchStr} : null);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Blog.fromJson(json)).toList();
    } else {
      throw Exception('Fehler beim Abrufen der Blogs');
    }
  }

  // Methode zum Abrufen eines einzelnen Blogs
  Future<Blog> fetchBlog(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/blogs/$id'));

    if (response.statusCode == 200) {
      return Blog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fehler beim Abrufen des Blogs');
    }
  }

  // Methode zum Hinzufügen eines neuen Blogs
  Future<void> addBlog(Blog blog) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(blog.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Fehler beim Hinzufügen des Blogs');
    }
  }

  // Methode zum Aktualisieren eines bestehenden Blogs
  Future<void> updateBlog(int id, Blog blog) async {
    final response = await http.put(
      Uri.parse('$baseUrl/blogs/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(blog.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Fehler beim Aktualisieren des Blogs');
    }
  }

  // Methode zum Löschen eines Blogs
  Future<void> deleteBlog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/blogs/$id'));

    if (response.statusCode != 200) {
      throw Exception('Fehler beim Löschen des Blogs');
    }
  }

  // Methode zum Liken eines Blogs
  Future<void> likeBlog(int id, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogs/$id/like?username=$username'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final errorMessage = json.decode(response.body)['message'] ??
          'Fehler beim Liken des Blogs';
      print('like blog: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  // Methode zum Abrufen aller Kommentare eines Blogs
  Future<List<Comment>> fetchComments(int blogId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/blogs/$blogId/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Fehler beim Abrufen der Kommentare');
    }
  }

  // Methode zum Hinzufügen eines Kommentars zu einem Blog
  Future<void> addComment(int blogId, Comment comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogs/$blogId/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Fehler beim Hinzufügen des Kommentars');
    }
  }

  // Methode zum Löschen eines Kommentars
  Future<void> deleteComment(int blogId, int commentId) async {
    final response = await http
        .delete(Uri.parse('$baseUrl/blogs/$blogId/comments/$commentId'));

    if (response.statusCode != 200) {
      throw Exception('Fehler beim Löschen des Kommentars');
    }
  }
}
