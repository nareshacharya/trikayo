import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/view/auth_screen.dart';
import '../../features/catalog/view/catalog_screen.dart';
import '../../features/meal_details/view/meal_details_screen.dart';
import '../../features/checkout/view/checkout_screen.dart';
import '../../features/post_meal/view/post_meal_screen.dart';
import '../../features/paywall/view/paywall_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/auth/controller/auth_controller.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // If user is authenticated and trying to access auth screen, redirect to home
      if (authState.isAuthenticated && state.matchedLocation == '/auth') {
        return '/home';
      }

      // If user is not authenticated and trying to access protected routes, redirect to auth
      if (!authState.isAuthenticated && state.matchedLocation != '/auth') {
        return '/auth';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/catalog',
        name: 'catalog',
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        path: '/meal/:id',
        name: 'meal_details',
        builder: (context, state) {
          final mealId = state.pathParameters['id']!;
          return MealDetailsScreen(mealId: mealId);
        },
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/post-meal',
        name: 'post_meal',
        builder: (context, state) => const PostMealScreen(),
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
