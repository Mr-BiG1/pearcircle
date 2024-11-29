// follow or unFollow
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
  });

// UI
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.all(15),
          color:
              isFollowing ? Theme.of(context).colorScheme.inversePrimary: Colors.blue,
          child: Text(
            isFollowing ? "UnFollowing" : "Following",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
