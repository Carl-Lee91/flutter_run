import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'forest_run_game.dart';

enum PlayerState { jumping, running, idle }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<ForestRunGame>, CollisionCallbacks {
  static const gravity = 1400.0;
  static const initialJumpVelocity = -700.0;
  static const startXPosition = 80.0;

  Player() : super(size: Vector2(69, 102));

  double jumpSpeed = 0.0;

  double get groundYPosition => game.foreground.y - height + 20;

  @override
  void onLoad() {
    super.onLoad();
    add(
      RectangleHitbox(
        position: Vector2(2, 2),
        size: Vector2(60, 100),
      ),
    );

    animations = {
      PlayerState.running: SpriteAnimation.fromFrameData(
        game.images.fromCache('character/run.png'),
        SpriteAnimationData.sequenced(
          amount: 8,
          amountPerRow: 5,
          stepTime: 0.1,
          textureSize: Vector2(23, 34),
        ),
      ),
      PlayerState.idle: SpriteAnimation.fromFrameData(
        game.images.fromCache('character/idle.png'),
        SpriteAnimationData.sequenced(
          amount: 12,
          amountPerRow: 5,
          stepTime: 0.1,
          textureSize: Vector2(21, 35),
        ),
      ),
      PlayerState.jumping: SpriteAnimation.spriteList(
        [
          Sprite(game.images.fromCache('character/jump.png')),
          Sprite(game.images.fromCache('character/land.png')),
        ],
        stepTime: 0.4,
        loop: false,
      ),
    };
    current = PlayerState.idle;
  }

  void jump() {
    if (current != PlayerState.jumping) {
      current = PlayerState.jumping;
      jumpSpeed = initialJumpVelocity - (game.currentSpeed / 1000);
    }
  }

  void reset() {
    y = groundYPosition;
    jumpSpeed = 0;
    current = PlayerState.running;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == PlayerState.jumping) {
      y += jumpSpeed * dt;
      jumpSpeed += gravity * dt;
      if (y > groundYPosition) {
        reset();
      }
    } else {
      y = groundYPosition;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = startXPosition;
    y = groundYPosition;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    game.gameOver();
  }
}
