import 'package:cinemapedia/domain/datasources/authentication_local_datasource.dart';
import 'package:cinemapedia/domain/entities/session.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  late Future<Isar> db;

  AuthenticationLocalDataSourceImpl() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([SessionSchema], //Hay que crear el esquema (ver la impl en el curso de flutter)
          inspector: true, //Servicio para analizar cómo está la BD local en el dispositivo
          directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> saveSessionId(String sessionId) async {
    final isar = await db;

    //Insertar en la BD
    isar.writeTxnSync(() => isar.sessions.putSync(Session(sessionId: sessionId)));
  }
}
