import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';
import 'package:peer_circle/features/profile/presentation/pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;
  const UserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.secondary),
      leading: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.secondary,
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProfilePage(uid: user.uid))),
    );
  }
}
