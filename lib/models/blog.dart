import 'comment.dart';

class Blog {
  final int id;
  final String title;
  final String content;
  final String author;
  final String publishedDate;
  final List<String> likedByUsers;
  final List<Comment> comments;

  const Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.publishedDate,
    required this.likedByUsers,
    required this.comments,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    var likedByUsersFromJson = json['likedByUsers'] as List;
    var commentsFromJson = json['comments'] as List;

    return Blog(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      publishedDate: json['publishedDate'],
      likedByUsers: List<String>.from(likedByUsersFromJson),
      comments: commentsFromJson.map((i) => Comment.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'author': author,
    };
  }

  bool isLikedByMe(String username) {
    return likedByUsers.contains(username);
  }

  void toggleLike(String username) {
    if (isLikedByMe(username)) {
      likedByUsers.remove(username);
    } else {
      likedByUsers.add(username);
    }
  }
}
