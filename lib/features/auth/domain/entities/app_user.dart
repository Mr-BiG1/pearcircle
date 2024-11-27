// class for the users.

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String collage;
  final String campus;

// convert user to  json.
  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.collage,
    required this.campus,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'collage': collage,
      'campus': campus
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
        uid: jsonUser['uid'],
        email: jsonUser['email'],
        name: jsonUser['name'],
        collage: jsonUser['collage'],
        campus: jsonUser['campus']);
  }
}
