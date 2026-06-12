import 'dart:async';
import 'package:flame/components.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf_serializable_components/protobuf_serializable_components.dart';
import 'proto_gen/fs/scene_map/scene_map.pb.dart';

abstract interface class HasChunkCriteria {
  (int, int)? get criteria;
}

class SpatialChunkComponent<P extends GeneratedMessage, I extends GeneratedMessage> extends Component
    with ProtoSerializable<P>
    implements HasChunkCriteria {
  @override
  final P data;
  final SerializableComponentRegistry? registry;

  @override
  final (int, int)? criteria;

  final List<I> Function(P proto) getComponents;

  SpatialChunkComponent(
    this.data, {
    this.registry,
    this.criteria,
    required this.getComponents,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    if (registry != null) {
      // Copy the list to avoid concurrent modification errors if writeItem is called while we await
      final componentProtos = List<I>.from(
        getComponents(data),
      );
      for (final componentProto in componentProtos) {
        final component = await registry!.deserialize(componentProto);
        if (component is Component) {
          add(component);
        }
      }
    }
  }

  @override
  P serialize() {
    return data;
  }
}

/// A concrete SpatialChunkComponent using the built-in fs_scene_map protos.
class GenericSpatialChunkComponent extends SpatialChunkComponent<SpatialChunkProto, PositionedComponentProto> {
  GenericSpatialChunkComponent(
    super.data, {
    super.registry,
    super.criteria,
  }) : super(
          getComponents: (proto) => proto.components,
        );
}
