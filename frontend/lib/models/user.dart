class user {
  final String uid;
  late String name, email;
  final bool anonymous;
  int factor = 1;
  Set<int> likedGames = {};
  Set<String> following = {};
  user({required this.uid, required this.anonymous});
}
