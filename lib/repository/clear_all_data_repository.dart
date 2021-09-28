import 'dart:async';

import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_detail_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_header_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/Common/ps_repository.dart';

import '../viewobject/transaction_header.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<TransactionHeader>>>
          allListStream) async {
    final TransactionHeaderDao _transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao _transactionDetailDao =
        TransactionDetailDao.instance;
    await _transactionHeaderDao.deleteAll();
    await _transactionDetailDao.deleteAll();

    allListStream.sink
        .add(await _transactionHeaderDao.getAll(status: PsStatus.SUCCESS));
  }
}
