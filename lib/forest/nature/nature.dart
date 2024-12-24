import 'package:flame/components.dart';

import 'bush.dart';
import '../../forest_run_game.dart';

class Nature extends Component with HasGameReference<ForestRunGame> {
  @override
  void update(double dt) {
    super.update(dt);
    if (game.currentSpeed > 0) {
      final plant = children.query<Bush>().lastOrNull;
      if (plant == null || (plant.x + plant.width + plant.gap) < game.size.x) {
        add(Bush());
      }
    }
  }
}
