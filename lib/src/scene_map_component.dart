import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart';
import 'package:protobuf_serializable_components/protobuf_serializable_components.dart';
import 'proto_gen/fs/scene_map/scene_map.pb.dart';
import 'spatial_chunk_manager.dart';
import 'spatial_chunk_controller.dart';
import 'spatial_chunk_component.dart';
import 'vector_proto_extensions.dart';

abstract class BaseSceneMapComponent<
  T extends GeneratedMessage,
  I extends GeneratedMessage,
  P extends GeneratedMessage
> extends PositionComponent
    with
        ProtoSerializable<T>,
        HasGameReference<FlameGame>,
        HasGridChunks {
  @override
  final T data;
  final SerializableComponentRegistry? registry;

  final Future<P?> Function(String fileName)? spatialChunkLoader;
  final Future<void> Function(String fileName, P proto)? spatialChunkSaver;
  final bool Function()? checkEditorMode;
  final SpatialChunkController<I, P> Function(SpatialChunkManager<I, P> manager) createController;

  BaseSceneMapComponent(
    this.data, {
    this.registry,
    this.spatialChunkLoader,
    this.spatialChunkSaver,
    this.checkEditorMode,
    required this.createController,
  });

  // Abstract getters to read fields from T (the scene map proto)
  List<int>? get worldBoundsValues;
  int get chunkSize;
  String get chunksDirectory;
  List<Any> get childrenAnys;

  // Method to check if a serialized component is generic item I
  bool isPositionedItem(dynamic proto);
  dynamic getPositionedItemId(dynamic proto);

  SpatialChunkController<I, P>? _spatialChunkController;

  @override
  SpatialChunkController? get spatialChunkController =>
      _spatialChunkController ??
      children.whereType<SpatialChunkController>().firstOrNull;

  Future<P?> loadSpatialChunk(String fileName) =>
      spatialChunkLoader?.call(fileName) ?? Future.value(null);

  Future<void> saveSpatialChunk(String fileName, P proto) =>
      spatialChunkSaver?.call(fileName, proto) ?? Future.value();

  bool get isEditorMode => checkEditorMode?.call() ?? false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final bounds = worldBoundsValues;
    if (bounds != null && bounds.length >= 4) {
      size = Vector2(
        (bounds[2] - bounds[0]) / 1000.0,
        (bounds[3] - bounds[1]) / 1000.0,
      );
    }

    if (chunkSize > 0 && _spatialChunkController == null) {
      final manager = SpatialChunkManager<I, P>(
        basePath: chunksDirectory,
        gridWidth: chunkSize ~/ 1000,
        gridHeight: chunkSize ~/ 1000,
        loader: (criteria) async {
          final fileName = _spatialChunkController!.chunkManager.getFileName(criteria);
          return await loadSpatialChunk(fileName);
        },
        saver: (criteria, proto) async {
          final fileName = _spatialChunkController!.chunkManager.getFileName(criteria);
          await saveSpatialChunk(fileName, proto);
        },
        getPosition: getPositionOfItem,
        getId: getIdOfItem,
        addItem: addItemToProto,
        removeItem: removeItemFromProto,
        createProto: createEmptyChunkProto,
      );

      _spatialChunkController = createController(manager);
      add(_spatialChunkController!);
    }

    if (registry != null) {
      // Copy the list to avoid concurrent modification errors if children are added while we await
      final childrenProtos = List<Any>.from(childrenAnys);
      for (final childAny in childrenProtos) {
        final child = await registry!.deserializeFromAny(childAny);
        if (child is Component) {
          add(child);
        }
      }
    }
  }

  // Abstract methods delegated to manager
  (double, double) getPositionOfItem(I item);
  dynamic getIdOfItem(I item);
  void addItemToProto(P proto, I item);
  void removeItemFromProto(P proto, dynamic id);
  P createEmptyChunkProto();

  // Deduplicate children
  void deduplicateChildren() {
    final controller = spatialChunkController;
    if (controller == null) return;

    final chunkedIds = <dynamic>{};
    final p = parent;
    
    final chunkComponents = <Component>[];
    final siblingList = p?.children ?? children;
    for (final sibling in siblingList) {
      if (sibling is HasChunkCriteria) {
        if ((sibling as HasChunkCriteria).criteria != null) {
          chunkComponents.add(sibling);
        }
      }
    }

    for (final chunk in chunkComponents) {
      for (final component in chunk.children.whereType<ProtoSerializable>()) {
        final proto = component.serialize();
        if (isPositionedItem(proto)) {
          chunkedIds.add(getPositionedItemId(proto));
        }
      }
    }

    childrenAnys.removeWhere((any) {
      final decoded = registry?.anyProtoDeserializer.deserialize(any);
      if (isPositionedItem(decoded) && chunkedIds.contains(getPositionedItemId(decoded))) {
        return true;
      }
      return false;
    });
  }
}

/// A concrete SceneMapComponent using the built-in fs_scene_map protos.
class SceneMapComponent extends BaseSceneMapComponent<SceneMapProto, PositionedComponentProto, SpatialChunkProto> {
  SceneMapComponent(
    super.data, {
    super.registry,
    super.spatialChunkLoader,
    super.spatialChunkSaver,
    super.checkEditorMode,
  }) : super(
          createController: (manager) => SpatialChunkController<PositionedComponentProto, SpatialChunkProto>(
            chunkManager: manager,
            registry: registry,
            loadBuffer: data.chunkSize.toDouble() / 1000.0,
            checkEditorMode: checkEditorMode,
            chunkBuilder: (proto, criteria) => GenericSpatialChunkComponent(
              proto,
              registry: registry,
              criteria: criteria,
            ),
          ),
        );

  @override
  List<int>? get worldBoundsValues => data.hasWorldBounds() ? data.worldBounds.values : null;

  @override
  int get chunkSize => data.chunkSize;

  @override
  String get chunksDirectory => data.chunksDirectory;

  @override
  List<Any> get childrenAnys => data.children;

  @override
  bool isPositionedItem(dynamic proto) => proto is PositionedComponentProto;

  @override
  dynamic getPositionedItemId(dynamic proto) => proto is PositionedComponentProto ? proto.id : null;

  @override
  (double, double) getPositionOfItem(PositionedComponentProto item) {
    final pos = item.position.toVector2();
    return (pos.x, pos.y);
  }

  @override
  dynamic getIdOfItem(PositionedComponentProto item) => item.id;

  @override
  void addItemToProto(SpatialChunkProto proto, PositionedComponentProto item) {
    if (item.id != Int64.ZERO) {
      proto.components.removeWhere((c) => c.id == item.id);
    }
    proto.components.add(item);
  }

  @override
  void removeItemFromProto(SpatialChunkProto proto, dynamic id) {
    proto.components.removeWhere((c) => c.id == id);
  }

  @override
  SpatialChunkProto createEmptyChunkProto() => SpatialChunkProto();

  @override
  SceneMapProto serialize() {
    final result = data.deepCopy();
    result.children.clear();
    for (final child in children) {
      if (child is ProtoSerializable &&
          child is! SpatialChunkComponent &&
          child.parent is! SpatialChunkComponent) {
        result.children.add(Any.pack((child as ProtoSerializable).serialize()));
      }
    }
    return result;
  }
}
