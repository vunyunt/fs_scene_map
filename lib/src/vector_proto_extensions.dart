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
      values.addAll([(vector.x * 1000.0).round(), (vector.y * 1000.0).round()]);
    } else {
      values[0] = (vector.x * 1000.0).round();
      if (values.length < 2) {
        values.add((vector.y * 1000.0).round());
      } else {
        values[1] = (vector.y * 1000.0).round();
      }
    }
  }

  void mergeFromVector2(Vector2 vector) {
    final savedZ = values.length > 2 ? values[2] : null;
    values.clear();
    values.add((vector.x * 1000.0).toInt());
    values.add((vector.y * 1000.0).toInt());
    if (savedZ != null) {
      values.add(savedZ);
    }
  }

  Vector2 toVector2() => Vector2(xOrZero / 1000.0, yOrZero / 1000.0);
}

extension Vector2Extensions on Vector2 {
  IntVectorProto toIntVector({int? z}) {
    final list = [(x * 1000.0).round(), (y * 1000.0).round()];
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
