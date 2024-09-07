import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class CreateBlogScreen extends StatefulWidget {
  final String username;

  const CreateBlogScreen({super.key, required this.username});

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isSubmitting = false;

  void _submit() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Titel und Inhalt dürfen nicht leer sein')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newBlog = Blog(
      id: 0,
      title: title,
      content: content,
      author: userProvider.username,
      publishedDate: DateTime.now().toString(),
      likedByUsers: [],
      comments: [],
    );

    try {
      await _apiService.addBlog(newBlog);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog erfolgreich erstellt')),
      );
      _titleController.clear();
      _contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen des Blogs: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte gib einen Titel ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Inhalt',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte gib einen Inhalt ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Blog erstellen'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
