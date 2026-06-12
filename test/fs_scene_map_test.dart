import 'package:test/test.dart';
import 'package:fs_scene_map/fs_scene_map.dart';

void main() {
  group('SpatialChunkManager', () {
    test('calculate chunk criteria from position', () {
      final manager = GenericSpatialChunkManager(
        basePath: 'test_chunks',
        gridWidth: 100,
        gridHeight: 100,
      );

      expect(manager.getCriteriaFromPosition(0, 0), equals((0, 0)));
      expect(manager.getCriteriaFromPosition(99, 99), equals((0, 0)));
      expect(manager.getCriteriaFromPosition(100, 100), equals((1, 1)));
      expect(manager.getCriteriaFromPosition(-1, -1), equals((-1, -1)));
      expect(manager.getCriteriaFromPosition(-100, -100), equals((-1, -1)));
      expect(manager.getCriteriaFromPosition(-101, -101), equals((-2, -2)));
    });

    test('parse criteria from file name', () {
      final manager = GenericSpatialChunkManager(
        basePath: 'test_chunks',
      );

      expect(manager.parseCriteriaFromFileName('spatial_chunk_0_0.binpb'), equals((0, 0)));
      expect(manager.parseCriteriaFromFileName('spatial_chunk_-1_5.binpb'), equals((-1, 5)));
      expect(manager.parseCriteriaFromFileName('invalid_file.binpb'), isNull);
    });
  });
}
