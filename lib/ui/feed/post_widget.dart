import 'package:flutter/material.dart';
import 'package:superpower/bloc/feed/model/post.dart';
import 'package:superpower/ui/post_detail_page/post_detail_page.dart';
import 'package:superpower/util/constants.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return PostItem(post);
  }
}

class PostItem extends StatefulWidget {
  const PostItem(this.post, {super.key});
  final Post post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.post.contentType == PostType.video) {
      _controller = VideoPlayerController.network(widget.post.content)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: GestureDetector(
        onTap: () {
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedPostScreen(post: posts[index]),
            ),
          ); */
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.post.avatar),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.author,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(widget.post.time),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              widget.post.contentType == PostType.image
                  ? Image.network(widget.post.content)
                  : widget.post.contentType == PostType.video
                      ? SizedBox(
                          height: 180,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  )
                                : Container(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          child: Text(widget.post.content),
                        ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.post.upvotes++;
                            });
                          },
                          icon: const Icon(Icons.thumb_up),
                        ),
                        Text(widget.post.upvotes.toString()),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.post.downvotes++;
                            });
                          },
                          icon: Icon(Icons.thumb_down),
                        ),
                        Text(widget.post.downvotes.toString()),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailPage(widget.post),
                          ),
                        );
                      },
                      icon: Icon(Icons.comment),
                    ),
                    IconButton(
                      onPressed: () {
                        // showSharePrompt(context, widget.post);
                      },
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
