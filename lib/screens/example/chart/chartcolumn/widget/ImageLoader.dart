import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class ImageLoader {
  ImageLoader._();

  static final _instance = ImageLoader._();

  factory ImageLoader.getInstance() => _instance;

  Map<String, ui.Image> imagePool = {};

  static const markUpCenter = 'mark_up_center';
  static const markUpTriangle = 'mark_up_Triangle';
  static const markUpLeft = 'mark_up_left';
  static const markUpRight = 'mark_up_right';

  void preCacheImage() {
    load('assets/density3x/ic_markup_1_center.png').then((value) {
      imagePool.addAll({markUpCenter: value});
    });
    load('assets/density3x/ic_markup_1.png').then((value) {
      imagePool.addAll({markUpTriangle: value});
    });
    load('assets/density3x/ic_markup_1_left.png').then((value) {
      imagePool.addAll({markUpLeft: value});
    });
    load('assets/density3x/ic_markup_1_right.png').then((value) {
      imagePool.addAll({markUpRight: value});
    });
  }

  void clearImageCache() {
    imagePool = null;
  }

  ui.Image getImage(String name) {
    return imagePool[name];
  }

  Future<ui.Image> load(String asset) async {
    var data = await rootBundle.load(asset);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var fi = await codec.getNextFrame();
    return fi.image;
  }
}
