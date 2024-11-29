// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/Home/presentation/components/drawer_tiles.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:peer_circle/features/profile/presentation/pages/profile_page.dart';
import 'package:peer_circle/features/search/presentation/pages/search_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              // divider line
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              // home tile
              MyDrawerTiles(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              // profile tile.
              MyDrawerTiles(
                  title: "P R O F I L E",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).pop();
                    // get current user id.

                    final user = context.read<AuthCubit>().currentUser;
                    String? uid = user!.uid;

                    // navigate to  profile page.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  uid: uid,
                                )));
                  }),

              //search tile.
              MyDrawerTiles(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=> const SearchPage())),
              ),

              // settings tile
              MyDrawerTiles(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {},
              ),

              const Spacer(),
              //logout tile.
              MyDrawerTiles(
                  title: "L O G O  U T",
                  icon: Icons.logout,
                  onTap: () async {
                    final conform = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content:
                            const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthCubit>().logout();
                              Navigator.of(context).pop();
                            },
                            //  => context.read<AuthCubit>().logout(),
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
