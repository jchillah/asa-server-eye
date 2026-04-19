// features/subscriptions/presentation/screens/premium_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/core/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/store_subscription_product.dart';
import '../../domain/subscription_plan.dart';
import '../../domain/subscription_status.dart';
import '../controllers/subscription_controller.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionControllerProvider);
    final controller = ref.read(subscriptionControllerProvider.notifier);

    ref.listen(subscriptionControllerProvider, (previous, next) {
      final message = next.errorMessage ?? next.lastPurchaseMessage;
      if (message == null || message.isEmpty) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));

        controller.clearMessages();
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.premiumTitle)),
      body: RefreshIndicator(
        onRefresh: controller.loadProducts,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HeroCard(
              title: context.l10n.premiumHeadline,
              description: context.l10n.premiumDescription,
            ),
            const SizedBox(height: 16),
            _BenefitCard(
              title: context.l10n.premiumBenefitSightingsTitle,
              description: context.l10n.premiumBenefitSightingsDescription,
              icon: Icons.visibility_outlined,
            ),
            const SizedBox(height: 12),
            _BenefitCard(
              title: context.l10n.premiumBenefitFavoritesTitle,
              description: context.l10n.premiumBenefitFavoritesDescription,
              icon: Icons.star_outline_rounded,
            ),
            const SizedBox(height: 12),
            _BenefitCard(
              title: context.l10n.premiumBenefitAlertsTitle,
              description: context.l10n.premiumBenefitAlertsDescription,
              icon: Icons.notifications_active_outlined,
            ),
            const SizedBox(height: 20),
            if (state.status == SubscriptionStatus.loading &&
                state.products.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.status == SubscriptionStatus.unavailable)
              _InfoCard(message: context.l10n.premiumStoreUnavailable)
            else if (state.products.isEmpty)
              _InfoCard(message: context.l10n.premiumProductsUnavailable)
            else
              ...state.products.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ProductCard(
                    product: product,
                    isLoading: state.status == SubscriptionStatus.purchasing,
                    onPressed: () => controller.buy(product),
                    buttonLabel: product.plan == SubscriptionPlan.monthly
                        ? context.l10n.premiumStartMonthly
                        : context.l10n.premiumStartYearly,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            AppActionButton(
              label: context.l10n.restorePurchases,
              isLoading: state.status == SubscriptionStatus.restoring,
              variant: AppActionButtonVariant.secondary,
              onPressed: controller.restorePurchases,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(description, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.isLoading,
    required this.onPressed,
    required this.buttonLabel,
  });

  final StoreSubscriptionProduct product;
  final bool isLoading;
  final Future<void> Function() onPressed;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(product.title),
              subtitle: Text(product.description),
              trailing: Text(product.price),
            ),
            const SizedBox(height: 8),
            AppActionButton(
              label: buttonLabel,
              isLoading: isLoading,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(message)),
    );
  }
}
