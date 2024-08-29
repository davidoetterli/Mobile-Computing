import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';

class EditBlogScreen extends StatefulWidget {
  final Blog blog;

  EditBlogScreen({required this.blog});

  @override
  _EditBlogScreenState createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.blog.title;
    _contentController.text = widget.blog.content;
  }

  void _saveChanges() async {
    final updatedBlog = Blog(
      id: widget.blog.id,
      title: _titleController.text,
      content: _contentController.text,
      author: widget.blog.author,
      publishedDate: widget.blog.publishedDate,
      comments: widget.blog.comments,
      likedByUsers: [],
    );

    await ApiService().updateBlog(updatedBlog.id, updatedBlog);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog bearbeiten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Inhalt'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
