import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/presentation/components/mt_textbox.dart';
import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';
import 'package:peer_circle/features/profile/presentation/cubits/profile_states.dart';
import 'package:peer_circle/features/profile/presentation/cubits/progile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image
  PlatformFile? imagePickerFile;

  // web image pick

  Uint8List? webImage;

  final bioTextController = TextEditingController();
  // update  profile method

  /// pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePickerFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickerFile!.bytes;
        }
      });
    }
  }

  // update profile button.
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    // setting up the image.
    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickerFile?.path;
    final imageWebBytes = kIsWeb ? imagePickerFile?.bytes : null;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;

    if (imagePickerFile != null || newBio != null) {
      profileCubit.updateProfile(
          uid: widget.user.uid,
          newBio: bioTextController.text,
          imageMobilePath: imageMobilePath,
          imageWebBytes: imageWebBytes);
    } else {
      // if nothing to update.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          // profile Loading..
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text("Uploading...")],
                ),
              ),
            );
          } else {
            return buildEditPage();
          }

          //profile error...

          //edit form..
        },
        listener: (context, state) {});
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload))
        ],
      ),
      body: Column(
        children: [
          // profile image.
          Center(
            child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle),
                clipBehavior: Clip.hardEdge,
                child:
                    //display  selected image  for  mobile ,
                    (!kIsWeb && imagePickerFile != null)
                        ? Image.file(
                            File(imagePickerFile!.path!),
                            fit: BoxFit.cover,
                          )
                        :
                        // display selected image  for web
                        (kIsWeb && webImage != null)
                            ? Image.memory(
                                webImage!,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.user.profileImage,

                                // loading
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),

                                // error
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 72,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                // load
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              )),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick image"),
            ),
          ),
          const Text("Bio"),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextBox(
                controller: bioTextController,
                hintText: widget.user.bio,
                obscureText: false),
          )
        ],
      ),
    );
  }
}
