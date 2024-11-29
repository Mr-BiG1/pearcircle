import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/profile/presentation/components/user_tile.dart';
import 'package:peer_circle/features/profile/presentation/cubits/progile_cubit.dart';
import 'package:peer_circle/features/search/domain/search_repo.dart';
import 'package:peer_circle/features/search/presentation/cubits/search_cubit.dart';
import 'package:peer_circle/features/search/presentation/cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.SearchUser(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // txt field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: "Search",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
      ),

      // body

      body: BlocBuilder<SearchCubit, SearchStates>(builder: (context, state) {
        // loaded
        if (state is SearchLoaded) {
          // no user
          if (state.users.isEmpty) {
            return const Center(
              child: Text("No user Found!"),
            );
          }

          // users..
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return UserTile(user: user!);
            },
          );
        }
// loading
        else if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        }

        // default
        return const Center(
          child: Text('Enter the user name to search '),
        );
      }),
    );
  }
}
