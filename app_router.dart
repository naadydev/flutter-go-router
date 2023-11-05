import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Docs => https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html
//      => https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3

// Using pathParameters
// - When you know the number of parameters beforehand
//   - Usage : path = '/routeName/:id1/:id2'
// - Using queryParameters
//   - When you are not sure about the number of parameters
//    - Usage : path = '/routeName'
// - Using extra
//   - When you want to pass object

GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    const isAuthenticated = true; // your logic to check if user is authenticated
    if (!isAuthenticated) {
      return '/login';
    } else {
      return null; // return "null" to display the intended route without redirecting
    }
  },
  observers: [
    // Add your navigator observers
    MyNavigatorObserver(),
  ],
  routes: [
    GoRoute(
      name: 'userProfile',
      path: '/users/:id1/:id2',
      builder: (context, state) => ProfileScreen(
        id1: state.pathParameters['id1']!,
        id2: state.pathParameters['id2']!,
        qParam1: state.uri.queryParameters['qParam1']!,
        qParam2: state.uri.queryParameters['qParam2']!,
      ),
    ),
    GoRoute(
      path: '/fruits',
      builder: (context, state) => Scaffold(appBar: AppBar(title: const Text('Fruits Screen'))),
      routes: <RouteBase>[
        // Add child routes
        GoRoute(
          name: 'fruit-detail',
          path: 'fruits-details', // NOTE: Don't need to specify "/" character for router’s parents
          builder: (context, state) {
            return Scaffold(appBar: AppBar(title: const Text('Fruit Details Screen')));
          },
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeScreenXX')),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text("Go => Profile"),
            onPressed: () {
              context.goNamed(
                "userProfile",
                pathParameters: {'id1': '11', 'id2': '22'},
                queryParameters: {'qParam1': 'val1', 'qParam2': 'val2'},
                extra: Employee(name: 'Nady', age: 30),
              );
              // context.go(Uri(path: '/users', queryParameters: {'id1': '11', 'id2': '22'}).toString());
              // OR
              // context.go('/users', extra: 'anyObject12');
            },
          ),
          ElevatedButton(
            child: const Text("fruit-detail"),
            onPressed: () {
              context.go('/fruits/fruit-detail');
              // OR
              // context.goNamed('fruit-detail');
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String id1;
  final String id2;
  final String qParam1;
  final String qParam2;

  const ProfileScreen({super.key, required this.id1, required this.id2, required this.qParam1, required this.qParam2});

  @override
  Widget build(BuildContext context) {
    // Retrieve Extra data from GoRouterState
    final extraObj = GoRouterState.of(context).extra! as Employee;
    // We can pop the current screen via context.pop().

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Screen')),
      body: Column(
        children: [
          Text('userId1:$id1'),
          const Divider(),
          Text('userId2:$id2'),
          const Divider(),
          Text('qParam1:$qParam1'),
          const Divider(),
          Text('qParam2:$qParam2'),
          const Divider(),
          Text('extraObj:${extraObj.name}'),
          const Divider(),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginScreen')),
      body: const Column(
        children: [
          Text('LoginScreen'),
        ],
      ),
    );
  }
}

class Employee {
  final String name;
  final int age;

  Employee({required this.name, required this.age});
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('did push route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('did pop route');
  }
}
// ----
// Adding Router
// MaterialApp.router(
//   ...
//   routerConfig: appRouter,
//   ...
// )
