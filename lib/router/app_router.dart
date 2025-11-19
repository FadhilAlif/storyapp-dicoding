import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/pages/add_story_page.dart';
import 'package:storyapp_dicoding/pages/home_page.dart';
import 'package:storyapp_dicoding/pages/login_page.dart';
import 'package:storyapp_dicoding/pages/register_page.dart';
import 'package:storyapp_dicoding/pages/story_detail_page.dart';
import 'package:storyapp_dicoding/providers/auth_provider.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn = authProvider.isLoggedIn;

        final loggingIn = state.matchedLocation == '/login';
        final registering = state.matchedLocation == '/register';

        // If user is not logged in and not on login or register page, redirect to login
        if (!isLoggedIn && !loggingIn && !registering) {
          return '/login';
        }

        // If user is logged in and tries to access login or register page, redirect to home
        if (isLoggedIn && (loggingIn || registering)) {
          return '/';
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
          routes: [
            GoRoute(
              path: 'story/:id',
              builder: (BuildContext context, GoRouterState state) {
                return StoryDetailPage(storyId: state.pathParameters['id']!);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/add-story',
          builder: (BuildContext context, GoRouterState state) {
            return const AddStoryPage();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
      ],
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
    );
  }
}
