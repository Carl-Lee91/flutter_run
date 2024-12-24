import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'forest/forest_background.dart';
import 'forest/forest_foreground.dart';
import 'game_over.dart';
import 'player.dart';
import 'stone_text.dart';

enum GameState { playing, intro, gameOver }

class ForestRunGame extends FlameGame
    with KeyboardEvents, TapCallbacks, HasCollisionDetection {
  static const acceleration = 10.0;
  static const maxSpeed = 2000.0;
  static const startSpeed = 400.0;

  late final background = ForestBackground();
  late final foreground = ForestForeground();
  late final player = Player();
  late final gameOverPanel = GameOverPanel();

  late final StoneText scoreText;
  late final StoneText highText;
  late final StoneText highScoreText;

  int _score = 0;
  int _highScore = 0;
  GameState state = GameState.intro;
  double currentSpeed = 0;
  double traveledDistance = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAllImages();
    final font = images.fromCache('font/keypound.png');

    add(background);
    add(foreground);
    add(player);
    add(gameOverPanel);

    scoreText = StoneText(source: font, position: Vector2(20, 20));
    highText = StoneText(text: 'HI', source: font, position: Vector2(256, 20));
    highScoreText = StoneText(
      text: '00000',
      source: font,
      position: Vector2(332, 20),
    );

    add(scoreText);
    add(highScoreText);
    add(highText);

    setScore(0);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      onAction();
    }
    return KeyEventResult.handled;
  }

  @override
  void onTapDown(TapDownEvent event) {
    onAction();
  }

  void onAction() {
    switch (state) {
      case GameState.intro:
      case GameState.gameOver:
        start();
        break;
      case GameState.playing:
        player.jump();
        break;
    }
  }

  void gameOver() {
    paused = true;
    gameOverPanel.visible = true;
    state = GameState.gameOver;
    currentSpeed = 0.0;
  }

  void start() {
    paused = false;
    state = GameState.playing;
    currentSpeed = startSpeed;
    traveledDistance = 0;
    player.reset();
    foreground.nature.removeAll(foreground.nature.children);
    gameOverPanel.visible = false;
    if (_score > _highScore) {
      _highScore = _score;
      highScoreText.text = _highScore.toString().padLeft(5, '0');
    }
    _score = 0;
  }

  void setScore(int score) {
    _score = score;
    scoreText.text = _score.toString().padLeft(5, '0');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == GameState.playing) {
      traveledDistance += currentSpeed * dt;
      setScore(traveledDistance ~/ 50);

      if (currentSpeed < maxSpeed) {
        currentSpeed += acceleration * dt;
      }
    }
  }
}
