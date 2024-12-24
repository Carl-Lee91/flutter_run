import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'forest_run_game.dart';
import 'stone_text.dart';

class GameOverPanel extends PositionComponent
    with HasGameReference<ForestRunGame> {
  bool visible = false;

  @override
  Future<void> onLoad() async {
    final source = game.images.fromCache('font/keypound.png');

    add(StoneText(text: 'GAME', source: source, position: Vector2(-144, -16)));
    add(StoneText(text: 'OVER', source: source, position: Vector2(16, -16)));
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = size.x / 2;
    y = size.y / 2;
  }
}
