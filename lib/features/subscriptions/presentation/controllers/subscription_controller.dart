// features/subscriptions/presentation/controllers/subscription_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../auth/presentation/providers/current_user_provider.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../data/repositories/subscription_verification_request_repository.dart';
import '../../domain/store_subscription_product.dart';
import '../../domain/subscription_status.dart';
import '../providers/subscription_entitlement_providers.dart';
import '../providers/subscription_providers.dart';

final subscriptionControllerProvider =
    StateNotifierProvider.autoDispose<
      SubscriptionController,
      SubscriptionState
    >((ref) {
      final repository = ref.watch(subscriptionRepositoryProvider);
      final verificationRepository = ref.watch(
        subscriptionVerificationRequestRepositoryProvider,
      );
      final currentUser = ref.watch(currentUserProvider);

      return SubscriptionController(
        repository,
        verificationRepository: verificationRepository,
        currentUserId: currentUser?.uid,
      );
    });

class SubscriptionState {
  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.products = const [],
    this.errorMessage,
    this.lastPurchaseMessage,
  });

  final SubscriptionStatus status;
  final List<StoreSubscriptionProduct> products;
  final String? errorMessage;
  final String? lastPurchaseMessage;

  bool get isLoading =>
      status == SubscriptionStatus.loading ||
      status == SubscriptionStatus.purchasing ||
      status == SubscriptionStatus.restoring;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<StoreSubscriptionProduct>? products,
    String? errorMessage,
    String? lastPurchaseMessage,
    bool clearErrorMessage = false,
    bool clearLastPurchaseMessage = false,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      lastPurchaseMessage: clearLastPurchaseMessage
          ? null
          : lastPurchaseMessage ?? this.lastPurchaseMessage,
    );
  }
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  SubscriptionController(
    this._repository, {
    required SubscriptionVerificationRequestRepository verificationRepository,
    required String? currentUserId,
  }) : _verificationRepository = verificationRepository,
       _currentUserId = currentUserId,
       super(const SubscriptionState()) {
    _listenToPurchases();
    unawaited(loadProducts());
  }

  final SubscriptionRepository _repository;
  final SubscriptionVerificationRequestRepository _verificationRepository;
  final String? _currentUserId;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  Future<void> loadProducts() async {
    state = state.copyWith(
      status: SubscriptionStatus.loading,
      clearErrorMessage: true,
      clearLastPurchaseMessage: true,
    );

    try {
      final isAvailable = await _repository.isAvailable();
      if (!isAvailable) {
        state = state.copyWith(
          status: SubscriptionStatus.unavailable,
          errorMessage: 'Store unavailable',
        );
        return;
      }

      final products = await _repository.loadProducts();

      state = state.copyWith(
        status: SubscriptionStatus.ready,
        products: products,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: SubscriptionStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> buy(StoreSubscriptionProduct product) async {
    state = state.copyWith(
      status: SubscriptionStatus.purchasing,
      clearErrorMessage: true,
      clearLastPurchaseMessage: true,
    );

    try {
      await _repository.buy(product);
    } catch (error) {
      state = state.copyWith(
        status: SubscriptionStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(
      status: SubscriptionStatus.restoring,
      clearErrorMessage: true,
      clearLastPurchaseMessage: true,
    );

    try {
      await _repository.restorePurchases();
    } catch (error) {
      state = state.copyWith(
        status: SubscriptionStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(
      clearErrorMessage: true,
      clearLastPurchaseMessage: true,
    );
  }

  void _listenToPurchases() {
    _purchaseSubscription = _repository.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          await _handlePurchaseUpdate(purchase);
        }
      },
      onError: (error) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchase) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        state = state.copyWith(
          status: SubscriptionStatus.purchasing,
          lastPurchaseMessage: 'Purchase pending',
        );
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        await _submitVerificationRequest(purchase);
        await _repository.completePurchase(purchase);

        state = state.copyWith(
          status: SubscriptionStatus.completed,
          lastPurchaseMessage: purchase.status == PurchaseStatus.restored
              ? 'Purchase restored and sent for verification'
              : 'Purchase sent for verification',
        );
        break;

      case PurchaseStatus.canceled:
        state = state.copyWith(
          status: SubscriptionStatus.ready,
          lastPurchaseMessage: 'Purchase canceled',
        );
        break;

      case PurchaseStatus.error:
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: purchase.error?.message ?? 'Purchase failed',
        );
        break;
    }
  }

  Future<void> _submitVerificationRequest(PurchaseDetails purchase) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw StateError('No authenticated user for purchase verification.');
    }

    final purchaseId = purchase.purchaseID;
    final purchaseToken = purchase.verificationData.serverVerificationData;

    if (purchaseId == null || purchaseId.isEmpty) {
      throw StateError('Missing purchase ID.');
    }

    if (purchaseToken.isEmpty) {
      throw StateError('Missing purchase token.');
    }

    await _verificationRepository.submitVerificationRequest(
      userId: userId,
      platform: Platform.isIOS ? 'ios' : 'android',
      productId: purchase.productID,
      purchaseId: purchaseId,
      purchaseToken: purchaseToken,
    );
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
