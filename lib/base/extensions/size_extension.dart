import 'dart:ui';

extension ResponsiveSize on num {
  double get h {
    final height = PlatformDispatcher.instance.views.first.physicalSize.height /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    return this * (height / 100);
  }

  double get w {
    final width = PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    return this * (width / 100);
  }
}
