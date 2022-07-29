import 'package:bottleshop_admin/constants/constants.dart';
import 'package:bottleshop_admin/core/data/services/database_service.dart';
import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/features/orders/data/services.dart';
import 'package:bottleshop_admin/models/admin_user_model.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/orders_step.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class OrdersRepository {
  static const int ordersPerPagination = 10;

  final ProviderReference _providerRef;

  OrdersRepository(this._providerRef);

  Future<void> takeOverTheOrder(
    OrderModel order,
    AdminUserModel adminUser,
  ) async {
    return ordersDbService.updateData(
      order.uniqueId,
      {
        OrderModel.preparingAdminRefField: FirebaseFirestore.instance
            .collection(Constants.adminUsersCollection)
            .doc(adminUser.uid)
      },
    );
  }

  Future<void> cancelOrderTakeOver(
    OrderModel order,
  ) async {
    return ordersDbService.updateData(
      order.uniqueId,
      {OrderModel.preparingAdminRefField: FieldValue.delete()},
    );
  }

  Future<void> changeOrderToFollowingState(OrderModel order) async {
    final serverTimestamp = await _providerRef
        .read(cloudFunctionsServiceProvider)
        .getServerTimestamp();

    return ordersDbService.updateData(
      order.uniqueId,
      {
        OrderModel.statusStepIdField: order.getFollowingStatusId,
        OrderModel.statusTimestampsField: FieldValue.arrayUnion(
          [serverTimestamp],
        ),
//              FieldValue.arrayUnion([FieldValue.serverTimestamp()]),
      },
    ); // arrayUnion with server FieldValue.serverTimestamp cannot be done from here. Restriction of the SDK.
  }

  Stream<PagedItemsStateStreamBatch<OrderModel, DocumentSnapshot>>
      getAllPagedOrdersStream(
    DocumentSnapshot? lastDocument,
    OrderStep orderStep,
    bool descending,
  ) {
    return ordersDbService.streamQueryListWithChanges(
      args: [
        QueryArgs(OrderModel.statusStepIdField, isEqualTo: orderStep.index)
      ],
      orderBy: [
        OrderBy(OrderModel.createdAtTimestampField, descending: descending)
      ],
      limit: ordersPerPagination,
      startAfterDocument: lastDocument,
    ).map(
      (snap) => PagedItemsStateStreamBatch(
        snap
            .map(
              (e) => Tuple3(
                ChangeStatusUtil.convertFromFirestoreChange(e.item1),
                e.item2,
                e.item3,
              ),
            )
            .toList(),
      ),
    );
  }
}
