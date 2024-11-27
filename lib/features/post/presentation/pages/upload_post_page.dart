import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/domain/entities/app_user.dart';
import 'package:peer_circle/features/auth/presentation/components/mt_textbox.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:peer_circle/features/post/domain/entities/post.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_cubits.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image picker.
  PlatformFile? imagePickerFile;

  // web image picker.
  Uint8List? webimage;

  // current user
  AppUser? currentUser;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

// getting current user.
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

//  selecting the image.
  /// pick image
  final textController = TextEditingController();
  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePickerFile = result.files.first;

        if (kIsWeb) {
          webimage = imagePickerFile!.bytes;
        }
      });
    }
  }
//  uploading the image.

  void uploadPost() {
    // ignore: unnecessary_null_comparison
    if (imagePickerFile == null || textController.text == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Both image field are required")));
      return;
    }

    // creating post
    final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser!.uid,
        userName: currentUser!.name,
        imageUrl: '',
        text: textController.text,
        timeStamp: DateTime.now(),
        likes: [],
        );

    // post

    final postCubit = context.read<PostCubit>();

    // mobile adn web upload .
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickerFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePickerFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(builder: (context, state) {
      if (state is PostLoading || state is PostUploading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return buidUploadPage();
    }, listener: (context, state) {
      if (state is PostLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buidUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload 
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload))
        ],
      ),

      // body
      body: Center(
        child: Column(
          children: [
            if (kIsWeb && webimage != null) Image.memory(webimage!),
            //  image  preview
            if (!kIsWeb && imagePickerFile != null)
              Image.file(File(imagePickerFile!.path!)),
            //  pick   image  button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),
            MyTextBox(
                controller: textController,
                hintText: "Caption",
                obscureText: false),
          ],
        ),
      ),
    );
  }
}
