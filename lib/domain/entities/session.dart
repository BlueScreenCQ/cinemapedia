import 'package:isar/isar.dart';

part 'session.g.dart';

@collection
class Session {
  Id? isarId;

  final String sessionId;

  Session({required this.sessionId});
}
