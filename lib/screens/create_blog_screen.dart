import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';

class CreateBlogScreen extends StatefulWidget {
  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ApiService _apiService = ApiService(); // Instanz von ApiService

  void _submit() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Titel und Inhalt dürfen nicht leer sein')),
      );
      return;
    }

    final newBlog = Blog(
      id: 1,
      title: title,
      content: content,
      author: 'example_user',
      publishedDate: DateTime.now().toString(),
      likedByUsers: [],
      comments: [],
    );

    try {
      await _apiService.addBlog(newBlog);
        print('Blog erfolgreich erstellt');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blog erfolgreich erstellt')),
      );
      // Alternative Navigation Methode
      print('try to pop');
      
      print('popped');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen des Blogs: $e')),
      );
      print('Fehler: $e'); // Füge detaillierte Fehlerprotokollierung hinzu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Inhalt'),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}
