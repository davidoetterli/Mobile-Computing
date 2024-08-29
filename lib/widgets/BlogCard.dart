import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../screens/blog_detail_screen.dart';

class BlogCard extends StatefulWidget {
  const BlogCard({
    super.key,
    required this.blog,
    required this.onLikeToggle,
    required this.username,
    required this.onTap,
  });

  final Blog blog;
  final ValueChanged<Blog> onLikeToggle;
  final String username;
  final VoidCallback onTap;

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final username = widget.username;
    final contentPreview = blog.content.length > 50
        ? '${blog.content.substring(0, 50)}...'
        : blog.content;

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      blog.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${blog.likedByUsers.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          blog.isLikedByMe(username)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: blog.isLikedByMe(username)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            blog.toggleLike(username);
                          });
                          widget.onLikeToggle(blog);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                contentPreview,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${blog.author} • ${blog.publishedDate}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
