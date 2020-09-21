
import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  bool _available = true;
  final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  // StreamSubscription<List<PurchaseDetails>> _subscription;
  Set<String> _kIds = {'remove_ads_daily'};

  init() async {
    Stream purchaseUpdated = _iap.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _purchases = purchaseDetailsList;
    }, onDone: () {
      // print(['handlePurchaseaaaaaaaa']);
      _subscription.cancel();
    }, onError: (error) {
      print(['listenToPurchaseUpdated', error]);
    });

    _available = await _iap.isAvailable();

    if (_available) {
      await _getProducts();
      await _getPastPurchases();
    }
  }
  Future<void> _getProducts() async {
    // Set<String> ids = Set.from(['removes_ads']);
    ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print(['not found ID product']);
    }
    _products = response.productDetails;
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();
    // print(['past', response]);
    for (PurchaseDetails purchase in response.pastPurchases) {
      final pending = Platform.isIOS
        ? purchase.pendingCompletePurchase
        : !purchase.billingClientPurchase.isAcknowledged;

        if (pending) {
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
    }

    _purchases = response.pastPurchases;
  }

  /// Your own business logic to setup a consumable
  verifyPurchase(String id) {
    PurchaseDetails purchase = _purchases.firstWhere( (purchase) => purchase.productID == id, orElse: () => null);
    // print(purchase);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print('Đã mua remove_ads');
      return true;
    } else {
      print('chưa mua remove_ads');
      return false;
    }
  }

  /// Purchase a product
  buyProduct(String id) async {
    var prod = _products.where((o) => o.id == id).toList();
    // print(prod);
    if(prod.length != 0){
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod[0]);
      await _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
      await _getPastPurchases();
    }
  }
}