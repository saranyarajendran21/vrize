import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database? _db;

  DBHelper.internal();

  final String CardDetailsTable = 'CardDetailsTable';
  final String DB_Name = 'carddata.db';
  final String TAG = 'DBHelper';

  final String cardHoldername = 'cardHoldername';
  final String cardNumber = 'cardNumber';
  final String expirydate = 'expirydate';
  final String cvvNumber = 'cvvNumber';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_Name);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $CardDetailsTable ($cardHoldername TEXT, $cardNumber TEXT, $expirydate TEXT,  $cvvNumber TEXT)');
  }

  Future<int?> getcardCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient!.rawQuery('SELECT COUNT(*) FROM $CardDetailsTable'));
  }

  Future<int?> saveCarddetails(Map<String, dynamic> rowval) async {
    var dbClient = await db;

    var result = await dbClient!.insert(CardDetailsTable, rowval);
    return result;
  }

  Future<List> Getallcarddata() async {
    var dbClient = await db;
    var result = await dbClient!.query(CardDetailsTable, columns: [
      cardHoldername,
      cardNumber,
      expirydate,
      cvvNumber
    ]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableUser');

    return result.toList();
  }

}