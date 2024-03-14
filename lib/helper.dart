import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlHelper {
  // Function to open the database
  Future<Database> openDB(String path) async {
    // Opening the database
    try {
      Database db = await openDatabase(
        // Constructing the full path to the database file
        join(await getDatabasesPath(), path),
        onCreate: (db, version) {
          // Create tables and perform initial setup if the database does not exist
          // This function will be called when the database is first created
          // You can execute SQL queries here to create tables and perform other setup
          // For example:
          // await db.execute("CREATE TABLE my_table (id INTEGER PRIMARY KEY, name TEXT)");
        },
        version: 1, // Database schema version
      );
      return db;
    } catch (e) {
      // Error handling if opening database fails
      print("Error opening database: $e");
      return null; // Return null indicating failure
    }
  }
}
