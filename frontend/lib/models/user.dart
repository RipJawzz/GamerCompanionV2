class user {
  final String uid;
  late String name;
  final bool anonymous;
  late String email;
  Set<int> likedGames = {};
  Set<int> dislikedGames = {};
  user({required this.uid, required this.anonymous});
}
