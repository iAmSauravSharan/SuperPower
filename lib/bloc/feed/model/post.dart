import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int _postId;
  final String _userAvatar;
  final String _username;
  final String _uploadTime;
  final String _heading;
  final String _content;
  final int _contentType;
  int upvotes;
  int downvotes;
  bool isUpvoted = false;
  bool isDownVoted = false;
  bool isShared = false;

  Post({
    required int postId,
    required String userAvatar,
    required String username,
    required String uploadTime,
    required String heading,
    required String content,
    required int contentType,
    required this.upvotes,
    required this.downvotes,
  })  : _contentType = contentType,
        _content = content,
        _heading = heading,
        _uploadTime = uploadTime,
        _username = username,
        _userAvatar = userAvatar,
        _postId = postId;

  int get id => _postId;

  String get author => _username;

  String get avatar => _userAvatar;

  String get time => _uploadTime;

  String get title => _heading;

  String get content => _content;

  int get contentType => _contentType;

  int get likes => upvotes;

  int get dislikes => downvotes;

  bool get upvoted => isUpvoted;

  bool get downvoted => isDownVoted;


  Map<String, dynamic> toJson() {
    return {
      'postId': _postId,
      'username': _username,
      'avatar': _userAvatar,
      'uploadTime': _uploadTime,
      'heading': _heading,
      'content': _content,
      'contentType': _contentType,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      username: json['username'],
      userAvatar: json['avatar'],
      uploadTime: json['uploadTime'],
      heading: json['heading'],
      content: json['content'],
      contentType: json['contentType'],
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
    );
  }

  @override
  List<Object?> get props => [id];
}
