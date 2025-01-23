import 'package:auto_route/auto_route.dart';

import '../3_domain/repositories/database/auth_repository.dart';
import '../injection.dart';
import 'router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final authRepo = sl<AuthRepository>();
    final isAuthenticated = authRepo.checkIfUserIsSignedIn();

    if (isAuthenticated) {
      resolver.next(true);
    } else {
      router.replaceAll([const SignInRoute()]);
    }
  }
}
