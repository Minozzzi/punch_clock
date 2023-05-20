import 'package:punch_clock/dbProvider.dart';
import 'package:punch_clock/punchClockModel.dart';

class PunchClockDao {
  final dbProvider = DatabaseProvider.instance;

  Future<int> insert(PunchClock punchClock) async {
    final db = await dbProvider.database;
    final id = await db.insert(PunchClock.TABLE_NAME, punchClock.toMap());
    return id;
  }

  Future<List<PunchClock>> getAll() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(PunchClock.TABLE_NAME);
    return List.generate(maps.length, (i) {
      return PunchClock.fromMap(maps[i]);
    });
  }
}