import 'package:flutterrtdeliveryboyapp/db/common/ps_dao.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_map.dart';
import 'package:sembast/sembast.dart';

class TransactionMapDao extends PsDao<TransactionMap> {
  TransactionMapDao._() {
    init(TransactionMap());
  }
  static const String STORE_NAME = 'TransactionMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final TransactionMapDao _singleton = TransactionMapDao._();

  // Singleton accessor
  static TransactionMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(TransactionMap object) {
    return object.id;
  }

  @override
  Filter getFilter(TransactionMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
