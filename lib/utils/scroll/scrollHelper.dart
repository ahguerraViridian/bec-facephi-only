import '../../base/enums/allEnums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollHelper {
  static void scrollToEnd(
    ScrollController scrollController,
    BuildContext context, {
    Duration delayDuration = const Duration(milliseconds: 300),
    Duration animationDuration = const Duration(milliseconds: 400),
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    });
  }

  static void scrollHalfScreen(
    ScrollController scrollController,
    BuildContext context, {
    Duration delayDuration = const Duration(milliseconds: 300),
    Duration animationDuration = const Duration(milliseconds: 400),
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    double halfScreen =
        scrollController.offset + MediaQuery.of(context).size.height * 0.35;
    double maxScrollPossible = scrollController.position.maxScrollExtent;
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(
          halfScreen > maxScrollPossible ? maxScrollPossible : halfScreen,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    });
  }

  static bool shouldScrollRecentActivity(
    RecentActivityType previousState,
    RecentActivityType newState,
  ) {
    bool shouldScroll = false;
    bool isRecentPreviousActivtyNone =
        previousState == RecentActivityType.NONE || previousState == null;
    // if nothing is selected before then scroll down
    shouldScroll =
        isRecentPreviousActivtyNone && newState != RecentActivityType.NONE;
    return shouldScroll;
  }

  static bool shouldScroll(bool previousValue, bool newValue) {
    return !previousValue && newValue;
  }
}
