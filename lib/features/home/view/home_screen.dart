import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';
import '../../../domain/entities/subscription_plan.dart';
import 'widgets/meal_card.dart';
import 'widgets/search_and_filters.dart';
import 'widgets/ai_picks_carousel.dart';
import 'widgets/daily_plan_panel.dart';
import 'widgets/debug_tier_menu.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize home controller when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authControllerProvider);
      if (authState.isAuthenticated) {
        final userId = authState.user?.uid ?? 'default';
        ref.read(homeControllerProvider(userId).notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    // Get user ID for home controller
    final userId = authState.user?.uid ?? 'default';
    final homeState = ref.watch(homeControllerProvider(userId));
    final homeController = ref.read(homeControllerProvider(userId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trikayo'),
        actions: [
          // User info
          if (authState.isAuthenticated) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    authState.isGuest ? Icons.person_outline : Icons.person,
                    color: authState.isGuest ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    authState.isGuest ? 'Guest' : 'User',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Sign out button
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authController.signOut();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
              tooltip: 'Sign Out',
            ),
          ],
          // Theme toggle
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => homeController.refresh(),
        child: CustomScrollView(
          slivers: [
            // Debug tier menu (only show in debug mode)
            if (authState.isAuthenticated)
              SliverToBoxAdapter(
                child: DebugTierMenu(
                  userId: userId,
                  currentTier: homeState.userTier,
                ),
              ),

            // Daily plan panel for Pro users
            if (homeState.userTier == PlanTier.pro)
              SliverToBoxAdapter(
                child: DailyPlanPanel(
                  userTier: homeState.userTier,
                  onUpgradeTap: () => context.push('/paywall'),
                ),
              ),

            // AI Picks carousel for Pro users
            if (homeState.userTier == PlanTier.pro)
              SliverToBoxAdapter(
                child: AiPicksCarousel(
                  aiPicks: homeState.aiPicks,
                  userTier: homeState.userTier,
                  onUpgradeTap: () => context.push('/paywall'),
                ),
              ),

            // Search and filters
            SliverToBoxAdapter(
              child: SearchAndFilters(
                searchQuery: homeState.searchQuery,
                selectedTags: homeState.selectedTags,
                selectedCuisines: homeState.selectedCuisines,
                minCalories: homeState.minCalories,
                maxCalories: homeState.maxCalories,
                availableTags: homeController.getAvailableTags(),
                availableCuisines: homeController.getAvailableCuisines(),
                onSearchChanged: homeController.searchMeals,
                onTagToggled: homeController.toggleTagFilter,
                onCuisineToggled: homeController.toggleCuisineFilter,
                onCalorieRangeChanged: homeController.setCalorieRange,
                onClearFilters: homeController.clearFilters,
              ),
            ),

            // Section header
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Discover Meals',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    if (homeState.filteredMeals.isNotEmpty)
                      Text(
                        '${homeState.filteredMeals.length} meals',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                  ],
                ),
              ),
            ),

            // Meals list
            if (homeState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (homeState.error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading meals',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          homeState.error!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => homeController.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (homeState.filteredMeals.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No meals found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => homeController.clearFilters(),
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final meal = homeState.filteredMeals[index];
                    return MealCard(
                      meal: meal,
                      userTier: homeState.userTier,
                      onTap: () {
                        // Navigate to meal details
                        context.push('/meal/${meal.id}');
                      },
                      onUpgradeTap: () => context.push('/paywall'),
                    );
                  },
                  childCount: homeState.filteredMeals.length,
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}
