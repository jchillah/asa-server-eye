// app/presentation/controllers/app_shell_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appShellIndexProvider = NotifierProvider<AppShellController, int>(
  AppShellController.new,
);

final shouldSyncServersProvider = Provider<bool>((ref) {
  final currentIndex = ref.watch(appShellIndexProvider);
  return currentIndex == 0 || currentIndex == 1 || currentIndex == 2;
});

class AppShellController extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}
