import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:superpower/bloc/feed/model/post.dart';

class PostDetailPage extends StatelessWidget {
  static const routeName = "/post-detail";

  final Post post;
  const PostDetailPage(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
