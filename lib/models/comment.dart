class Comment {
  final int id;
  final String author;
  final String content;

  const Comment({
    required this.id,
    required this.author,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      author: json['author'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
    };
  }
}
