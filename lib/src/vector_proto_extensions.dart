import 'package:flame/game.dart';
import 'proto_gen/fs/scene_map/scene_map.pb.dart';

extension IntVectorProtoExtensions on IntVectorProto {
  int get x => values.isNotEmpty ? values[0] : 0;
  int get y => values.length > 1 ? values[1] : 0;
  int get z => values.length > 2 ? values[2] : 0;

  int get xOrZero => values.isNotEmpty ? values[0] : 0;
  int get yOrZero => values.length > 1 ? values[1] : 0;
  int get zOrZero => values.length > 2 ? values[2] : 0;

  set z(int value) {
    while (values.length < 3) {
      values.add(0);
    }
    values[2] = value;
  }

  void updateFromVector2(Vector2 vector) {
    if (values.isEmpty) {
      values.addAll([vector.x.round(), vector.y.round()]);
    } else {
      values[0] = vector.x.round();
      if (values.length < 2) {
        values.add(vector.y.round());
      } else {
        values[1] = vector.y.round();
      }
    }
  }

  void mergeFromVector2(Vector2 vector) {
    values.clear();
    values.add(vector.x.toInt());
    values.add(vector.y.toInt());
  }

  Vector2 toVector2() => Vector2(xOrZero.toDouble(), yOrZero.toDouble());
}

extension Vector2Extensions on Vector2 {
  IntVectorProto toIntVector({int? z}) {
    final list = [x.round(), y.round()];
    if (z != null) {
      list.add(z);
    }
    return IntVectorProto(values: list);
  }

  FloatVectorProto toFloatVector() {
    return FloatVectorProto(values: [x, y]);
  }
}

extension FloatVectorProtoExtensions on FloatVectorProto {
  double get x => values.isNotEmpty ? values[0] : 0.0;
  double get y => values.length > 1 ? values[1] : 0.0;

  double get xOrZero => values.isNotEmpty ? values[0] : 0.0;
  double get yOrZero => values.length > 1 ? values[1] : 0.0;

  void updateFromVector2(Vector2 vector) {
    if (values.isEmpty) {
      values.addAll([vector.x, vector.y]);
    } else {
      values[0] = vector.x;
      if (values.length < 2) {
        values.add(vector.y);
      } else {
        values[1] = vector.y;
      }
    }
  }

  Vector2 toVector2() => Vector2(xOrZero, yOrZero);
}
