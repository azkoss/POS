//import 'dart:async';
//import 'dart:io';
//import 'package:pos/src/model/payment_request.dart';
//import 'package:wom_package/wom_package.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:synchronized/synchronized.dart';
//
///// This is the singleton database class which handlers all database transactions
///// All the task raw queries is handle here and return a Future<T> with result
//class AppDatabase {
//  static final AppDatabase _appDatabase = new AppDatabase._internal();
//
//  //private internal constructor to make it singleton
//  AppDatabase._internal();
//
//  Database _database;
//
//  static AppDatabase get() {
//    return _appDatabase;
//  }
//
//  final _lock = new Lock();
//
//  Future<Database> getDb() async {
//    if (_database == null) {
//      await _lock.synchronized(() async {
//        // Check again once entering the synchronized block
//        if (_database == null) {
//          await _init();
//        }
//      });
//    }
//    return _database;
//  }
//
//  Future _init() async {
//    print("AppDatabase: init database");
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, "pos.db");
//    _database = await openDatabase(path, version: 1,
//        onCreate: (Database db, int version) async {
//      await AimDbHelper.createAimTable(db);
//      await _createRequestTable(db);
//    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
//      await db.execute("DROP TABLE ${Aim.TABLE_NAME}");
//      await AimDbHelper.createAimTable(db);
//      await _createRequestTable(db);
//    });
//  }
//
//  Future _createRequestTable(Database db) {
//    return db.execute("CREATE TABLE ${PaymentRequest.TABLE} ("
//        "${PaymentRequest.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
//        "${PaymentRequest.AIM_CODE} TEXT,"
//        "${PaymentRequest.AIM_NAME} TEXT,"
//        "${PaymentRequest.DEEP_LINK} TEXT,"
//        "${PaymentRequest.PASSWORD} TEXT,"
//        "${PaymentRequest.POS_ID} TEXT,"
//        "${PaymentRequest.NONCE} TEXT,"
//        "${PaymentRequest.NAME} TEXT,"
//        "${PaymentRequest.AMOUNT} INTEGER,"
//        "${PaymentRequest.STATUS} INTEGER,"
//        "${PaymentRequest.PERSISTENT} INTEGER,"
//        "${PaymentRequest.POCKET_ACK_URL} TEXT,"
//        "${PaymentRequest.POS_ACK_URL} TEXT,"
//        "${SimpleFilters.MAX_AGE} INTEGER,"
//        "${BoundingBox.LEFT_TOP_LAT} LONG,"
//        "${BoundingBox.LEFT_TOP_LONG} LONG,"
//        "${BoundingBox.RIGHT_BOT_LAT} LONG,"
//        "${BoundingBox.RIGHT_BOT_LONG} LONG,"
//        "${PaymentRequest.URL} TEXT,"
//        "${PaymentRequest.DATE} INTEGER);");
//  }
//
//  Future<void> closeDatabase() async {
//    if (_database != null && _database.isOpen) {
//      await _database.close();
//      _database = null;
//      print("database closed");
//    }
//  }
//}
