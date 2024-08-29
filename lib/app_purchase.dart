import 'dart:async';

import 'package:demo_purchase/constant.dart';
import 'package:demo_purchase/models/purchaseable_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'models/store_state.dart';
class IAPConnection {
  static InAppPurchase? _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}
class AppPurchase extends ChangeNotifier {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnect = IAPConnection.instance;
  StoreState storeState = StoreState.loading;
  List<PurchasableProduct> products = [];

  AppPurchase(){
    final purchaseUpdated = iapConnect.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updatedStreamDone,
      onError: _updatedStreamError,
    );
    loadPurchases();
  }



  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);

    if(subscriptionIds.contains(product.id)){
      iapConnect.buyNonConsumable(purchaseParam: purchaseParam);
      return;
    }
    iapConnect.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> loadPurchases() async {
    final available = await iapConnect.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    final ids = {...consumableIds.toSet(),...subscriptionIds.toSet()};
    final res = await iapConnect.queryProductDetails(ids);

    products = res.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();
  }


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for(var purchase in purchaseDetailsList){
      await _handlePurchase(purchase);
    }
    notifyListeners();
  }

   Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if(purchase.status == PurchaseStatus.purchased){

    }

    if(purchase.pendingCompletePurchase){
      await iapConnect.completePurchase(purchase);
    }
  }

  void _updatedStreamDone() {
    _subscription.cancel();
  }

  _updatedStreamError() {
    ///handle Error
  }
}