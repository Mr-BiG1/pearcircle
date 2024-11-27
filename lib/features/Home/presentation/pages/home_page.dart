import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/Home/presentation/components/my_drawer.dart';
import 'package:peer_circle/features/post/presentation/components/post_tile.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_cubits.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_states.dart';
import 'package:peer_circle/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // loading up th posts.
  late final postCubit = context.read<PostCubit>();
  @override
  void initState() {
    super.initState();

    // get all data
    fetchAllPost();
  }

  void fetchAllPost() {
    postCubit.fetchAllPost();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    postCubit.fetchAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadPostPage(),
                )),
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              icon: Icon(Icons.logout)),
        ],
      ),

      // Drawer
      drawer: const MyDrawer(),

      body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        // loading..
        if (state is PostLoading && state is PostUploading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );

          // loaded
        } else if (state is PostLoaded) {
          final allPosts = state.posts;
          if (allPosts.isEmpty) {
            return const Center(
              child: Text("No posts found "),
            );
          }

          return ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              // get post
              final post = allPosts[index];

              // getting the image.

              return PostTile(post: post,onDeletePressed: ()=> deletePost(post.id),);
            },
          );
        }

        // error

        else if (state is PostError) {
          return const Center(child: Text("Error while loading",style: TextStyle(color: Colors.red),));
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
