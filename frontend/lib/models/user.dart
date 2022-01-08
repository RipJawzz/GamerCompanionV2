// ignore: camel_case_types
class user {
  final String uid;
  String? name, email;
  final bool anonymous;
  int factor = 40;
  Set<int> likedGames = {};
  Set<String> following = {};
  user({required this.uid, required this.anonymous});
}
