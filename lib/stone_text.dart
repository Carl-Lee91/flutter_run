import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';

class StoneText extends TextBoxComponent {
  static const digits = '123456789';
  static const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  StoneText({
    required Image source,
    required super.position,
    super.text = '',
  }) : super(
          textRenderer: SpriteFontRenderer.fromFont(
            SpriteFont(
              source: source,
              size: 32,
              ascent: 32,
              glyphs: [
                _buildGlyph(char: '0', left: 480, top: 0),
                for (var i = 0; i < digits.length; i++)
                  _buildGlyph(char: digits[i], left: 32.0 * i, top: 32),
                for (var i = 0; i < letters.length; i++)
                  _buildGlyph(
                    char: letters[i],
                    left: 32.0 * (i % 16),
                    top: 64.0 + 32 * (i ~/ 16),
                  ),
              ],
            ),
            letterSpacing: 2,
          ),
        );

  static Glyph _buildGlyph({
    required String char,
    required double left,
    required double top,
  }) =>
      Glyph(char, left: left, top: top, height: 32, width: 32);
}
