
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ft_hangout.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {

    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    // Contacts table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        mobile TEXT NOT NULL UNIQUE
          CHECK (mobile NOT GLOB '*[^0-9]*'),
        notes TEXT,
        address TEXT,
        aura INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Messages table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact_id INTEGER NOT NULL,
        contents TEXT,
        is_sender INTEGER NOT NULL DEFAULT 0
          CHECK (is_sender IN (0, 1)),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (contact_id) REFERENCES contacts(id)
      )
    ''');

    // Settings table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        header_color TEXT NOT NULL DEFAULT '#ef9a86',
        lang TEXT NOT NULL DEFAULT 'en'
      )
    ''');

    // Insert default settings
    final settings = await db.query('settings', limit: 1);

    if (settings.isEmpty) {
      await db.insert('settings', {
        'header_color': '#ef9a86',
        'lang': 'en',
      });
    }


    final result = await db.rawQuery('''
      SELECT
        NOT EXISTS (SELECT 1 FROM contacts) AS contacts_empty,
        NOT EXISTS (SELECT 1 FROM messages) AS messages_empty
    ''');

    final shouldSeed = result.first['contacts_empty'] == 1 &&
                      result.first['messages_empty'] == 1;

    if (shouldSeed) {
      await db.transaction((txn) async {
        // Seed contacts
        final batch = txn.batch();

        batch.insert('contacts', {
          'name': 'Alex Tan',
          'mobile': '60123456789',
          'notes': 'College friend',
          'address': 'Petaling Jaya',
          'aura': 85,
        });

        batch.insert('contacts', {
          'name': 'Sarah Lim',
          'mobile': '60187654321',
          'notes': 'Work colleague',
          'address': 'Kuala Lumpur',
          'aura': 92,
        });

        batch.insert('contacts', {
          'name': 'Jason Wong',
          'mobile': '60112233445',
          'notes': 'Gym buddy',
          'address': 'Subang Jaya',
          'aura': 70,
        });

        batch.insert('contacts', {
          'name': 'Michelle Lee',
          'mobile': '60199887766',
          'notes': 'Best friend',
          'address': 'Shah Alam',
          'aura': 98,
        });

        batch.insert('contacts', {
          'name': 'Daniel Ng',
          'mobile': '60165544332',
          'notes': 'Old school friend',
          'address': 'Klang',
          'aura': 65,
        });

        batch.insert('contacts', {
          'name': 'Emily Chen',
          'mobile': '60134445566',
          'notes': 'Neighbour',
          'address': 'Damansara',
          'aura': 80,
        });

        batch.insert('contacts', {
          'name': 'Ryan Goh',
          'mobile': '60178889900',
          'notes': 'Football teammate',
          'address': 'Puchong',
          'aura': 75,
        });

        batch.insert('contacts', {
          'name': 'Jessica Yap',
          'mobile': '60121112233',
          'notes': 'University friend',
          'address': 'Cheras',
          'aura': 90,
        });

        // Get inserted contact IDs
        final contactResults = await batch.commit(
          noResult: false,
        );

        // Seed messages using actual inserted IDs
        final messages = txn.batch();

        final contactIds = contactResults.cast<int>();

        final messageData = [
          [0, 'Hey! Are we still meeting tomorrow?', 0],
          [0, 'Of course! What time works for you?', 1],
          [0, 'How about 7pm?', 0],
          [0, 'Sounds good. See you then!', 1],
          [1, 'Did you finish the project report?', 0],
          [1, 'Almost done. Just need to check a few things.', 1],
          [1, 'No worries. Let me know when it is ready.', 0],
          [2, 'Gym later?', 0],
          [2, 'Definitely. Leg day?', 1],
          [2, 'Haha yes!', 0],
          [3, 'I have some exciting news!', 0],
          [3, 'Tell me everything!', 1],
          [3, 'I got the job!', 0],
          [3, 'OMG congratulations!!!', 1],
          [4, 'Long time no see!', 0],
          [4, 'We should catch up sometime.', 1],
          [5, 'Can you help me with something?', 0],
          [5, 'Sure, what do you need?', 1],
          [6, 'Football this weekend?', 0],
          [6, 'Count me in!', 1],
          [7, 'Are you free for lunch tomorrow?', 0],
          [7, 'Yes! Lets go somewhere nice.', 1],
        ];

        for (final message in messageData) {
          messages.insert('messages', {
            'contact_id': contactIds[message[0] as int],
            'contents': message[1],
            'is_sender': message[2],
          });
        }

        await messages.commit(noResult: true);
      });
    }
  }

  // Get settings
  Future<Map<String, dynamic>?> getSettings() async {
    final db = await database;

    final result = await db.query(
      'settings',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first;
  }

  // Update settings
  Future<int> updateSettings({
    required String headerColor,
    required String lang,
  }) async {
    final db = await database;

    return await db.update(
      'settings',
      {
        'header_color': headerColor,
        'lang': lang,
      },
    );
  }

  // get contacts
  Future<List<Map<String, dynamic>>> getAllContacts() async {
    final db = await database;

    return await db.query(
      'contacts',
      orderBy: 'name ASC',
    );
  }

  // get contact by id
  Future<Map<String, dynamic>?> getContactById(int contactId) async {
    final db = await database;

    final result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [contactId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Map<String, dynamic>.from(result.first);
    }

    return null;
  }

  // get contact by id
  Future<Map<String, dynamic>?> getContactByMobile(String mobile) async {
    final db = await database;

    final result = await db.query(
      'contacts',
      where: 'mobile = ?',
      whereArgs: [mobile],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Map<String, dynamic>.from(result.first);
    }

    return null;
  }

  // get messages from contactid
  Future<List<Map<String, dynamic>>> getAllMessagesFromContactId(
    int contactId) async {
  final db = await database;

  return await db.query(
    'messages',
    where: 'contact_id = ?',
    whereArgs: [contactId],
    orderBy: 'created_at ASC',
  );
}

  Future<int> insertContact(Map<String, dynamic> data) async {
    final db = await database;

    return await db.insert('contacts', data);
  }

  Future<int> updateContact(Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      'contacts',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

 
Future<int> deleteContact(int contactId) async {
  final db = await database;

  return await db.transaction((txn) async {
    await txn.delete(
      'messages',
      where: 'contact_id = ?',
      whereArgs: [contactId],
    );

    return await txn.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [contactId],
    );
  });
}

  Future<Map<String, dynamic>> insertMessage(Map<String, dynamic> data) async {
    final db = await database;

    final id = await db.insert('messages', data);
    final inserted =  await db.query(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (inserted.isEmpty) throw Exception("Database is being sussy ah");

    return Map<String, dynamic>.from(inserted.first);

  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
