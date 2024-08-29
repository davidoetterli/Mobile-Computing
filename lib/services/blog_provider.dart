import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';

class BlogProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Blog> _blogs = [];
  bool _isLoading = false;

  List<Blog> get blogs => _blogs;
  bool get isLoading => _isLoading;

  Future<void> fetchBlogs() async {
    _isLoading = true;
    print('loading..');
    notifyListeners();

    try {
      _blogs = await _apiService.fetchBlogs();
    } catch (e) {
      print('Fehler beim Abrufen der Blogs: $e');
    } finally {
      _isLoading = false;
      print('loaded blogs:\n${_blogs.toString()}');
      notifyListeners();
    }
  }

  Future<void> deleteBlog(int id) async {
    try {
      await _apiService.deleteBlog(id);
      await fetchBlogs();
    } catch (e) {
      print('Fehler beim Löschen des Blogs: $e');
    }
  }

  Future<void> likeBlog(int id, String username) async {
    try {
      await _apiService.likeBlog(id, username);
      await fetchBlogs();
    } catch (e) {
      print('Fehler beim Liken des Blogs: $e');
    }
  }
}
