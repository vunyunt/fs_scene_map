import 'package:fixnum/fixnum.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fs_scene_map/fs_scene_map.dart';
import 'package:protobuf_serializable_components/protobuf_serializable_components.dart';

// Lightweight stand-ins for a root component (lives inside a chunk) and a
// nested child (lives inside the root). Both mix in ProtoSerializable so
// SpatialChunkController.reparentComponent accepts them.
class _TestRoot extends PositionComponent
    with ProtoSerializable<PositionedComponentProto> {
  @override
  final PositionedComponentProto data;
  _TestRoot(this.data, {Vector2? position}) : super(position: position);
}

class _TestChild extends PositionComponent
    with ProtoSerializable<PositionedComponentProto> {
  @override
  final PositionedComponentProto data;
  _TestChild(this.data, {Vector2? position}) : super(position: position);
}

void main() {
  group('SpatialChunkController nested-component dirty marking', () {
    testWithGame<FlameGame>(
      'reparentComponent on a nested child marks the root ancestor chunk dirty',
      () => FlameGame(),
      (game) async {
        final saved = <(int, int), SpatialChunkProto>{};
        final manager = GenericSpatialChunkManager(
          basePath: 'test_nested_chunks',
          gridWidth: 100,
          gridHeight: 100,
          saver: (criteria, proto) async {
            saved[criteria] = proto;
          },
        );

        final controller =
            SpatialChunkController<PositionedComponentProto, SpatialChunkProto>(
          chunkManager: manager,
          isEditMode: true,
          chunkBuilder: (proto, criteria) => GenericSpatialChunkComponent(
            proto,
            criteria: criteria,
          ),
        );

        // Chunk at (0,0). No registry -> onLoad won't deserialize children;
        // we add the root manually below.
        final chunkProto = SpatialChunkProto();
        final chunk = GenericSpatialChunkComponent(
          chunkProto,
          criteria: (0, 0),
        );
        await game.world.ensureAdd(chunk);
        // Register the chunk with the manager so saveDirtyChunks can find it.
        manager.preloadChunk((0, 0), chunkProto);

        // Root component lives in chunk (0,0) (world position (10,10)).
        final root = _TestRoot(
          (PositionedComponentProto()..id = Int64(1))
            ..position = (IntVectorProto(values: [10, 10])),
          position: Vector2(10, 10),
        );
        await chunk.ensureAdd(root);

        // Nested child: its LOCAL position is (150,150). With the buggy
        // position-based logic this would map to chunk (1,1); the correct
        // chunk is the root ancestor's chunk (0,0).
        final child = _TestChild(
          (PositionedComponentProto()..id = Int64(2))
            ..position = (IntVectorProto(values: [150, 150])),
          position: Vector2(150, 150),
        );
        await root.ensureAdd(child);

        // Add controller last so its onMount registers the already-added chunk.
        await game.world.ensureAdd(controller);

        expect(manager.dirtyChunks, isEmpty);

        await controller.reparentComponent(child);

        expect(manager.dirtyChunks, contains((0, 0)));
        expect(manager.dirtyChunks, isNot(contains((1, 1))));

        await manager.saveDirtyChunks();

        expect(saved.keys, contains((0, 0)));
        expect(manager.dirtyChunks, isEmpty);
      },
    );

    testWithGame<FlameGame>(
      'markDirty on a nested child marks the root ancestor chunk, not the '
      'chunk implied by its local position',
      () => FlameGame(),
      (game) async {
        final manager = GenericSpatialChunkManager(
          basePath: 'test_nested_chunks_mark',
          gridWidth: 100,
          gridHeight: 100,
        );

        final controller =
            SpatialChunkController<PositionedComponentProto, SpatialChunkProto>(
          chunkManager: manager,
          isEditMode: true,
          chunkBuilder: (proto, criteria) => GenericSpatialChunkComponent(
            proto,
            criteria: criteria,
          ),
        );

        final chunk = GenericSpatialChunkComponent(
          SpatialChunkProto(),
          criteria: (0, 0),
        );
        await game.world.ensureAdd(chunk);

        final root = _TestRoot(
          (PositionedComponentProto()..id = Int64(1))
            ..position = (IntVectorProto(values: [10, 10])),
          position: Vector2(10, 10),
        );
        await chunk.ensureAdd(root);

        final child = _TestChild(
          (PositionedComponentProto()..id = Int64(2))
            ..position = (IntVectorProto(values: [150, 150])),
          position: Vector2(150, 150),
        );
        await root.ensureAdd(child);

        await game.world.ensureAdd(controller);

        expect(manager.dirtyChunks, isEmpty);

        controller.markDirty(child);

        expect(manager.dirtyChunks, contains((0, 0)));
        expect(manager.dirtyChunks, isNot(contains((1, 1))));
      },
    );

    testWithGame<FlameGame>(
      'markDirty on a root component still marks its own chunk '
      '(no behavior change for non-nested components)',
      () => FlameGame(),
      (game) async {
        final manager = GenericSpatialChunkManager(
          basePath: 'test_nested_chunks_root',
          gridWidth: 100,
          gridHeight: 100,
        );

        final controller =
            SpatialChunkController<PositionedComponentProto, SpatialChunkProto>(
          chunkManager: manager,
          isEditMode: true,
          chunkBuilder: (proto, criteria) => GenericSpatialChunkComponent(
            proto,
            criteria: criteria,
          ),
        );

        final chunk = GenericSpatialChunkComponent(
          SpatialChunkProto(),
          criteria: (1, 1),
        );
        await game.world.ensureAdd(chunk);

        // Root component at world position (110,110) -> chunk (1,1).
        final root = _TestRoot(
          (PositionedComponentProto()..id = Int64(1))
            ..position = (IntVectorProto(values: [110, 110])),
          position: Vector2(110, 110),
        );
        await chunk.ensureAdd(root);

        await game.world.ensureAdd(controller);

        expect(manager.dirtyChunks, isEmpty);

        controller.markDirty(root);

        expect(manager.dirtyChunks, contains((1, 1)));
      },
    );
  });
}
