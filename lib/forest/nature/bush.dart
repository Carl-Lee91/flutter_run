import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../forest_run_game.dart';

class Bush extends SpriteComponent with HasGameReference<ForestRunGame> {
  final Random _random = Random();
  late double gap;

  Bush() : super(size: Vector2(200, 84));

  bool get isVisible => x + width > 0;

  @override
  Future<void> onLoad() async {
    x = game.size.x + width;
    y = -height + 20;
    gap = _computeRandomGap();

    sprite = Sprite(game.images.fromCache('forest/bush.png'));

    add(
      RectangleHitbox(
        position: Vector2(30, 30),
        size: Vector2(150, 54),
        collisionType: CollisionType.passive,
      ),
    );
  }

  double _computeRandomGap() {
    final minGap = width * game.currentSpeed * 100;
    final maxGap = minGap * 10;
    return (_random.nextDouble() * (maxGap - minGap + 1)).floor() + minGap;
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= game.currentSpeed * dt;

    if (!isVisible) {
      removeFromParent();
    }
  }
}
