import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';
import '../widgets/BlogCard.dart';
import 'blog_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Blog>> futureBlogs;
  final String username = 'David';

  @override
  void initState() {
    super.initState();
    futureBlogs = ApiService().fetchBlogs(); // API-Service zum Abrufen der Blogs
  }

  void _handleLikeToggle(Blog blog) async {
  await ApiService().likeBlog(blog.id, username);
  // Update der Future, um den neuen Zustand zu reflektieren
  setState(() {
    futureBlogs = ApiService().fetchBlogs();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: FutureBuilder<List<Blog>>(
        future: futureBlogs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final blogs = snapshot.data!;
            if (blogs.isEmpty) {
              return const Center(child: Text('Keine Blogs verfügbar'));
            }
            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs.reversed.toList()[index]; // Umkehren der Liste
                return BlogCard(
                  blog: blog,
                  onLikeToggle: _handleLikeToggle,
                  username: username,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
