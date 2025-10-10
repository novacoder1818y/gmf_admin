import 'package:get/get.dart';
import 'feed_controller.dart';

class FeedAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedAdminController>(() => FeedAdminController());
  }
}
