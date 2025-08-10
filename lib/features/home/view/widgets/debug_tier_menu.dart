import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/subscription_plan.dart';
import '../../../../services/subscription_service.dart';

class DebugTierMenu extends ConsumerStatefulWidget {
  final String userId;
  final PlanTier? currentTier;

  const DebugTierMenu({
    super.key,
    required this.userId,
    this.currentTier,
  });

  @override
  ConsumerState<DebugTierMenu> createState() => _DebugTierMenuState();
}

class _DebugTierMenuState extends ConsumerState<DebugTierMenu> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Debug menu toggle button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.developer_mode,
                    size: 16,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Debug: ${widget.currentTier?.name.toUpperCase() ?? 'BASIC'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.orange[700],
                  ),
                ],
              ),
            ),
          ),

          // Debug menu content
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Tier Menu',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Current User ID: ${widget.userId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current Tier: ${widget.currentTier?.name.toUpperCase() ?? 'BASIC'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tier selection buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PlanTier.values.map((tier) {
                      final isSelected = widget.currentTier == tier;
                      return ElevatedButton(
                        onPressed: () => _changeTier(tier),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          foregroundColor: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          tier.name.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Current debug state
                  Text(
                    'Debug State:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: MockSubscriptionService.getDebugTiers()
                          .entries
                          .map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '${entry.key}: ${entry.value.name.toUpperCase()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Reset button
                  OutlinedButton.icon(
                    onPressed: _resetTiers,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset to Default'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _changeTier(PlanTier tier) {
    MockSubscriptionService.setDebugTier(widget.userId, tier);

    // Show snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Changed ${widget.userId} to ${tier.name.toUpperCase()} tier'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Force rebuild
    setState(() {});
  }

  void _resetTiers() {
    // Reset to default tiers
    MockSubscriptionService.setDebugTier('user1', PlanTier.basic);
    MockSubscriptionService.setDebugTier('user2', PlanTier.plus);
    MockSubscriptionService.setDebugTier('user3', PlanTier.pro);
    MockSubscriptionService.setDebugTier('default', PlanTier.basic);

    // Show snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset all tiers to default'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Force rebuild
    setState(() {});
  }
}
