import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components/component.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import '../constants.dart';
import '../components/player.dart';
import '../mixins/has_game_ref.dart';

class UpObstacle extends AnimationComponent with HasGameRef, Resizable {
  UpObstacle(double x, [String texture = 'up_obstacle.png'])
      : super(16.0, 16.0, new Animation.sequenced(texture, 3, textureWidth: 16.0, textureHeight: 16.0)..stepTime = 0.075) {
    this.x = x;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    width = height = sizeTenth(size);
    y = sizeTop(size);
  }

  @override
  void update(double t) {
    super.update(t);
    Player player = gameRef.player;
    if (this.toRect().overlaps(player.toRect())) {
      if (player.velocity.x.abs() >= player.velocity.y.abs()) {
        player.x = x - player.width;
      } else if (player.y > size.height / 2) {
        player.y = y - player.height;
        player.angle = math.pi / 2;
      } else {
        player.y = y + height;
        player.angle = 3 * math.pi / 2;
      }
      player.velocity = new Position(0.0, 0.0);
      player.die();
    }
  }
}

class Obstacle extends UpObstacle {
  Obstacle(double x) : super(x, 'obstacle.png');

  @override
  void resize(Size size) {
    super.resize(size);
    y = sizeBottom(size) - height;
  }
}
