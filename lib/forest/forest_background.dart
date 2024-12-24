import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import '../forest_run_game.dart';

class ForestBackground extends ParallaxComponent<ForestRunGame> {
  @override
  Future<void> onLoad() async {
    priority = -10;
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/plx-1.png'),
        ParallaxImageData('background/plx-2.png'),
        ParallaxImageData('background/plx-3.png'),
        ParallaxImageData('background/plx-4.png'),
        ParallaxImageData('background/plx-5.png'),
      ],
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2(1.4, 1),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity = Vector2(game.currentSpeed / 10, 0);
  }
}
