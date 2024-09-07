import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';
import '../widgets/BlogCard.dart';
import 'blog_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.username, super.key});

  final String username;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Blog>> futureBlogs;

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  void _fetchBlogs() {
    setState(() {
      futureBlogs = ApiService().fetchBlogs();
    });
  }

  void _handleLikeToggle(Blog blog) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await ApiService().likeBlog(blog.id, userProvider.username);
      _fetchBlogs();
    } catch (e) {
      print('Fehler beim Aktualisieren des Likes: $e');
    }
  }

  void _navigateToBlogDetail(BuildContext context, Blog blog) async {
    final shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogDetailScreen(blog: blog),
      ),
    );
    if (shouldUpdate == true) {
      _fetchBlogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return FutureBuilder<List<Blog>>(
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
                    final blog = blogs.reversed.toList()[index];
                    return BlogCard(
                      blog: blog,
                      onLikeToggle: _handleLikeToggle,
                      username: userProvider.username,
                      onTap: () => _navigateToBlogDetail(context, blog),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Fehler: ${snapshot.error}'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
