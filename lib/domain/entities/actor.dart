class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String? character;
  final bool? adult;
  final String? biography;
  final DateTime? birthday;
  final DateTime? deatday;
  final int? gender;
  final String? knownForDepartment;
  final String? placeOfBirth;

  Actor(
      {this.adult,
      this.biography,
      this.birthday,
      this.deatday,
      this.gender,
      this.knownForDepartment,
      this.placeOfBirth,
      required this.id,
      required this.name,
      required this.profilePath,
      required this.character});
}
