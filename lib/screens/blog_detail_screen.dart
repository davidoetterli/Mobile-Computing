import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';
import 'edig_blog_screen.dart'; // Stelle sicher, dass du diesen Import hast

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  BlogDetailScreen({required this.blog});

  void _deleteBlog(BuildContext context) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bestätigen'),
        content: const Text('Möchten Sie diesen Blog wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await ApiService().deleteBlog(blog.id);
      Navigator.of(context).pop(true); // Zurück zur vorherigen Seite mit einem Wert
    }
  }

  void _editBlog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBlogScreen(blog: blog),
      ),
    ).then((_) {
      // Wenn der EditBlogScreen geschlossen wird, führe hier etwas aus, falls nötig
      Navigator.of(context).pop(true); // Zurück zur vorherigen Seite mit einem Wert
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editBlog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteBlog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                blog.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Text(
                'Kommentare:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              blog.comments.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: blog.comments.map((comment) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.author,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.content,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  : const Text('Keine Kommentare vorhanden'),
            ],
          ),
        ),
      ),
    );
  }
}
