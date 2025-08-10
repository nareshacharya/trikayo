import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/meal.dart';
import '../../../../domain/entities/subscription_plan.dart';
import 'meal_card.dart';

class AiPicksCarousel extends ConsumerWidget {
  final List<Meal> aiPicks;
  final PlanTier? userTier;
  final VoidCallback? onUpgradeTap;

  const AiPicksCarousel({
    super.key,
    required this.aiPicks,
    this.userTier,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasAiPicksAccess = userTier == PlanTier.pro;

    if (!hasAiPicksAccess) {
      return _buildUpgradeSection(theme);
    }

    if (aiPicks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.amber[600],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Picks for You',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${aiPicks.length} recommendations',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: aiPicks.length,
            itemBuilder: (context, index) {
              final meal = aiPicks[index];
              return SizedBox(
                width: 280,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < aiPicks.length - 1 ? 16 : 0,
                  ),
                  child: MealCard(
                    meal: meal,
                    userTier: userTier,
                    onTap: () {
                      // Navigate to meal details
                      context.push('/meal/${meal.id}');
                    },
                    onUpgradeTap: onUpgradeTap,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpgradeSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Unlock AI-Powered Recommendations',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Get personalized meal suggestions based on your preferences, dietary restrictions, and nutrition goals.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onUpgradeTap,
            icon: const Icon(Icons.star),
            label: const Text('Upgrade to Pro'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
