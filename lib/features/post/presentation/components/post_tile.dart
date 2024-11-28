import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/domain/entities/app_user.dart';
import 'package:peer_circle/features/auth/presentation/components/mt_textbox.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:peer_circle/features/post/domain/comment.dart';
import 'package:peer_circle/features/post/domain/entities/post.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_cubits.dart';
import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';
import 'package:peer_circle/features/profile/presentation/cubits/progile_cubit.dart';
import 'package:peer_circle/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  //  on initial
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null && mounted) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

// option conformation
  void showOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post?"),
              actions: [
                // cancel
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel")),

                // conform
                TextButton(
                    onPressed: () {
                      widget.onDeletePressed!();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Delete")),
              ],
            ));
  }

// likes

  void toggleLikePost() {
    // current likes
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      // if error true.
      if (isLiked) {
        widget.post.likes.add(currentUser!.uid);
      } else {
        widget.post.likes.remove(currentUser!.uid);
      }
    });
  }

  // comments
  final commentTextController = TextEditingController();
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextBox(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          //  cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment();
              () => Navigator.of(context).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      text: commentTextController.text,
      timeStamp: DateTime.now(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
    );

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

// ui
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          //  tpo section.
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  uid: widget.post.userId,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // profile pic
                  postUser?.profileImage != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImage,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                          imageBuilder: (context, ImageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : const Icon(Icons.person),
                  const SizedBox(
                    width: 10,
                  ),
                  // user name.
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (isOwnPost)
                    (
                        // delete button
                        GestureDetector(
                      onTap: showOptions,
                      child: const Icon(Icons.delete),
                    )),
                ],
              ),
            ),
          ),
          // getting image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
            ),
          ),
          //  button like , comment , timestamp

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(widget.post.likes.length.toString()),
                    ],
                  ),
                ),
                // comment button
                GestureDetector(child: const Icon(Icons.comment)),
                const Text("0"),

                // time Stamp

                Text(
                  widget.post.timeStamp.toString(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
