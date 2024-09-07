import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog.dart';
import '../models/comment.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';
import 'edit_blog_screen.dart';

class BlogDetailScreen extends StatefulWidget {
  final Blog blog;

  BlogDetailScreen({required this.blog});

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  void _editBlog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBlogScreen(blog: widget.blog),
      ),
    ).then((_) {
      Navigator.of(context).pop(true);
    });
  }

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
      await ApiService().deleteBlog(widget.blog.id);
      Navigator.of(context).pop(true);
    }
  }

  void _addComment() async {
    final commentContent = _commentController.text;
    if (commentContent.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final newComment = Comment(
        author: userProvider.username,
        content: commentContent,
        id: widget.blog.id,
      );
      await ApiService().addComment(widget.blog.id, newComment);
      _commentController.clear();
      setState(() {
        widget.blog.comments.add(newComment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog.title),
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
                widget.blog.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                widget.blog.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Kommentare:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              widget.blog.comments.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.blog.comments.map((comment) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.author,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Kommentar hinzufügen',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addComment,
                child: const Text('Kommentar hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
