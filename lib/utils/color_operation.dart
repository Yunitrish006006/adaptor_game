import 'dart:ui';

Color addEven(Color base, Color mixin) {
  return Color.alphaBlend(base.withAlpha(125), mixin.withAlpha(125));
}

Color add3_2(Color base, Color mixin) {
  return Color.alphaBlend(base.withAlpha(150), mixin.withAlpha(105));
}

Color add4_1(Color base, Color mixin) {
  return Color.alphaBlend(base.withAlpha(200), mixin.withAlpha(55));
}
