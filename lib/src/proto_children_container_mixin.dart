import 'dart:async';
import 'package:flame/components.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart';
import 'package:protobuf_serializable_components/protobuf_serializable_components.dart';

/// Mixin to handle children synchronization and persistence for components using
/// [ProtoSerializable] backed by a Protobuf message containing a list of children.
mixin ProtoChildrenContainerMixin<SerializedType extends GeneratedMessage>
    on PositionComponent, ProtoSerializable<SerializedType> {
  
  SerializableComponentRegistry? get registry;

  List<Any> get _protoChildren {
    final field = data.info_.byName['children'];
    if (field == null) {
      throw StateError('Message type ${data.runtimeType} does not have a "children" field.');
    }
    return data.getField(field.tagNumber) as List<Any>;
  }

  Int64? _getProtoId(GeneratedMessage message) {
    try {
      final fieldInfo = message.info_.byName['id'];
      if (fieldInfo != null) {
        final val = message.getField(fieldInfo.tagNumber);
        if (val is Int64) return val;
        if (val is int) return Int64(val);
      }
    } catch (_) {}
    return null;
  }

  /// Reconciles the child components in the Flame tree in-place against
  /// the children defined in the underlying Protobuf [data].
  Future<void> syncChildren() async {
    if (registry == null) return;

    final existingChildren = children.whereType<ProtoSerializable>().toList();
    final dataChildrenAny = List<Any>.from(_protoChildren);

    final List<GeneratedMessage> dataChildProtos = dataChildrenAny
        .map((any) => registry!.anyProtoDeserializer.deserialize(any) as GeneratedMessage)
        .toList();

    final matchedExisting = <ProtoSerializable>{};
    final matchedData = <GeneratedMessage>{};

    // 1. Try to match and update existing components in-place
    for (final childProto in dataChildProtos) {
      final childId = _getProtoId(childProto);
      
      ProtoSerializable? match;
      if (childId != null && childId != Int64.ZERO) {
        for (final c in existingChildren) {
          final cid = _getProtoId(c.data);
          if (cid == childId) {
            match = c;
            break;
          }
        }
      } else {
        // Match by message type for ID-less components (like SplineSegment)
        for (final c in existingChildren) {
          if (!matchedExisting.contains(c) &&
              c.data.info_.qualifiedMessageName == childProto.info_.qualifiedMessageName) {
            match = c;
            break;
          }
        }
      }

      if (match != null) {
        matchedExisting.add(match);
        matchedData.add(childProto);
        
        // Update in-place
        match.modify((data) {
          data.clear();
          data.mergeFromMessage(childProto);
        });
      }
    }

    // 2. Remove unmatched existing children
    for (final child in existingChildren) {
      if (!matchedExisting.contains(child)) {
        if (child is Component) {
          (child as Component).removeFromParent();
        }
      }
    }

    // 3. Add unmatched new children
    for (final childProto in dataChildProtos) {
      if (!matchedData.contains(childProto)) {
        final deserialized = await registry!.deserialize(childProto);
        if (deserialized is Component) {
          add(deserialized);
        }
      }
    }
  }

  /// Packs the children from the Flame tree back into the underlying [data].
  void packChildren() {
    final childrenList = _protoChildren;
    childrenList.clear();
    for (final child in children.whereType<ProtoSerializable>()) {
      final childSerialized = child.serialize();
      childrenList.add(Any.pack(childSerialized));
    }
  }

  @override
  SerializedType serialize() {
    packChildren();
    return super.serialize();
  }

  @override
  void modify(void Function(SerializedType data) updates) {
    final childrenBefore = List<Any>.from(_protoChildren);

    super.modify((data) {
      updates(data);

      // Check if data.children was modified by the updates function.
      // If it WAS modified (meaning updates came from the inspector), we do NOT run packChildren()
      // because we want to preserve the updated values from the editor and sync them to the Flame tree.
      // If it was NOT modified (e.g. child edit triggered updates), then we run packChildren()
      // to pull the updated child properties from the Flame tree.
      bool childrenModified = false;
      final currentChildren = _protoChildren;
      if (currentChildren.length != childrenBefore.length) {
        childrenModified = true;
      } else {
        for (int i = 0; i < currentChildren.length; i++) {
          if (currentChildren[i] != childrenBefore[i]) {
            childrenModified = true;
            break;
          }
        }
      }

      if (!childrenModified) {
        packChildren();
      }
    });
  }
}
