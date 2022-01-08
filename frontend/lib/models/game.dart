class Game {
  final int id;
  final String description, name, tags;
  String url;
  String? score;
  Game(
      {required this.id,
      required this.name,
      required this.description,
      required this.url,
      required this.tags});
}
