import 'dart:async';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_detail_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_header_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/user_login_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/Common/ps_repository.dart';

import 'package:flutterrtdeliveryboyapp/viewobject/user_login.dart';

class DeleteTaskRepository extends PsRepository {
  Future<dynamic> deleteTask(
      StreamController<PsResource<List<UserLogin>>> allListStream) async {
    final UserLoginDao _userLoginDao = UserLoginDao.instance;
    final TransactionHeaderDao _transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao _transactionDetailDao =
        TransactionDetailDao.instance;
    await _userLoginDao.deleteAll();
    await _transactionHeaderDao.deleteAll();
    await _transactionDetailDao.deleteAll();

    allListStream.sink
        .add(await _userLoginDao.getAll(status: PsStatus.SUCCESS));
  }
}
