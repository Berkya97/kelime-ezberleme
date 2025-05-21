import 'package:hive/hive.dart';
import '../models/user.dart';

class UserService {
  static Box<User> get _box => Hive.box<User>('users');

  /// Yeni bir kullanıcı ekler. Hive kendi 32-bit anahtarını (0,1,2…) otomatik atar.
  /// Dönen değer, Hive’in atadığı key’dir.
  static Future<int> addUser(User u) async {
    return await _box.add(u);
  }

  /// userID alanına göre kullanıcı bulur.
  static User? getUser(int id) {
    try {
      return _box.values.firstWhere((u) => u.userID == id);
    } catch (_) {
      return null;
    }
  }

  /// Tüm kullanıcıları listeler.
  static List<User> getAllUsers() => _box.values.toList();

  /// userID alanına göre kullanıcıyı siler.
  static Future<void> deleteUser(int id) async {
    // Silinecek kullanıcının Hive key’ini bul
    final key = _box.keys.firstWhere(
          (k) {
        final u = _box.get(k) as User;
        return u.userID == id;
      },
      orElse: () => null,
    );
    if (key != null) {
      await _box.delete(key);
    }
  }
}
