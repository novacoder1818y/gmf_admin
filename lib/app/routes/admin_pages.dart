import 'package:get/get.dart';
import '../modules/auth/auth_admin_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/challenges/add_challenge_view.dart';
import '../modules/challenges/challenges_admin_view.dart';
import '../modules/dashboard/dashboard_admin_view.dart';
import '../modules/events/add_event_view.dart';
import '../modules/events/events_admin_view.dart';
import '../modules/main/admin_main_binding.dart';
import '../modules/main/admin_main_view.dart';
import '../modules/settings/settings_admin_view.dart';

// 1. ADD THIS IMPORT
import '../modules/settings/settings_admin_binding.dart';
import '../modules/users/user_detail_view.dart';
import '../modules/users/users_admin_view.dart';
import 'admin_routes.dart';

class AdminPages {
  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthAdminView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: Routes.MAIN,
      page: () => const AdminMainView(),
      binding: AdminMainBinding(),
    ),
    GetPage(name: Routes.DASHBOARD, page: () => const DashboardAdminView()),
    GetPage(name: Routes.CHALLENGES, page: () => const ChallengesAdminView()),
    GetPage(
      name: Routes.ADD_CHALLENGE,
      page: () => const AddChallengeView(),
      transition: Transition.downToUp,
    ),
    GetPage(name: Routes.EVENTS, page: () => const EventsAdminView()),
    GetPage(
      name: Routes.ADD_EVENT,
      page: () => const AddEventView(),
      transition: Transition.downToUp,
    ),
    GetPage(name: Routes.USERS, page: () => const UsersAdminView()),
    GetPage(name: Routes.USER_DETAIL, page: () => const UserDetailView()),

    // 2. UPDATE THIS LINE
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsAdminView(),
      binding: SettingsAdminBinding(),
    ),
  ];
}
