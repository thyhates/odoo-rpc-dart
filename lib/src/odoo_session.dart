/// Odoo Session Object

/// Represents session with Odoo server.
class OdooSession {
  /// Current Session id
  final String id;

  /// User's database id
  final int userId;


  /// User's company database id
  final int companyId;

  /// User's login
  final String userLogin;


  /// User's language
  final String userLang;

  /// User's Time zone
  final String userTz;


  /// Database name
  final String dbName;

  /// Server Major version
  final String serverVersion;

  /// [OdooSession] is immutable.
  const OdooSession({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.userLogin,
    required this.userLang,
    required this.userTz,
    required this.dbName,
    required this.serverVersion,
  });

  /// Creates [OdooSession] instance from odoo session info object.
  static OdooSession fromSessionInfo(Map<String, dynamic> info) {
    final ctx = info['user_context'] as Map<String, dynamic>;
    List<dynamic> versionInfo;
    versionInfo = [8];
    if (info.containsKey('server_version_info')) {
      versionInfo = info['server_version_info'];
    }
    return OdooSession(
      id: info['id'] as String? ?? '',
      userId: info['uid'] as int,
      companyId: info['company_id'] as int,
      userLogin: info['username'] as String,
      userLang: ctx['lang'] as String,
      userTz: ctx['tz'] is String ? ctx['tz'] as String : 'UTC',
      dbName: info['db'] as String,
      serverVersion: versionInfo[0].toString(),
    );
  }

  /// Stores [OdooSession] to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'companyId': companyId,
      'userLogin': userLogin,
      'userLang': userLang,
      'userTz': userTz,
      'dbName': dbName,
      'serverVersion': serverVersion,
    };
  }

  /// Restore [OdooSession] from JSON
  static OdooSession fromJson(Map<String, dynamic> json) {
    return OdooSession(
      id: json['id'] as String,
      userId: json['userId'] as int,
      companyId: json['companyId'] as int,
      userLogin: json['userLogin'] as String,
      userLang: json['userLang'] as String,
      userTz: json['userTz'] as String,
      dbName: json['dbName'] as String,
      serverVersion: json['serverVersion'].toString(),
    );
  }

  /// Returns new OdooSession instance with updated session id
  OdooSession updateSessionId(String newSessionId) {
    return OdooSession(
      id: newSessionId,
      userId: newSessionId == '' ? 0 : userId,
      companyId: newSessionId == '' ? 0 : companyId,
      userLogin: newSessionId == '' ? '' : userLogin,
      userLang: newSessionId == '' ? '' : userLang,
      userTz: newSessionId == '' ? '' : userTz,
      dbName: newSessionId == '' ? '' : dbName,
      serverVersion: newSessionId == '' ? '' : serverVersion,
    );
  }

  /// [serverVersionInt] returns Odoo server major version as int.
  /// It is useful for for cases like
  /// ```dart
  /// final image_field = session.serverVersionInt >= 13 ? 'image_128' : 'image_small';
  /// ```
  int get serverVersionInt {
    // Take last two chars for name like 'saas~14'
    final serverVersionSanitized = serverVersion.length == 1
        ? serverVersion
        : serverVersion.substring(serverVersion.length - 2);
    return int.tryParse(serverVersionSanitized) ?? -1;
  }

  /// String representation of [OdooSession] object.
  @override
  String toString() {
    return 'OdooSession {userName: $userLogin, userLogin: $userLogin, userId: $userId, companyId: $companyId, id: $id}';
  }
}
