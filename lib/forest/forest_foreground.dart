import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import '../forest_run_game.dart';
import 'nature/nature.dart';

class ForestForeground extends PositionComponent
    with HasGameReference<ForestRunGame> {
  static final blockSize = Vector2(480, 96);

  late final Sprite groundBlock;
  late final Nature nature;
  late final Queue<SpriteComponent> ground;

  @override
  void onLoad() {
    super.onLoad();
    groundBlock = Sprite(game.images.fromCache('forest/ground.png'));
    nature = Nature();
    ground = Queue();

    add(nature);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final firstBlock = ground.first;
    if (firstBlock.x <= -firstBlock.width) {
      firstBlock.x = ground.last.x + ground.last.width;
      ground.remove(firstBlock);
      ground.add(firstBlock);
    }

    final shift = game.currentSpeed * dt;
    for (final block in ground) {
      block.x -= shift;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final newBlocks = _generateBlocks();
    ground.addAll(newBlocks);
    addAll(newBlocks);
    y = size.y - blockSize.y;
  }

  List<SpriteComponent> _generateBlocks() {
    final number = 1 + (game.size.x / blockSize.x).ceil() - ground.length;
    final lastBlock = ground.lastOrNull;
    final lastX = lastBlock == null ? 0 : lastBlock.x + lastBlock.width;

    return List.generate(
      max(number, 0),
      (i) => SpriteComponent(
        sprite: groundBlock,
        size: blockSize,
        position: Vector2(lastX + blockSize.x * i, y),
        priority: -5,
      ),
      growable: false,
    );
  }
}
