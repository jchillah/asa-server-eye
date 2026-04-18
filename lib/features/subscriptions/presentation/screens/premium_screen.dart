// features/subscriptions/presentation/screens/premium_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/core/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.premiumTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.premiumHeadline,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.premiumDescription,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _PlanTile(
                    title: context.l10n.premiumMonthlyPlan,
                    subtitle: context.l10n.premiumMonthlyPlanDescription,
                  ),
                  const SizedBox(height: 12),
                  AppActionButton(
                    label: context.l10n.premiumStartMonthly,
                    isLoading: false,
                    onPressed: () async {
                      _showComingSoon(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  _PlanTile(
                    title: context.l10n.premiumYearlyPlan,
                    subtitle: context.l10n.premiumYearlyPlanDescription,
                  ),
                  const SizedBox(height: 12),
                  AppActionButton(
                    label: context.l10n.premiumStartYearly,
                    isLoading: false,
                    onPressed: () async {
                      _showComingSoon(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  AppActionButton(
                    label: context.l10n.restorePurchases,
                    isLoading: false,
                    variant: AppActionButtonVariant.secondary,
                    onPressed: () async {
                      _showComingSoon(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.premiumPurchaseComingSoon)),
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

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
