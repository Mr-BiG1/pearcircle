import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';
import 'package:peer_circle/features/search/domain/search_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUser?>> searchUser(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("users")
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((docs) => ProfileUser.fromJson(docs.data()))
          .toList();
    } catch (e) {
      throw Exception("Error searching: $e");
    }
  }
}
