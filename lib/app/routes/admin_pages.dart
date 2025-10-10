// lib/routes/admin_pages.dart

import 'package:get/get.dart';
import 'package:gmfc_admin/app/modules/dashboard/dashboard_binding.dart';
import 'package:gmfc_admin/app/modules/users/user_admin_binding.dart';
import '../modules/active_users/active_users_binding.dart';
import '../modules/active_users/active_users_view.dart';
import '../modules/admin_code_feed/add_feed_post_view.dart';
import '../modules/admin_code_feed/feed_admin_view.dart';
import '../modules/admin_code_feed/feed_binding.dart';
import '../modules/auth/auth_admin_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/challenges/add_challenge_view.dart';
import '../modules/challenges/challanges_binding.dart';
import '../modules/challenges/challenges_admin_view.dart';
import '../modules/dashboard/dashboard_admin_view.dart';
import '../modules/events/add_event_view.dart';
import '../modules/events/events_admin_view.dart';
import '../modules/main/admin_main_binding.dart';
import '../modules/main/admin_main_view.dart' hide DashboardAdminView;
import '../modules/manage_practice/manage_practice_binding.dart';
import '../modules/manage_practice/manage_practice_view.dart';
import '../modules/manage_practice/problem/manage_problems_binding.dart';
import '../modules/manage_practice/problem/manage_problems_view.dart';
import '../modules/settings/settings_admin_binding.dart';
import '../modules/settings/settings_admin_view.dart';
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
    GetPage(
      name: Routes.FEED,
      page: () => const FeedAdminView(),
      binding: FeedAdminBinding(),
    ),
    GetPage(
      name: Routes.ADD_FEED_POST,
      page: () => const AddFeedPostView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardAdminView(),
      binding: DashboardAdminBinding()
    ),
    GetPage(
      name: Routes.CHALLENGES,
      page: () => const ChallengesAdminView(),
      binding: ChallengesBinding(),
    ),
    GetPage(
      name: Routes.ADD_CHALLENGE,
      page: () => const AddChallengeView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.EVENTS,
      page: () => const EventsAdminView(),
    ),
    GetPage(
      name: Routes.ADD_EVENT,
      page: () => const AddEventView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.USERS,
      page: () => const UsersAdminView(),
      binding: UsersAdminBinding()
    ),
    GetPage(
      name: Routes.USER_DETAIL,
      page: () => const UserDetailView(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsAdminView(),
      binding: SettingsAdminBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_PRACTICE,
      page: () => const ManagePracticeView(),
      binding: ManagePracticeBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_PRACTICE_PROBLEMS,
      page: () => const ManageProblemsView(),
      binding: ManageProblemsBinding(),
    ),
    GetPage(
      name: Routes.ACTIVE_USERS,
      page: () => const ActiveUsersView(),
      binding: ActiveUsersBinding(),
    ),

  ];
}