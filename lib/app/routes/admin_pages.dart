import 'package:get/get.dart';
// UPDATED IMPORT: Make sure it points to your single auth module file.
import '../modules/auth/auth_admin_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/challenges/add_challenge_view.dart';
import '../modules/challenges/challenges_admin_view.dart';
import '../modules/dashboard/dashboard_admin_view.dart';
import '../modules/events/add_event_view.dart';
import '../modules/events/event_admin_binding.dart';
import '../modules/events/events_admin_view.dart';
import '../modules/main/admin_main_binding.dart' hide AdminMainBinding;
import '../modules/main/admin_main_view.dart';
import '../modules/settings/settings_admin_view.dart';
import '../modules/users/user_detail_view.dart';
import '../modules/users/users_admin_view.dart';
import 'admin_routes.dart';

class AdminPages {
  static const INITIAL = Routes.AUTH;

  static final routes = [
    // THIS IS THE FIX:
    // This GetPage entry now correctly links the AuthView from your single file
    // with its corresponding AuthBinding.
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthAdminView(),
      binding: AuthBinding(),
    ),

    GetPage(name: Routes.MAIN, page: () => const AdminMainView(), binding: AdminMainBinding()),
    GetPage(name: Routes.DASHBOARD, page: () => const DashboardAdminView()),
    GetPage(name: Routes.CHALLENGES, page: () => const ChallengesAdminView(), ),
    GetPage(name: Routes.ADD_CHALLENGE, page: () => const AddChallengeView(), transition: Transition.downToUp),
    GetPage(name: Routes.EVENTS, page: () => const EventsAdminView()),
    GetPage(name: Routes.ADD_EVENT, page: () => const AddEventView(), transition: Transition.downToUp),
    GetPage(name: Routes.USERS, page: () => const UsersAdminView()),
    GetPage(name: Routes.USER_DETAIL, page: () => const UserDetailView()),
    GetPage(name: Routes.SETTINGS, page: () => const SettingsAdminView()),
  ];
}

