import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/presentation/controllers/tracking_controller.dart';

final followControllerProvider = NotifierProvider<FollowController, bool>(
  FollowController.new,
);

class FollowController extends Notifier<bool> {
  @override
  bool build() {
    ref.listen<bool>(isTrackingProvider, (_, tracking) => state = tracking);
    return ref.read(isTrackingProvider);
  }

  void follow() => state = true;

  void stopFollowing() {
    if (state) state = false;
  }
}
